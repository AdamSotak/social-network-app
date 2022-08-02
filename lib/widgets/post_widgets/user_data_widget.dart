import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/database/user_data_database.dart';
import 'package:social_network/models/user_data.dart';
import 'package:social_network/pages/profile_pages/profile_page.dart';
import 'package:social_network/styling/styles.dart';
import 'package:social_network/styling/variables.dart';

class UserDataWidget extends StatefulWidget {
  const UserDataWidget({Key? key, this.userId, this.userData, this.created}) : super(key: key);

  final String? userId;
  final UserData? userData;
  final DateTime? created;

  @override
  State<UserDataWidget> createState() => _UserDataWidgetState();
}

class _UserDataWidgetState extends State<UserDataWidget> {
  UserData userData = UserData(
    id: "",
    username: "",
    displayName: "",
    profilePhotoURL: "",
    followers: 0,
    following: 0,
  );

  Future<void> getUserData() async {
    if (widget.userId == null) {
      userData = widget.userData!;
    } else {
      userData = await UserDataDatabase().getUserData(widget.userId!);
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData().whenComplete(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var created = widget.created;

    void openProfilePage() {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (builder) => ProfilePage(
            userId: userData.id,
            backButton: true,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: openProfilePage,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            (Styles.checkIfStringEmpty(userData.profilePhotoURL))
                ? const CircleAvatar(
                    backgroundImage: AssetImage(Variables.defaultProfileImageURL),
                    radius: 30.0,
                    backgroundColor: Styles.defaultImageBackgroundColor,
                  )
                : CircleAvatar(
                    backgroundImage: NetworkImage(userData.profilePhotoURL),
                    radius: 30.0,
                    backgroundColor: Styles.defaultImageBackgroundColor,
                  ),
            const SizedBox(
              width: 10.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userData.displayName,
                  style: Theme.of(context).textTheme.headline3,
                ),
                Text(
                  "@${userData.username}",
                  style: Theme.of(context).textTheme.headline2,
                ),
                (created == null)
                    ? Container()
                    : Text(
                        Styles.getFormattedDateString(created),
                        style: Theme.of(context).textTheme.headline2,
                      ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
