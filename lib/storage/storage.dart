import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class Storage {
  final storage = FirebaseStorage.instance;

  final storageRef = FirebaseStorage.instance.ref();

  // Upload Post image
  Future<String> uploadPostImage(String imagePath, String postId) async {
    try {
      String imageName = postId;
      File file = File(imagePath);

      final storageImageRef = storageRef.child(imageName);

      await storageImageRef.putFile(file);

      return await storageImageRef.getDownloadURL();
    } catch (error) {
      log(error.toString());
      return "";
    }
  }

  // Delete Post image
  Future<bool> deletePostImage(String url) async {
    try {
      final imageRef = storage.refFromURL(url);
      await imageRef.delete();
      return true;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }

  // Upload Post video
  Future<String> uploadPostVideo(String videoPath, String postId) async {
    try {
      String videoName = postId;
      File file = File(videoPath);

      final storageVideoRef = storageRef.child(videoName);

      await storageVideoRef.putFile(file);

      return await storageVideoRef.getDownloadURL();
    } catch (error) {
      log(error.toString());
      return "";
    }
  }

  // Delete Post image
  Future<bool> deletePostVideo(String url) async {
    try {
      final videoRef = storage.refFromURL(url);
      await videoRef.delete();
      return true;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }
}
