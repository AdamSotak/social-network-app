import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_network/auth/auth.dart';
import 'package:social_network/models/album.dart';
import 'package:social_network/storage/image_storage.dart';

class AlbumsDatabase {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final String albumsCollectionName = "albums";

  // Get Albums data Stream for loading
  Stream<QuerySnapshot> getAlbumStream() {
    return firestore.collection(albumsCollectionName).where('userId', isEqualTo: Auth().getUserId()).snapshots();
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
