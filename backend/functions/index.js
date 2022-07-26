const functions = require("firebase-functions");
const admin = require('firebase-admin');
admin.initializeApp();

// Setup the functions
module.exports = {
    ...require('./post-functions'),
    ...require('./hashtag-functions'),
    ...require('./user-functions')
};