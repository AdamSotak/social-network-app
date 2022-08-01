import 'package:flutter/material.dart';
import 'package:social_network/auth/auth.dart';
import 'package:social_network/database/follows_database.dart';
import 'package:social_network/models/follow.dart';
import 'package:social_network/widgets/home/loop_listview_tile.dart';

class LoopsListView extends StatelessWidget {
  const LoopsListView({Key? key, required this.userId}) : super(key: key);

  final String userId;

  @override
  Widget build(BuildContext context) {
    List<Follow> follows = [];

    return FutureBuilder<List<Follow>>(
      future: FollowsDatabase().getFollowingsLoopsForUser(userId: userId),
      builder: (BuildContext context, AsyncSnapshot<List<Follow>> snapshot) {
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
        follows.add(Follow(id: "", fromUserId: "", toUserId: Auth().getUserId(), created: DateTime.now()));
        follows.addAll(snapshot.data!);

        if (follows.isEmpty) {
          return Center(
            child: Text(
              "No Loops yet, Follow a profile to get started",
              style: Theme.of(context).textTheme.headline2,
            ),
          );
        }

        return ListView.builder(
          clipBehavior: Clip.none,
          padding: const EdgeInsets.only(left: 15.0),
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: follows.length,
          itemBuilder: ((context, index) {
            var follow = follows[index];
            return LoopListViewTile(follows: follows, userId: follow.toUserId);
          }),
        );
      },
    );
  }
}
