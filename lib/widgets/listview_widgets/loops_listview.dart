import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_network/auth/auth.dart';
import 'package:social_network/database/loops_database.dart';
import 'package:social_network/models/loop.dart';
import 'package:social_network/widgets/home/loop_listview_tile.dart';

class LoopsListView extends StatelessWidget {
  const LoopsListView({Key? key, required this.userId}) : super(key: key);

  final String userId;

  @override
  Widget build(BuildContext context) {
    List<Loop> loops = [];

    return StreamBuilder<QuerySnapshot>(
      stream: LoopsDatabase().getLoopStream(userId: userId),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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

        loops.clear();

        loops.add(
          Loop(
            id: "id",
            userId: Auth().getUserId(),
            name: "name",
            description: "description",
            contentURL: "",
            likes: 0,
            created: DateTime.now(),
          ),
        );

        loops.addAll(snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
          var loop = Loop.fromDocumentSnapshot(documentSnapshot);
          return loop;
        }));

        return ListView.builder(
          clipBehavior: Clip.none,
          padding: const EdgeInsets.only(left: 15.0),
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: loops.length,
          itemBuilder: ((context, index) {
            var loop = loops[index];
            return LoopListViewTile(loop: loop, index: index);
          }),
        );
      },
    );
  }
}
