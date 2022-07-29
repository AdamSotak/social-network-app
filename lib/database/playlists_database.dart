import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_network/auth/auth.dart';
import 'package:social_network/models/playlist.dart';

class PlaylistsDatabase {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final String playlistsCollectionName = "playlists";

  // Get Playlists data Stream for loading
  Stream<QuerySnapshot> getPlaylistStream() {
    return firestore.collection(playlistsCollectionName).where('userId', isEqualTo: Auth().getUserId()).snapshots();
  }

  // Add new Playlist
  Future<void> addPlaylist(Playlist playlist) async {
    try {
      await firestore.collection(playlistsCollectionName).doc(playlist.id).set(playlist.toJson());
    } catch (error) {
      log("Add Playlist Exception: $error");
    }
  }

  // Edit Playlist
  Future<void> editPlaylist(Playlist playlist) async {
    try {
      await firestore.collection(playlistsCollectionName).doc(playlist.id).set(playlist.toJson());
    } catch (error) {
      log("Edit Playlist Exception: $error");
    }
  }

  // Delete Playlist
  Future<void> deletePlaylist(Playlist playlist) async {
    try {
      await firestore.collection(playlistsCollectionName).doc(playlist.id).delete();
    } catch (error) {
      log("Delete Playlist Exception: $error");
    }
  }
}
