import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_network/models/like.dart';

class LikesDatabase {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final String likesCollectionName = "likes";

  // Add new Like
  Future<void> addLike(Like like) async {
    try {
      // Check if post liked already
      try {
        await getLike(postId: like.postId, userId: like.userId);
      } catch (_) {
        await firestore.collection(likesCollectionName).doc(like.id).set(like.toJson());
      }
    } catch (error) {
      log("Add Like Exception: $error");
    }
  }

  // Get Like
  Future<Like> getLike({required String userId, required String postId}) async {
    var doc = await firestore
        .collection(likesCollectionName)
        .where('postId', isEqualTo: postId)
        .where('userId', isEqualTo: userId)
        .get()
        .then((value) {
      return value.docs.first;
    });
    return Like.fromDocumentSnapshot(doc);
  }

  // Check if post liked
  Future<bool> checkIfLiked({required String postId, required String userId}) async {
    return await firestore
        .collection(likesCollectionName)
        .where('postId', isEqualTo: postId)
        .where('userId', isEqualTo: userId)
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

  // Delete Like
  Future<void> deleteLike({required String postId, required String userId}) async {
    try {
      var like = await firestore
          .collection(likesCollectionName)
          .where('postId', isEqualTo: postId)
          .where('userId', isEqualTo: userId)
          .get();

      await firestore.collection(likesCollectionName).doc(like.docs.first.id).delete();
    } catch (_) {}
  }
}
