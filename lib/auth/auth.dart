import 'dart:convert';
import 'dart:developer';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:social_network/database/user_data_database.dart';
import 'package:social_network/managers/dialog_manager.dart';
import 'package:social_network/models/user_data.dart';
import 'package:social_network/styling/variables.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class Auth {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final functions = FirebaseFunctions.instance;

  // Current user
  Stream<User?> get user {
    return auth.authStateChanges();
  }

  // Get user id
  String getUserId() {
    return auth.currentUser!.uid;
  }

  // Get user email
  String getUserEmail() {
    return auth.currentUser!.email.toString();
  }

  // Get user IDToken
  Future<String> getUserIDToken() {
    return auth.currentUser!.getIdToken(true);
  }

  // Login user
  Future<bool> login({required String email, required String password, required BuildContext context}) async {
    try {
      await auth.signInWithEmailAndPassword(email: email.trim(), password: password).then((value) {
        DialogManager().closeDialog(context: context);
      });
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

  // Check if username available
  Future<bool> checkUsername({required String username}) async {
    try {
      var response = await http.get(Uri.parse("${Variables.firebaseFunctionsURL}/checkUsername/$username"));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        log(data["usernameAvailable"].toString());
        return data["usernameAvailable"] == true;
      }
    } catch (_) {
      return false;
    }

    return false;
  }

  // Create new account
  Future<bool> createAccount(
      {required String email,
      required String username,
      required String displayName,
      required String password,
      required BuildContext context}) async {
    try {
      await auth.createUserWithEmailAndPassword(email: email.trim(), password: password).then((value) {
        DialogManager().closeDialog(context: context);
      });

      UserData userData = UserData(
        id: Auth().getUserId(),
        username: username,
        displayName: displayName,
        profilePhotoURL: "",
        followers: 0,
        following: 0,
      );

      await UserDataDatabase().addUserData(userData);

      return true;
    } on FirebaseAuthException catch (_) {
      return false;
    }
  }

  // Change email
  Future<bool> changeEmail({required String currentPassword, required String newEmail}) async {
    try {
      await auth.currentUser?.reauthenticateWithCredential(
          EmailAuthProvider.credential(email: auth.currentUser!.email.toString(), password: currentPassword));

      await auth.currentUser?.updateEmail(newEmail);
      return true;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }

  // Change user password
  Future<bool> changePassword({required String currentPassword, required String newPassword}) async {
    try {
      await auth.currentUser?.reauthenticateWithCredential(
          EmailAuthProvider.credential(email: auth.currentUser!.email.toString(), password: currentPassword));

      await auth.currentUser?.updatePassword(newPassword);
      return true;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }

  // Send a password reset email
  Future<void> resetPassword({required String email}) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } catch (_) {
      return;
    }
  }

  // Reauthenticate the user
  Future<bool> reauthenticateUser({required String currentPassword}) async {
    try {
      await auth.currentUser?.reauthenticateWithCredential(
          EmailAuthProvider.credential(email: auth.currentUser!.email.toString(), password: currentPassword));
      return true;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }

  Future<bool> deleteUserData() async {
    try {
      await functions.httpsCallable('deleteUserData').call({"token": await Auth().getUserIDToken()});
      return true;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }

  // Delete user account
  Future<bool> deleteAccount({required String currentPassword}) async {
    try {
      await auth.currentUser?.reauthenticateWithCredential(
          EmailAuthProvider.credential(email: auth.currentUser!.email.toString(), password: currentPassword));
      await auth.currentUser?.delete();
      return true;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }

  // Returns UUID
  static String getUUID() {
    return const Uuid().v4();
  }
}
