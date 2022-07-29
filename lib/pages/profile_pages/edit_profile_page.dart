import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_network/database/user_data_database.dart';
import 'package:social_network/managers/dialog_manager.dart';
import 'package:social_network/models/user_data.dart';
import 'package:social_network/storage/image_storage.dart';
import 'package:social_network/styling/styles.dart';
import 'package:social_network/styling/variables.dart';
import 'package:social_network/widgets/main_widgets/main_app_bar.dart';
import 'package:social_network/widgets/main_widgets/main_button.dart';
import 'package:social_network/widgets/main_widgets/main_text_field.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key, required this.userData}) : super(key: key);

  final UserData userData;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController displayNameTextEditingController = TextEditingController();
  final TextEditingController usernameTextEditingController = TextEditingController();
  late String oldPictureURL = widget.userData.profilePhotoURL;
  String newPictureURL = "";

  @override
  void initState() {
    super.initState();
    displayNameTextEditingController.text = widget.userData.displayName;
    usernameTextEditingController.text = widget.userData.username;
  }

  @override
  void dispose() {
    displayNameTextEditingController.dispose();
    usernameTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var userData = widget.userData;
    log(oldPictureURL);

    void editProfileDone() async {
      if (Styles.checkIfStringEmpty(displayNameTextEditingController.text)) {
        DialogManager().displaySnackBar(context: context, text: "Please enter a Display Name");
        return;
      }

      if (Styles.checkIfStringEmpty(usernameTextEditingController.text)) {
        DialogManager().displaySnackBar(context: context, text: "Please enter a Username");
        return;
      }

      DialogManager().displayLoadingDialog(context: context);

      userData.displayName = displayNameTextEditingController.text;
      userData.username = usernameTextEditingController.text;

      // Checks whether to upload or delete user profile image
      if (!Styles.checkIfStringEmpty(newPictureURL)) {
        userData.profilePhotoURL = await ImageStorage().uploadImage(newPictureURL);
      } else if (Styles.checkIfStringEmpty(newPictureURL) && userData.profilePhotoURL == "") {
        await ImageStorage().deleteImage(oldPictureURL);
      }

      await UserDataDatabase().editUserData(userData).then((value) {
        DialogManager().closeDialog(context: context);
        Navigator.pop(context);
      });
    }

    void changeProfilePicture() async {
      final ImagePicker imagePicker = ImagePicker();
      final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);

      if (image == null) return;

      setState(() {
        newPictureURL = image.path;
      });
    }

    void deleteProfilePicture() {
      setState(() {
        userData.profilePhotoURL = "";
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
                title: "Edit Profile",
                icon: const Icon(CupertinoIcons.check_mark),
                onIconPressed: editProfileDone,
              ),
              const SizedBox(
                height: 20.0,
              ),
              Container(
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  gradient: Styles.linearGradients[2],
                  borderRadius: BorderRadius.circular(150.0),
                ),
                child: Container(
                  padding: const EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(150.0),
                  ),
                  child: (newPictureURL != "")
                      ? (Styles.checkIfStringEmpty(userData.profilePhotoURL))
                          ? CircleAvatar(
                              backgroundImage: FileImage(File(newPictureURL)),
                              backgroundColor: Styles.defaultImageBackgroundColor,
                              radius: 70.0,
                            )
                          : CircleAvatar(
                              backgroundImage: NetworkImage(userData.profilePhotoURL),
                              backgroundColor: Styles.defaultImageBackgroundColor,
                              radius: 70.0,
                            )
                      : (Styles.checkIfStringEmpty(userData.profilePhotoURL))
                          ? const CircleAvatar(
                              backgroundImage: AssetImage(Variables.defaultProfileImageURL),
                              backgroundColor: Styles.defaultImageBackgroundColor,
                              radius: 70.0,
                            )
                          : CircleAvatar(
                              backgroundImage: NetworkImage(userData.profilePhotoURL),
                              backgroundColor: Styles.defaultImageBackgroundColor,
                              radius: 70.0,
                            ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              MainButton(text: "Change Profile Picture", onPressed: changeProfilePicture),
              MainButton(text: "Delete Profile Picture", onPressed: deleteProfilePicture),
              const SizedBox(
                height: 20.0,
              ),
              MainTextField(
                controller: displayNameTextEditingController,
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                hintText: "Display Name",
              ),
              MainTextField(
                controller: usernameTextEditingController,
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                hintText: "Username",
              ),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                "Changes might need a few minutes to propagate",
                style: Theme.of(context).textTheme.headline2,
              )
            ],
          ),
        ),
      ),
    );
  }
}
