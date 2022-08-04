const functions = require('firebase-functions');
const admin = require('firebase-admin');

const userDataCollectionName = 'user_data';

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