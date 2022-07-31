import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_network/models/loop.dart';
import 'package:social_network/storage/audio_storage.dart';

class LoopsDatabase {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final String loopsCollectionName = "loops";

  // Get Loops data Stream for loading
  Stream<QuerySnapshot> getLoopStream({required String userId}) {
    return firestore.collection(loopsCollectionName).where('userId', isEqualTo: userId).snapshots();
  }

  // Add new Loop
  Future<void> addLoop(Loop loop) async {
    try {
      loop.contentURL = await AudioStorage().uploadLoopAudio(loop.contentURL);

      await firestore.collection(loopsCollectionName).doc(loop.id).set(loop.toJson());
    } catch (error) {
      log("Add Loop Exception: $error");
    }
  }

  // Edit Loop
  Future<void> editLoop(Loop loop) async {
    try {
      await firestore.collection(loopsCollectionName).doc(loop.id).set(loop.toJson());
    } catch (error) {
      log("Edit Loop Exception: $error");
    }
  }

  // Delete Loop
  Future<void> deleteLoop(Loop loop) async {
    try {
      await AudioStorage().deleteLoopAudio(loop.contentURL);

      await firestore.collection(loopsCollectionName).doc(loop.id).delete();
    } catch (error) {
      log("Delete Loop Exception: $error");
    }
  }
}
