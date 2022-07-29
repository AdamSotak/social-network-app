import 'package:flutter/material.dart';
import 'package:social_network/models/user_data.dart';
import 'package:social_network/styling/styles.dart';
import 'package:social_network/styling/variables.dart';

class UserDataWidget extends StatelessWidget {
  const UserDataWidget({Key? key, required this.userData, this.created}) : super(key: key);

  final UserData userData;
  final DateTime? created;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                      Styles.getFormattedDateString(created!),
                      style: Theme.of(context).textTheme.headline2,
                    ),
            ],
          )
        ],
      ),
    );
  }
}
