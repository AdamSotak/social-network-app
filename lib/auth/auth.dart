import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

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
      required String password,
      required String displayName,
      required String profilePhotoURL}) async {
    try {
      await auth.createUserWithEmailAndPassword(email: email.trim(), password: password);
      await auth.currentUser!.updateDisplayName(displayName);
      await auth.currentUser!.updatePhotoURL(profilePhotoURL);

      return true;
    } on FirebaseAuthException catch (_) {
      return false;
    }
  }
}
