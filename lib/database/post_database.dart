import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_network/auth/auth.dart';
import 'package:social_network/models/post.dart';

class PostDatabase {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final String postsCollectionName = "posts";

  // Get Posts data Stream for loading
  Stream<QuerySnapshot> getPostStream() {
    return firestore.collection(postsCollectionName).where('userId', isEqualTo: Auth().getUserId()).snapshots();
  }

  // Add new Post
  Future<void> addPost(Post post) async {
    try {
      await firestore.collection(postsCollectionName).doc(post.id).set(post.toJson());
    } catch (error) {
      log("Add Post Exception: $error");
    }
  }

  // Edit Post
  Future<void> editPost(Post post) async {
    try {
      await firestore.collection(postsCollectionName).doc(post.id).set(post.toJson());
    } catch (error) {
      log("Edit Post Exception: $error");
    }
  }

  // Delete Post
  Future<void> deletePost(Post post) async {
    try {
      await firestore.collection(postsCollectionName).doc(post.id).delete();
    } catch (error) {
      log("Delete Post Exception: $error");
    }
  }
}
