import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_network/auth/auth.dart';
import 'package:social_network/models/post.dart';
import 'package:social_network/storage/image_storage.dart';
import 'package:social_network/storage/video_storage.dart';

class PostsDatabase {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final String postsCollectionName = "posts";

  // Get Posts data Stream for loading
  Stream<QuerySnapshot> getPostStream() {
    return firestore.collection(postsCollectionName).where('userId', isEqualTo: Auth().getUserId()).snapshots();
  }

  // Add new Post
  Future<void> addPost(Post post) async {
    try {
      if (post.contentURL != "" && !post.video) {
        post.contentURL = await ImageStorage().uploadImage(post.contentURL);
      } else if (post.contentURL != "" && post.video) {
        post.contentURL = await VideoStorage().uploadVideo(post.contentURL);
      }

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
      // Delete post image or video
      if (post.contentURL != "" && !post.video) {
        ImageStorage().deleteImage(post.contentURL);
      } else if (post.contentURL != "" && post.video) {
        VideoStorage().deleteVideo(post.contentURL);
      }

      await firestore.collection(postsCollectionName).doc(post.id).delete();
    } catch (error) {
      log("Delete Post Exception: $error");
    }
  }
}
