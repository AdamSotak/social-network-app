import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_network/database/likes_database.dart';
import 'package:social_network/models/like.dart';
import 'package:social_network/widgets/no_data_tile.dart';

class LikesListView extends StatelessWidget {
  const LikesListView({Key? key, required this.userId}) : super(key: key);

  final String userId;

  @override
  Widget build(BuildContext context) {
    List<Like> likes = [];

    return StreamBuilder<QuerySnapshot>(
      stream: LikesDatabase().getLikeStream(userId: userId),
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

        likes.clear();

        likes.addAll(snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
          var like = Like.fromDocumentSnapshot(documentSnapshot);
          return like;
        }));

        if (likes.isEmpty) {
          return const NoDataTile(text: "No Likes Yet");
        }

        return ListView.builder(
          clipBehavior: Clip.none,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: likes.length,
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          itemBuilder: (context, index) {
            return Container();
          },
        );
      },
    );
  }
}
