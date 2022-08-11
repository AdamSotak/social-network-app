import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/auth/auth.dart';
import 'package:social_network/managers/dialog_manager.dart';
import 'package:social_network/pages/main_page.dart';
import 'package:social_network/styling/styles.dart';
import 'package:social_network/widgets/main_widgets/main_app_bar.dart';
import 'package:social_network/widgets/main_widgets/main_text_field.dart';

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
  void dispose() {
    emailTextEditingController.dispose();
    usernameTextEditingController.dispose();
    displayNameTextEditingController.dispose();
    passwordTextEditingController.dispose();
    confirmPasswordTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Create a new account
    void createAccount() async {
      displayNameTextEditingController.text = displayNameTextEditingController.text.trim();
      usernameTextEditingController.text = usernameTextEditingController.text.trim();
      // Check if values are empty
      if (Styles.checkIfStringEmpty(emailTextEditingController.text) ||
          Styles.checkIfStringEmpty(usernameTextEditingController.text) ||
          Styles.checkIfStringEmpty(displayNameTextEditingController.text) ||
          Styles.checkIfStringEmpty(passwordTextEditingController.text) ||
          Styles.checkIfStringEmpty(confirmPasswordTextEditingController.text)) {
        DialogManager().displaySnackBar(context: context, text: "Please enter the required information");
        return;
      }

      // Check if passwords match
      if (passwordTextEditingController.text != confirmPasswordTextEditingController.text) {
        DialogManager().displaySnackBar(context: context, text: "Password do not match");
        return;
      }

      DialogManager().displayLoadingDialog(context: context);

      if (!await Auth().checkUsername(username: usernameTextEditingController.text) ||
          usernameTextEditingController.text.contains(' ')) {
        DialogManager().closeDialog(context: context);
        DialogManager().displaySnackBar(context: context, text: "Username not available");
        return;
      }

      // Create account
      await Auth()
          .createAccount(
              email: emailTextEditingController.text,
              username: usernameTextEditingController.text,
              displayName: displayNameTextEditingController.text,
              password: passwordTextEditingController.text,
              context: context)
          .then((value) {
        DialogManager().closeDialog(context: context);
        if (!value) {
          DialogManager().displaySnackBar(context: context, text: "Email already in use");
        } else {
          Navigator.pushAndRemoveUntil(
              context, CupertinoPageRoute(builder: (builder) => const MainPage()), (route) => false);
        }
      });
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              MainAppBar(
                title: "Create Account",
                icon: const Icon(CupertinoIcons.check_mark),
                onIconPressed: createAccount,
              ),
              const SizedBox(
                height: 30.0,
              ),
              MainTextField(
                controller: emailTextEditingController,
                hintText: "Email",
                margin: const EdgeInsets.symmetric(vertical: 10.0),
              ),
              MainTextField(
                controller: usernameTextEditingController,
                hintText: "Username",
                margin: const EdgeInsets.symmetric(vertical: 10.0),
              ),
              MainTextField(
                controller: displayNameTextEditingController,
                hintText: "Display Name",
                margin: const EdgeInsets.symmetric(vertical: 10.0),
              ),
              MainTextField(
                controller: passwordTextEditingController,
                hintText: "Password",
                obscureText: true,
                margin: const EdgeInsets.symmetric(vertical: 10.0),
              ),
              MainTextField(
                controller: confirmPasswordTextEditingController,
                hintText: "Confirm Password",
                obscureText: true,
                margin: const EdgeInsets.symmetric(vertical: 10.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
