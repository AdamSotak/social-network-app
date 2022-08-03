const functions = require('firebase-functions');
const admin = require('firebase-admin');
const { v1: uuidv1 } = require('uuid');

const hashtagsCollectionName = 'hashtags';

async function createHashtag(hashtagName) {
    let db = admin.firestore();
    const doc = await db.collection(hashtagsCollectionName).doc(hashtagName).get();
    if (doc.exists) {
        let docRef = db.collection(hashtagsCollectionName).doc(hashtagName);
        let doc = await docRef.get();
        docRef.update({ postCount: doc.data()["postCount"] + 1 });
    } else {
        await db.collection(hashtagsCollectionName).doc(hashtagName).set({ id: uuidv1(), name: hashtagName, postCount: 1, created: new Date() });
    }
}

exports.onCreatePostHashtag = functions.firestore.document('posts/{postId}').onCreate((snap, context) => {
    let post = snap.data();
    post.hashtags.forEach(async (hashtag) => {
        await createHashtag(hashtag);
    });

    return null;
});

exports.onCreateSongHashtag = functions.firestore.document('songs/{songId}').onCreate((snap, context) => {
    let song = snap.data();
    song.hashtags.forEach(async (hashtag) => {
        await createHashtag(hashtag);
    });

    return null;
});

exports.onCreateAlbumHashtag = functions.firestore.document('albums/{albumId}').onCreate((snap, context) => {
    let album = snap.data();
    album.hashtags.forEach(async (hashtag) => {
        await createHashtag(hashtag);
    });

    return null;
});

exports.cleanHashtags = functions.pubsub.schedule("0 1 * * *").onRun(async (context) => {
    let db = admin.firestore();
    await db.recursiveDelete(db.collection(hashtagsCollectionName));
    return null;
});