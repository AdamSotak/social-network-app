import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_network/auth/auth.dart';
import 'package:social_network/models/user_data.dart';

class UserDataDatabase {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final String userDataCollectionName = "user_data";

  // Add new UserData
  Future<void> addUserData(UserData userData) async {
    try {
      await firestore.collection(userDataCollectionName).doc(Auth().getUserId()).set(userData.toJson());
    } catch (error) {
      log("Add UserData Exception: $error");
    }
  }

  // Get UserData
  Future<UserData> getUserData(String userId) async {
    var doc = await firestore.collection(userDataCollectionName).doc(Auth().getUserId()).get();
    return UserData.fromDocumentSnapshot(doc);
  }

  // Edit UserData
  Future<void> editUserData(UserData userData) async {
    try {
      await firestore.collection(userDataCollectionName).doc(Auth().getUserId()).set(userData.toJson());
    } catch (error) {
      log("Edit UserData Exception: $error");
    }
  }

  // Delete UserData
  Future<void> deleteUserData(UserData userData) async {
    try {
      await firestore.collection(userDataCollectionName).doc(userData.id).delete();
    } catch (error) {
      log("Delete UserData Exception: $error");
    }
  }
}
