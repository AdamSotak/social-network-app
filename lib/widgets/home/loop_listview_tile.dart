import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/auth/auth.dart';
import 'package:social_network/database/user_data_database.dart';
import 'package:social_network/models/loop.dart';
import 'package:social_network/models/user_data.dart';
import 'package:social_network/pages/add_pages/add_loop_page.dart';
import 'package:social_network/styling/styles.dart';
import 'package:social_network/styling/variables.dart';
import 'package:social_network/widgets/main_widgets/main_container.dart';

class LoopListViewTile extends StatefulWidget {
  const LoopListViewTile({Key? key, required this.loop, required this.index}) : super(key: key);

  final Loop loop;
  final int index;

  @override
  State<LoopListViewTile> createState() => _LoopListViewTileState();
}

class _LoopListViewTileState extends State<LoopListViewTile> {
  @override
  Widget build(BuildContext context) {
    var loop = widget.loop;
    var index = widget.index;

    void openLoop() {
      if (loop.userId == Auth().getUserId() && index == 0) {
        Navigator.push(context, CupertinoPageRoute(builder: (builder) => const AddLoopPage()));
      } else {}
    }

    return FutureBuilder<UserData>(
      future: UserDataDatabase().getUserData(loop.userId),
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

        return MainContainer(
          width: 80.0,
          height: 80.0,
          margin: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
          pressable: true,
          onPressed: openLoop,
          child: Center(
            child: Container(
              width: 70.0,
              height: 70.0,
              decoration: BoxDecoration(
                  image: (Styles.checkIfStringEmpty(userData.profilePhotoURL))
                      ? const DecorationImage(image: AssetImage(Variables.defaultProfileImageURL), fit: BoxFit.cover)
                      : DecorationImage(image: NetworkImage(userData.profilePhotoURL), fit: BoxFit.cover),
                  shape: BoxShape.circle),
              child: GestureDetector(
                onTap: () {},
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: (loop.userId == Auth().getUserId() && index == 0)
                      ? BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                          child: Stack(
                            children: [
                              Container(
                                decoration: const BoxDecoration(shape: BoxShape.circle),
                              ),
                              const Center(
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 50.0,
                                ),
                              )
                            ],
                          ),
                        )
                      : Container(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
