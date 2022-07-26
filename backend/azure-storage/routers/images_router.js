const express = require('express');
const router = express.Router();
const multer = require('multer');
const upload = multer();
const auth = require('../auth/auth');

const { Readable } = require('stream');
const { BlobServiceClient } = require('@azure/storage-blob');
const { v1: uuidv1 } = require('uuid');

const AZURE_STORAGE_CONNECTION_STRING = require('../credentials/azure-storage.json')["connectionString"];

const blobServiceClient = BlobServiceClient.fromConnectionString(
    AZURE_STORAGE_CONNECTION_STRING
);

// Image upload, receive multipart file and save to Azure Blob Storage, create a container if it was not found
router.post('/upload', upload.single("file"), async (req, res) => {
    let userToken = req.body.userToken;
    let file = req.file;
    let fileType = file.mimetype.split('/')[1];

    if (auth.verifyUserIdToken(userToken) === false) {
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

// Delete image from Azure Blob Storage
router.delete('/delete', async (req, res) => {
    let url = req.body.url;
    let userToken = req.body.userToken;


    let imageName = url.split('/')[url.split('/').length - 1];

    if (auth.verifyUserIdToken(userToken) === false) {
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

module.exports = router;