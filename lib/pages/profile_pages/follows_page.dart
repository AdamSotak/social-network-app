import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/database/follows_database.dart';
import 'package:social_network/models/follow.dart';
import 'package:social_network/pages/profile_pages/profile_page.dart';
import 'package:social_network/widgets/main_widgets/main_app_bar.dart';
import 'package:social_network/widgets/main_widgets/main_container.dart';
import 'package:social_network/widgets/no_data_tile.dart';
import 'package:social_network/widgets/post_widgets/user_data_widget.dart';

class FollowsPage extends StatelessWidget {
  const FollowsPage({
    Key? key,
    required this.userId,
    required this.followers,
  }) : super(key: key);

  final String userId;
  final bool followers;

  @override
  Widget build(BuildContext context) {
    List<Follow> follows = [];

    // Open ProfilePage for the selected account
    void openProfilePage(String followUserId) {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (builder) => ProfilePage(
            userId: followUserId,
            backButton: true,
          ),
        ),
      );
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
                title: followers ? "Followers" : "Following",
                icon: const Icon(CupertinoIcons.check_mark),
                onIconPressed: () {},
              ),
              const SizedBox(
                height: 20.0,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: followers
                    ? FollowsDatabase().getFollowerStream(toUserId: userId)
                    : FollowsDatabase().getFollowingStream(fromUserId: userId),
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

                  follows.clear();

                  follows.addAll(snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
                    var follow = Follow.fromDocumentSnapshot(documentSnapshot);
                    return follow;
                  }));

                  if (follows.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 5),
                      child: NoDataTile(text: followers ? "No Followers Yet" : "No Followings Yet"),
                    );
                  }

                  return ListView.builder(
                    clipBehavior: Clip.none,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: follows.length,
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    itemBuilder: (context, index) {
                      var follow = follows[index];
                      return MainContainer(
                        pressable: true,
                        onPressed: () {
                          openProfilePage(followers ? follow.userId : follow.toUserId);
                        },
                        child: UserDataWidget(userId: followers ? follow.userId : follow.toUserId),
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
