const admin = require('firebase-admin');
const { getAuth } = require('firebase-admin/auth');

const serviceAccount = require('../credentials/service-account.json');

// Setup Firebase connection
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});

// Verify Firebase Authentication user ID Token
function verifyUserIdToken(userToken) {
    getAuth().verifyIdToken(userToken, true).then((value) => {
        return true;
    }).catch((error) => {
        return false;
    });
}

module.exports = { verifyUserIdToken };