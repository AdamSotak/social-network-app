import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_network/models/loop.dart';
import 'package:social_network/storage/audio_storage.dart';

class LoopsDatabase {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final String loopsCollectionName = "loops";

  // Get Loops data Stream for loading
  Stream<QuerySnapshot> getLoopStreamForUser({required String userId}) {
    return firestore.collection(loopsCollectionName).where('userId', isEqualTo: userId).snapshots();
  }

  // Get Loops for user
  Future<List<Loop>> getLoopsForUser({required String userId}) async {
    return await firestore.collection(loopsCollectionName).where('userId', isEqualTo: userId).get().then((value) {
      return value.docs.map((loop) => Loop.fromDocumentSnapshot(loop)).toList();
    });
  }

  // Get Loops for users
  Future<List<Loop>> getLoopsForUsers({required List<String> users}) async {
    return await firestore.collection(loopsCollectionName).where('userId', whereIn: users).get().then((value) {
      return value.docs.map((loop) => Loop.fromDocumentSnapshot(loop)).toList();
    });
  }

  // Get Loop
  Future<Loop> getLoop({required String loopId}) async {
    return await firestore.collection(loopsCollectionName).where('id', isEqualTo: loopId).get().then((value) {
      return value.docs.map((loop) => Loop.fromDocumentSnapshot(loop)).toList().first;
    });
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
