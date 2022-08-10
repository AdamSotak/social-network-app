import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/auth/auth.dart';
import 'package:social_network/managers/dialog_manager.dart';
import 'package:social_network/pages/account_pages/login_page.dart';
import 'package:social_network/styling/styles.dart';
import 'package:social_network/widgets/main_widgets/main_app_bar.dart';
import 'package:social_network/widgets/main_widgets/main_text_field.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({Key? key}) : super(key: key);

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final TextEditingController currentPasswordTextEditingController = TextEditingController();
  bool checkboxValue = false;

  @override
  void dispose() {
    currentPasswordTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check for correct data, reauthenticate user and delete account
    void deleteAccountDone() async {
      if (Styles.checkIfStringEmpty(currentPasswordTextEditingController.text) || !checkboxValue) {
        DialogManager().displaySnackBar(context: context, text: "Please enter the required information");
        return;
      }

      DialogManager().displayLoadingDialog(context: context);

      await Auth().reauthenticateUser(currentPassword: currentPasswordTextEditingController.text).then((value) async {
        if (value) {
          await Auth().deleteUserData();
        } else {
          DialogManager().displaySnackBar(context: context, text: "Incorrect password");
          return;
        }
      });

      await Auth().deleteAccount(currentPassword: currentPasswordTextEditingController.text).then((value) {
        DialogManager().closeDialog(context: context);
        Navigator.pushAndRemoveUntil(
            context, CupertinoPageRoute(builder: (builder) => const LoginPage()), (route) => false);
      });
    }

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
          child: Column(
            children: [
              MainAppBar(
                title: "Delete Account",
                icon: const Icon(CupertinoIcons.check_mark),
                onIconPressed: deleteAccountDone,
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
                height: 20.0,
              ),
              Row(
                children: [
                  Transform.scale(
                    scale: 1.5,
                    child: Checkbox(
                      value: checkboxValue,
                      splashRadius: 0.0,
                      shape: const CircleBorder(),
                      onChanged: (bool? value) {
                        setState(() {
                          checkboxValue = value!;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 100.0,
                    child: Text(
                      "I acknowledge that my account and all its data will be erased and that it cannot be reversed",
                      overflow: TextOverflow.clip,
                      textAlign: TextAlign.justify,
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
