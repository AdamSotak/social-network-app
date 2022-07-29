import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/auth/auth.dart';
import 'package:social_network/managers/dialog_manager.dart';
import 'package:social_network/styling/styles.dart';
import 'package:social_network/widgets/main_widgets/main_app_bar.dart';
import 'package:social_network/widgets/main_widgets/main_text_field.dart';

class ChangeEmailPage extends StatefulWidget {
  const ChangeEmailPage({Key? key}) : super(key: key);

  @override
  State<ChangeEmailPage> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  final TextEditingController currentPasswordTextEditingController = TextEditingController();
  final TextEditingController emailTextEditingController = TextEditingController();

  @override
  void dispose() {
    currentPasswordTextEditingController.dispose();
    emailTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void changeEmailDone() {
      if (Styles.checkIfStringEmpty(currentPasswordTextEditingController.text) ||
          Styles.checkIfStringEmpty(emailTextEditingController.text)) {
        DialogManager().displaySnackBar(context: context, text: "Please enter the required information");
        return;
      }

      DialogManager().displayLoadingDialog(context: context);

      Auth()
          .changeEmail(
              currentPassword: currentPasswordTextEditingController.text, newEmail: emailTextEditingController.text)
          .then((value) {
        DialogManager().closeDialog(context: context);
        if (!value) {
          DialogManager().displaySnackBar(context: context, text: "Incorrect password");
          return;
        }

        Navigator.pop(context);
      });
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
                title: "Change Email",
                icon: const Icon(CupertinoIcons.check_mark),
                onIconPressed: changeEmailDone,
              ),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                "Email: ${Auth().getUserEmail()}",
                style: Theme.of(context).textTheme.headline2,
              ),
              const SizedBox(
                height: 20.0,
              ),
              MainTextField(
                controller: currentPasswordTextEditingController,
                hintText: "Password",
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                obscureText: true,
              ),
              MainTextField(
                controller: emailTextEditingController,
                hintText: "New Email",
                margin: const EdgeInsets.symmetric(vertical: 10.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
