const express = require('express');
const bodyParser = require('body-parser');
const multer = require('multer');
const { Readable } = require('stream');
const { BlobServiceClient } = require('@azure/storage-blob');
const { v1: uuidv1 } = require('uuid');
const admin = require('firebase-admin');
const { getAuth } = require('firebase-admin/auth');

const serviceAccount = require('./credentials/service-account.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const AZURE_STORAGE_CONNECTION_STRING = require('./credentials/azure-storage.json')["connectionString"];

const blobServiceClient = BlobServiceClient.fromConnectionString(
  AZURE_STORAGE_CONNECTION_STRING
);

const app = express();
const upload = multer();

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// Verify Firebase Authentication user ID Token
function verifyUserIdToken(userToken) {
  getAuth().verifyIdToken(userToken, true).then((value) => {
    return true;
  }).catch((error) => {
    return false;
  });
}

app.get('/', (req, res) => {
  res.json({ status: 200 });
});

app.post('/uploadImage', upload.single("file"), async (req, res) => {
  let userToken = req.body.userToken;
  let file = req.file;
  let fileType = file.mimetype.split('/')[1];

  if (verifyUserIdToken(userToken) === false) {
    res.json({ status: 200, url: "", tokenValid: false });
    return;
  }

  const containerName = "images";

  const containerCreateOptions = { access: "blob" };
  const containerClient = blobServiceClient.getContainerClient(containerName);
  await containerClient.createIfNotExists(containerCreateOptions);

  const blockBlobClient = containerClient.getBlockBlobClient(`image${uuidv1()}.${fileType}`);
  const options = { blobHTTPHeaders: { blobContentType: file.mimetype } }
  const stream = Readable.from(file.buffer);
  await blockBlobClient.uploadStream(stream, file.size, undefined, options);
  res.json({ status: 200, url: blockBlobClient.url, tokenValid: true }).status(200);
});

app.delete('/deleteImage', async (req, res) => {
  let url = req.body.url;
  let userToken = req.body.userToken;


  let imageName = url.split('/')[url.split('/').length - 1];

  if (verifyUserIdToken(userToken) === false) {
    res.json({ status: 200, url: "", tokenValid: false });
    return;
  }

  const options = {
    deleteSnapshots: 'include'
  }

  const containerName = "images";
  const containerClient = blobServiceClient.getContainerClient(containerName);
  const blockBlobClient = await containerClient.getBlockBlobClient(imageName);
  await blockBlobClient.deleteIfExists(options);
  res.json({ status: 200, url: "", tokenValid: true }).status(200);
});

app.post('/uploadVideo', upload.single("file"), async (req, res) => {
  let userToken = req.body.userToken;
  let file = req.file;
  let fileType = file.mimetype.split('/')[1];

  if (verifyUserIdToken(userToken) === false) {
    res.json({ status: 200, url: "", tokenValid: false });
    return;
  }

  const containerName = "videos";

  const containerCreateOptions = { access: "blob" };
  const containerClient = blobServiceClient.getContainerClient(containerName);
  await containerClient.createIfNotExists(containerCreateOptions);

  const blockBlobClient = containerClient.getBlockBlobClient(`video${uuidv1()}.${fileType}`);
  const options = { blobHTTPHeaders: { blobContentType: file.mimetype } }
  const stream = Readable.from(file.buffer);
  await blockBlobClient.uploadStream(stream, file.size, undefined, options);
  res.json({ status: 200, url: blockBlobClient.url, tokenValid: true }).status(200);
});

app.delete('/deleteVideo', async (req, res) => {
  let url = req.body.url;
  let userToken = req.body.userToken;

  let videoName = url.split('/')[url.split('/').length - 1];

  if (verifyUserIdToken(userToken) === false) {
    res.json({ status: 200, url: "", tokenValid: false });
    return;
  }

  const options = {
    deleteSnapshots: 'include'
  }

  const containerName = "videos";
  const containerClient = blobServiceClient.getContainerClient(containerName);
  const blockBlobClient = await containerClient.getBlockBlobClient(videoName);
  await blockBlobClient.deleteIfExists(options);
  res.json({ status: 200, url: "", tokenValid: true }).status(200);
});

module.exports = app;