const functions = require('firebase-functions');
const admin = require('firebase-admin');

const commentsCollectionName = 'comments';
const likesCollectionName = 'likes';

// Delete all comments matching a postId
async function deleteComments(id) {
    let db = admin.firestore();
    let docs = await db.collection(commentsCollectionName).where('postId', '==', id).get();
    const batch = db.batch();
    docs.forEach(doc => {
        batch.delete(doc.ref);
    });

    await batch.commit();
}

// Delete all likes matching a postId
async function deleteLikes(id) {
    let db = admin.firestore();
    let docs = await db.collection(likesCollectionName).where('postId', '==', id).get();
    const batch = db.batch();
    docs.forEach(doc => {
        batch.delete(doc.ref);
    });

    await batch.commit();
}

// Delete comments and likes on post deletion
exports.onPostDelete = functions.firestore.document('posts/{postId}').onDelete(async (snap, context) => {
    let post = snap.data();
    let id = post.id;

    await deleteComments(id);
    await deleteLikes(id);
});

// Delete comments and likes on song deletion
exports.onSongDelete = functions.firestore.document('songs/{songId}').onDelete(async (snap, context) => {
    let song = snap.data();
    let id = song.id;

    await deleteComments(id);
    await deleteLikes(id);
});

// Delete comments and likes on album deletion
exports.onAlbumDelete = functions.firestore.document('albums/{albumId}').onDelete(async (snap, context) => {
    let album = snap.data();
    let id = album.id;

    await deleteComments(id);
    await deleteLikes(id);
});