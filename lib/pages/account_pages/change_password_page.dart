import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/auth/auth.dart';
import 'package:social_network/managers/dialog_manager.dart';
import 'package:social_network/pages/account_pages/reset_password_page.dart';
import 'package:social_network/styling/styles.dart';
import 'package:social_network/widgets/main_widgets/main_app_bar.dart';
import 'package:social_network/widgets/main_widgets/main_button.dart';
import 'package:social_network/widgets/main_widgets/main_text_field.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController currentPasswordTextEditingController = TextEditingController();
  final TextEditingController newPasswordTextEditingController = TextEditingController();
  final TextEditingController confirmNewPasswordTextEditingController = TextEditingController();

  @override
  void dispose() {
    currentPasswordTextEditingController.dispose();
    newPasswordTextEditingController.dispose();
    confirmNewPasswordTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Checks for empty data and change password
    void changePasswordDone() {
      if (Styles.checkIfStringEmpty(currentPasswordTextEditingController.text) ||
          Styles.checkIfStringEmpty(newPasswordTextEditingController.text) ||
          Styles.checkIfStringEmpty(confirmNewPasswordTextEditingController.text)) {
        DialogManager().displaySnackBar(context: context, text: "Please enter the required information");
        return;
      }

      if (newPasswordTextEditingController.text != confirmNewPasswordTextEditingController.text) {
        DialogManager().displaySnackBar(context: context, text: "New passwords do not match");
        currentPasswordTextEditingController.text = "";
        newPasswordTextEditingController.text = "";
        confirmNewPasswordTextEditingController.text = "";
        return;
      }

      DialogManager().displayLoadingDialog(context: context);

      Auth()
          .changePassword(
              currentPassword: currentPasswordTextEditingController.text,
              newPassword: confirmNewPasswordTextEditingController.text)
          .then((value) {
        DialogManager().closeDialog(context: context);
        if (!value) {
          DialogManager().displaySnackBar(context: context, text: "Incorrect password");
          currentPasswordTextEditingController.text = "";
          newPasswordTextEditingController.text = "";
          confirmNewPasswordTextEditingController.text = "";
          return;
        }

        Navigator.pop(context);
      });
    }

    void openResetPasswordPage() {
      Navigator.push(context, CupertinoPageRoute(builder: (builder) => const ResetPasswordPage()));
    }

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
          child: Column(
            children: [
              MainAppBar(
                title: "Change Password",
                fontSize: 25.0,
                icon: const Icon(CupertinoIcons.check_mark),
                onIconPressed: changePasswordDone,
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
              const SizedBox(
                height: 50.0,
              ),
              MainTextField(
                controller: newPasswordTextEditingController,
                hintText: "New Password",
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                obscureText: true,
              ),
              MainTextField(
                controller: confirmNewPasswordTextEditingController,
                hintText: "Confirm New Password",
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                obscureText: true,
              ),
              const SizedBox(
                height: 50.0,
              ),
              Center(
                child: Text(
                  "Reset your password if you don't remember it",
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              MainButton(text: "Reset Password", onPressed: openResetPasswordPage)
            ],
          ),
        ),
      ),
    );
  }
}
