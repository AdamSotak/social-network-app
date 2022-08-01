import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_network/database/loops_database.dart';
import 'package:social_network/models/follow.dart';

class FollowsDatabase {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final String followsCollectionName = "follows";

  // Get Followers data Stream for loading
  Stream<QuerySnapshot> getFollowerStream({required String toUserId}) {
    return firestore.collection(followsCollectionName).where('toUserId', isEqualTo: toUserId).snapshots();
  }

  // Get Followings data Stream for loading
  Stream<QuerySnapshot> getFollowingStream({required String fromUserId}) {
    return firestore.collection(followsCollectionName).where('fromUserId', isEqualTo: fromUserId).snapshots();
  }

  Future<List<Follow>> getFollowingsLoopsForUser({required String userId}) async {
    List<Follow> returnValue = [];
    List<Follow> docs = await firestore
        .collection(followsCollectionName)
        .where('fromUserId', isEqualTo: userId)
        .get()
        .then((value) async {
      return value.docs.map((follow) => Follow.fromDocumentSnapshot(follow)).toList();
    });

    for (var follow in docs) {
      var loops = await LoopsDatabase().getLoopsForUser(userId: follow.toUserId);
      if (loops.isNotEmpty) {
        returnValue.add(follow);
      }
    }

    return returnValue;
  }

  // Add new Follow
  Future<void> addFollow(Follow follow) async {
    try {
      await firestore.collection(followsCollectionName).doc(follow.id).set(follow.toJson());
    } catch (error) {
      log("Add Follow Exception: $error");
    }
  }

  // Get Follow
  Future<Follow> getFollow({required String fromUserId, required String toUserId}) async {
    var doc = await firestore
        .collection(followsCollectionName)
        .where('fromUserId', isEqualTo: fromUserId)
        .where('toUserId', isEqualTo: toUserId)
        .get()
        .then((value) {
      return value.docs.first;
    });
    return Follow.fromDocumentSnapshot(doc);
  }

  // Check if profile followed
  Future<bool> checkIfFollowed({required String fromUserId, required String toUserId}) async {
    return await firestore
        .collection(followsCollectionName)
        .where('fromUserId', isEqualTo: fromUserId)
        .where('toUserId', isEqualTo: toUserId)
        .get()
        .then((value) {
      if (value.docs.length > 1) {
        throw UnimplementedError();
      }

      if (value.docs.isEmpty) {
        return false;
      } else {
        return true;
      }
    });
  }

  // Delete Follow
  Future<void> deleteFollow({required String fromUserId, required String toUserId}) async {
    var follow = await firestore
        .collection(followsCollectionName)
        .where('fromUserId', isEqualTo: fromUserId)
        .where('toUserId', isEqualTo: toUserId)
        .get();

    await firestore.collection(followsCollectionName).doc(follow.docs.first.id).delete();
  }
}
