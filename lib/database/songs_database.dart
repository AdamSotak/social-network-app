import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_network/auth/auth.dart';
import 'package:social_network/models/song.dart';
import 'package:social_network/storage/audio_storage.dart';

class SongsDatabase {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final String songsCollectionName = "songs";

  // Get Songs data Stream for loading
  Stream<QuerySnapshot> getSongStream() {
    return firestore.collection(songsCollectionName).where('userId', isEqualTo: Auth().getUserId()).snapshots();
  }

  // Add new Song
  Future<void> addSong(Song song) async {
    try {
      song.contentURL = await AudioStorage().uploadSongAudio(song.contentURL);

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

      await firestore.collection(songsCollectionName).doc(song.id).delete();
    } catch (error) {
      log("Delete Song Exception: $error");
    }
  }
}
