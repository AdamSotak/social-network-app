import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/database/loops_database.dart';
import 'package:social_network/database/user_data_database.dart';
import 'package:social_network/models/follow.dart';
import 'package:social_network/models/loop.dart';
import 'package:social_network/models/user_data.dart';
import 'package:social_network/pages/loops_pages/loops_page.dart';
import 'package:social_network/styling/styles.dart';
import 'package:social_network/styling/variables.dart';
import 'package:social_network/widgets/main_widgets/main_container.dart';

class LoopListViewTile extends StatefulWidget {
  const LoopListViewTile({Key? key, required this.follows, required this.userId}) : super(key: key);

  final List<Follow> follows;
  final String userId;

  @override
  State<LoopListViewTile> createState() => _LoopListViewTileState();
}

class _LoopListViewTileState extends State<LoopListViewTile> {
  @override
  Widget build(BuildContext context) {
    var follows = widget.follows;
    var userId = widget.userId;

    void openLoop(UserData userData) {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (builder) => LoopsPage(
            follows: follows,
            userId: userId,
          ),
        ),
      );
    }

    return FutureBuilder<UserData>(
      future: UserDataDatabase().getUserData(userId),
      builder: (context, snapshot) {
        // Error and loading checking
        if (snapshot.hasError) {
          return const Center(
            child: Text("Something went wrong"),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        UserData userData = snapshot.data!;

        return FutureBuilder<List<Loop>>(
          future: LoopsDatabase().getLoopsForUser(userId: userId),
          builder: (context, snapshot) {
            return MainContainer(
              width: 80.0,
              height: 80.0,
              margin: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
              pressable: true,
              onPressed: () {
                openLoop(userData);
              },
              child: Center(
                child: Container(
                  width: 70.0,
                  height: 70.0,
                  decoration: BoxDecoration(
                      image: (Styles.checkIfStringEmpty(userData.profilePhotoURL))
                          ? const DecorationImage(
                              image: AssetImage(Variables.defaultProfileImageURL), fit: BoxFit.cover)
                          : DecorationImage(image: NetworkImage(userData.profilePhotoURL), fit: BoxFit.cover),
                      shape: BoxShape.circle),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
