import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:social_network/auth/auth.dart';
import 'package:social_network/styling/styles.dart';
import 'package:social_network/widgets/main_button.dart';
import 'package:social_network/widgets/main_text_field.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final TextEditingController emailTextEditingController = TextEditingController();
  final TextEditingController usernameTextEditingController = TextEditingController();
  final TextEditingController displayNameTextEditingController = TextEditingController();
  final TextEditingController passwordTextEditingController = TextEditingController();
  final TextEditingController confirmPasswordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Create a new account
    void createAccount() async {
      // Check if values are empty
      log(Styles.checkIfStringEmpty("a ").toString());
      if (Styles.checkIfStringEmpty(emailTextEditingController.text) ||
          Styles.checkIfStringEmpty(usernameTextEditingController.text) ||
          Styles.checkIfStringEmpty(displayNameTextEditingController.text) ||
          Styles.checkIfStringEmpty(passwordTextEditingController.text) ||
          Styles.checkIfStringEmpty(confirmPasswordTextEditingController.text)) return;
      log("Run");

      // Check if password match
      if (passwordTextEditingController.text != confirmPasswordTextEditingController.text) return;

      // Create account
      await Auth()
          .createAccount(
              email: emailTextEditingController.text,
              username: usernameTextEditingController.text,
              displayName: displayNameTextEditingController.text,
              password: passwordTextEditingController.text,
              profilePhotoURL: Styles.defaultPhotoURL)
          .then((value) {
        Navigator.pop(context);
      });
    }

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  width: 200.0,
                  child: Text(
                    "Create Account",
                    style: Theme.of(context).textTheme.headline1!.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                MainTextField(
                  controller: emailTextEditingController,
                  hintText: "Email",
                ),
                MainTextField(
                  controller: usernameTextEditingController,
                  hintText: "Username",
                ),
                MainTextField(
                  controller: displayNameTextEditingController,
                  hintText: "Display Name",
                ),
                MainTextField(
                  controller: passwordTextEditingController,
                  hintText: "Password",
                  obscureText: true,
                ),
                MainTextField(
                  controller: confirmPasswordTextEditingController,
                  hintText: "Confirm Password",
                  obscureText: true,
                ),
                const SizedBox(
                  height: 50.0,
                ),
                Center(
                  child: MainButton(text: "Create Account", onPressed: createAccount),
                ),
              ],
            )),
      ),
    );
  }
}
