const functions = require('firebase-functions');
const admin = require('firebase-admin');
const axios = require('axios');

const userDataCollectionName = 'user_data';
const azureStorageURL = "https://fluttersocialnetworkapp.azurewebsites.net";

// Send an HTTP Delete request to Azure backend to delete from Azure Blob Storage
function deleteFromAzureStorage(contentURL, requestURL, token) {
    axios.delete(`${azureStorageURL}${requestURL}`, {
        data: {
            url: contentURL,
            userToken: token
        }
    });
}

// Delete user created data from all database collections and delete user created data from Azure Blob Storage
async function deleteFromCollections(userId, collectionNames, token) {
    let db = admin.firestore();

    for (var i = 0; i < collectionNames.length; i++) {
        let collectionName = collectionNames[i];

        if (collectionName === "user_data") {
            const batch = db.batch();
            let docs = await db.collection(collectionName).where('id', '==', userId).get();
            docs.forEach(doc => {
                batch.delete(doc.ref);
                let data = doc.data();
                let profilePhotoURL = data["profilePhotoURL"];
                if (profilePhotoURL !== "") {
                    deleteFromAzureStorage(profilePhotoURL, "/images/delete", token);
                }
            });
            await batch.commit();
        } else {
            const batch = db.batch();
            let docs = await db.collection(collectionName).where('userId', '==', userId).get();
            docs.forEach(doc => {
                batch.delete(doc.ref);
                let data = doc.data();
                switch (collectionName) {
                    case "posts":
                        let video = data["video"];
                        let contentURL = data["contentURL"];
                        if (video === true && (contentURL !== "")) {
                            deleteFromAzureStorage(contentURL, "/videos/delete", token);
                        } else if (video === false && (contentURL !== "")) {
                            deleteFromAzureStorage(contentURL, "/images/delete", token);
                        }
                        break;
                    case "songs":
                        deleteFromAzureStorage(data.contentURL, "/songs/delete", token);
                        break;
                    case "loops":
                        deleteFromAzureStorage(data.contentURL, "/loops/delete", token);
                        break;
                }
            });
            await batch.commit();
        }
    }
}

// Check username availability
exports.checkUsername = functions.https.onRequest(async (req, res) => {
    const username = req.params['0'];
    let db = admin.firestore();
    db.collection(userDataCollectionName).where('username', '==', username).get().then(snap => {
        if (!snap.empty) {
            res.json({ status: 200, usernameAvailable: false });
        } else {
            res.json({ status: 200, usernameAvailable: true });
        }
    });
});

// Delete user created data when user deletes their account
exports.deleteUserData = functions.https.onCall(async (data, context) => {
    let userId = context.auth.uid;
    let token = data.token;

    await deleteFromCollections(userId, ["posts", "songs", "albums", "playlists", "follows", "likes", "loops", "user_data"], token);
})