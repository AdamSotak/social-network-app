import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_network/models/post.dart';
import 'package:social_network/storage/image_storage.dart';
import 'package:social_network/storage/video_storage.dart';

class PostsDatabase {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final String postsCollectionName = "posts";

  // Get Posts data Stream for loading
  Stream<QuerySnapshot> getPostStream({required String userId}) {
    return firestore.collection(postsCollectionName).where('userId', isEqualTo: userId).snapshots();
  }

  // Get Posts
  Future<List<Post>> getPosts({int days = 7}) async {
    return await firestore
        .collection(postsCollectionName)
        .where('created', isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days: days)))
        .orderBy('created')
        .orderBy('likes')
        .get()
        .then((value) {
      return value.docs.map((post) => Post.fromDocumentSnapshot(post)).toList();
    });
  }

  // Get Posts with hashtag
  Future<List<Post>> getHashtagPosts({required String hashtagName}) async {
    return await firestore
        .collection(postsCollectionName)
        .where('hashtags', arrayContains: hashtagName)
        .orderBy('created')
        .orderBy('likes')
        .get()
        .then((value) {
      return value.docs.map((post) => Post.fromDocumentSnapshot(post)).toList();
    });
  }

  // Get liked Posts
  Future<List<Post>> getLikedPosts({required List<String> likedPosts}) async {
    return await firestore.collection(postsCollectionName).where('id', whereIn: likedPosts).get().then((value) {
      return value.docs.map((post) => Post.fromDocumentSnapshot(post)).toList();
    });
  }

  // Get Post
  Future<Post> getPost({required String postId}) async {
    return await firestore.collection(postsCollectionName).where('id', isEqualTo: postId).get().then((value) {
      return value.docs.map((loop) => Post.fromDocumentSnapshot(loop)).toList().first;
    });
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
