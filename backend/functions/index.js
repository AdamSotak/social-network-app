const functions = require("firebase-functions");
const admin = require('firebase-admin');
admin.initializeApp();

module.exports = {
    ...require('./post-functions'),
    ...require('./hashtag-functions')
};