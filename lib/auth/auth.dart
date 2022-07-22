import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_network/database/user_data_database.dart';
import 'package:social_network/models/user_data.dart';

class Auth {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Current user
  Stream<User?> get user {
    return auth.authStateChanges();
  }

  // Get user id
  String getUserId() {
    return auth.currentUser!.uid;
  }

  // Login user
  Future<bool> login({required String email, required String password}) async {
    try {
      await auth.signInWithEmailAndPassword(email: email.trim(), password: password);

      return true;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }

  // Logout user
  Future<bool> logout() async {
    try {
      await auth.signOut();

      return true;
    } catch (error) {
      return false;
    }
  }

  // Create new account
  Future<bool> createAccount(
      {required String email,
      required String username,
      required String displayName,
      required String password,
      required String profilePhotoURL}) async {
    try {
      await auth.createUserWithEmailAndPassword(email: email.trim(), password: password);

      UserData userData = UserData(
        id: Auth().getUserId(),
        username: username,
        displayName: displayName,
        profilePhotoURL: profilePhotoURL,
      );

      await UserDataDatabase().addUserData(userData);

      return true;
    } on FirebaseAuthException catch (_) {
      return false;
    }
  }
}
