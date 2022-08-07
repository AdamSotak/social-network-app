import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/auth/auth.dart';
import 'package:social_network/managers/dialog_manager.dart';
import 'package:social_network/styling/styles.dart';
import 'package:social_network/widgets/main_widgets/main_app_bar.dart';
import 'package:social_network/widgets/main_widgets/main_button.dart';
import 'package:social_network/widgets/main_widgets/main_text_field.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController emailTextEditingController = TextEditingController();

  @override
  void dispose() {
    emailTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check for empty data and send a reset password email
    void resetPassword() async {
      if (Styles.checkIfStringEmpty(emailTextEditingController.text)) {
        DialogManager().displaySnackBar(context: context, text: "Please enter the required information");
        return;
      }

      await Auth().resetPassword(email: emailTextEditingController.text);
    }

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MainAppBar(
                title: "Reset Password",
                icon: const Icon(CupertinoIcons.refresh),
                onIconPressed: resetPassword,
              ),
              const SizedBox(
                height: 50.0,
              ),
              MainTextField(
                controller: emailTextEditingController,
                autofocus: true,
                hintText: "Email",
              ),
              const SizedBox(
                height: 20.0,
              ),
              MainButton(text: "Send Password Recovery Email", onPressed: resetPassword)
            ],
          ),
        ),
      ),
    );
  }
}
