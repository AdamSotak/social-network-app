import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/auth/auth.dart';
import 'package:social_network/pages/create_account_page.dart';
import 'package:social_network/pages/main_page.dart';
import 'package:social_network/styling/styles.dart';
import 'package:social_network/widgets/main_widgets/main_button.dart';
import 'package:social_network/widgets/main_widgets/main_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailTextEditingController = TextEditingController();
  final TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void login() async {
      // Check if values are empty
      if (Styles.checkIfStringEmpty(emailTextEditingController.text) ||
          Styles.checkIfStringEmpty(passwordTextEditingController.text)) {
        return;
      }

      // Login user
      await Auth()
          .login(email: emailTextEditingController.text, password: passwordTextEditingController.text)
          .then((value) {
        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (builder) => const MainPage()));
      });
    }

    void openCreateAccountPage() {
      Navigator.push(context, CupertinoPageRoute(builder: (builder) => const CreateAccountPage()));
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
        child: Center(
          child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Text(
                    "Logo",
                    style: Theme.of(context).textTheme.headline1!.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  MainTextField(
                    controller: emailTextEditingController,
                    hintText: "Email",
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  MainTextField(
                    controller: passwordTextEditingController,
                    hintText: "Password",
                    obscureText: true,
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  MainButton(text: "Login", onPressed: login),
                  MainButton(text: "Create Account", onPressed: openCreateAccountPage),
                ],
              )),
        ),
      ),
    );
  }
}
