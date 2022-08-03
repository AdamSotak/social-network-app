import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_network/models/song.dart';
import 'package:social_network/storage/audio_storage.dart';
import 'package:social_network/storage/image_storage.dart';

class SongsDatabase {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final String songsCollectionName = "songs";

  // Get Songs data Stream for loading
  Stream<QuerySnapshot> getSongStream({required String userId}) {
    return firestore.collection(songsCollectionName).where('userId', isEqualTo: userId).snapshots();
  }

  // Get Songs
  Future<List<Song>> getSongs({int days = 7}) async {
    return await firestore
        .collection(songsCollectionName)
        .where('created', isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days: days)))
        .orderBy('created')
        .orderBy('likes')
        .get()
        .then((value) {
      return value.docs.map((song) => Song.fromDocumentSnapshot(song)).toList();
    });
  }

  // Get Songs with hashtag
  Future<List<Song>> getHashtagSongs({required String hashtagName}) async {
    return await firestore
        .collection(songsCollectionName)
        .where('hashtags', arrayContains: hashtagName)
        .orderBy('created')
        .orderBy('likes')
        .get()
        .then((value) {
      return value.docs.map((song) => Song.fromDocumentSnapshot(song)).toList();
    });
  }

  // Get liked Songs
  Future<List<Song>> getLikedSongs({required List<String> likedSongs}) async {
    return await firestore.collection(songsCollectionName).where('id', whereIn: likedSongs).get().then((value) {
      return value.docs.map((song) => Song.fromDocumentSnapshot(song)).toList();
    });
  }

  // Get Song
  Future<Song> getSong({required String songId}) async {
    return await firestore.collection(songsCollectionName).where('id', isEqualTo: songId).get().then((value) {
      return value.docs.map((loop) => Song.fromDocumentSnapshot(loop)).toList().first;
    });
  }

  // Add new Song
  Future<void> addSong(Song song) async {
    try {
      song.contentURL = await AudioStorage().uploadSongAudio(song.contentURL);
      if (song.artworkURL != "") {
        song.artworkURL = await ImageStorage().uploadImage(song.artworkURL);
      }

      await firestore.collection(songsCollectionName).doc(song.id).set(song.toJson());
    } catch (error) {
      log("Add Song Exception: $error");
    }
  }

  // Edit Song
  Future<void> editSong(Song song) async {
    try {
      await firestore.collection(songsCollectionName).doc(song.id).set(song.toJson());
    } catch (error) {
      log("Edit Song Exception: $error");
    }
  }

  // Delete Song
  Future<void> deleteSong(Song song) async {
    try {
      await AudioStorage().deleteSongAudio(song.contentURL);
      if (song.artworkURL != "") {
        await ImageStorage().deleteImage(song.artworkURL);
      }

      await firestore.collection(songsCollectionName).doc(song.id).delete();
    } catch (error) {
      log("Delete Song Exception: $error");
    }
  }
}
