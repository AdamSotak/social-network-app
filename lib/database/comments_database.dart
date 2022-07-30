import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_network/models/comment.dart';

class CommentsDatabase {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final String commentsCollectionName = "comments";

  // Get Comments data Stream for loading
  Stream<QuerySnapshot> getCommentStream({required String postId}) {
    return firestore.collection(commentsCollectionName).where('postId', isEqualTo: postId).snapshots();
  }

  // Add new Comment
  Future<void> addComment(Comment comment) async {
    try {
      await firestore.collection(commentsCollectionName).doc(comment.id).set(comment.toJson());
    } catch (error) {
      log("Add Comment Exception: $error");
    }
  }

  // Edit Comment
  Future<void> editComment(Comment comment) async {
    try {
      await firestore.collection(commentsCollectionName).doc(comment.id).set(comment.toJson());
    } catch (error) {
      log("Edit Comment Exception: $error");
    }
  }

  // Delete Comment
  Future<void> deleteComment(Comment comment) async {
    try {
      await firestore.collection(commentsCollectionName).doc(comment.id).delete();
    } catch (error) {
      log("Delete Comment Exception: $error");
    }
  }
}
