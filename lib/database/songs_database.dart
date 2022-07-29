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
