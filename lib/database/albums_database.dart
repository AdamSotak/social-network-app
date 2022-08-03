import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_network/models/album.dart';
import 'package:social_network/storage/image_storage.dart';

class AlbumsDatabase {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final String albumsCollectionName = "albums";

  // Get Albums data Stream for loading
  Stream<QuerySnapshot> getAlbumStream({required String userId}) {
    return firestore.collection(albumsCollectionName).where('userId', isEqualTo: userId).snapshots();
  }

  // Get Albums
  Future<List<Album>> getAlbums({int days = 7}) async {
    return await firestore
        .collection(albumsCollectionName)
        .where('created', isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days: days)))
        .orderBy('created')
        .orderBy('likes')
        .get()
        .then((value) {
      return value.docs.map((album) => Album.fromDocumentSnapshot(album)).toList();
    });
  }

  // Get Albums with hashtag
  Future<List<Album>> getHashtagAlbums({required String hashtagName}) async {
    return await firestore
        .collection(albumsCollectionName)
        .where('hashtags', arrayContains: hashtagName)
        .orderBy('created')
        .orderBy('likes')
        .get()
        .then((value) {
      return value.docs.map((album) => Album.fromDocumentSnapshot(album)).toList();
    });
  }

  Future<List<Album>> getLikedAlbums({required List<String> likedAlbums}) async {
    return await firestore.collection(albumsCollectionName).where('id', whereIn: likedAlbums).get().then((value) {
      return value.docs.map((album) => Album.fromDocumentSnapshot(album)).toList();
    });
  }

  // Get Album
  Future<Album> getAlbum({required String albumId}) async {
    return await firestore.collection(albumsCollectionName).where('id', isEqualTo: albumId).get().then((value) {
      return value.docs.map((loop) => Album.fromDocumentSnapshot(loop)).toList().first;
    });
  }

  // Add new Album
  Future<void> addAlbum(Album album) async {
    try {
      album.artworkURL = await ImageStorage().uploadImage(album.artworkURL);

      await firestore.collection(albumsCollectionName).doc(album.id).set(album.toJson());
    } catch (error) {
      log("Add Album Exception: $error");
    }
  }

  // Edit Album
  Future<void> editAlbum(Album album) async {
    try {
      await firestore.collection(albumsCollectionName).doc(album.id).set(album.toJson());
    } catch (error) {
      log("Edit Album Exception: $error");
    }
  }

  // Delete Album
  Future<void> deleteAlbum(Album album) async {
    try {
      await ImageStorage().deleteImage(album.artworkURL);

      await firestore.collection(albumsCollectionName).doc(album.id).delete();
    } catch (error) {
      log("Delete Album Exception: $error");
    }
  }
}
