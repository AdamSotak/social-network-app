import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_network/database/hashtags_database.dart';
import 'package:social_network/models/hashtag.dart';
import 'package:social_network/widgets/home/hashtag_listview_tile.dart';

class HashtagsListView extends StatelessWidget {
  const HashtagsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: HashtagsDatabase().getHashtagStream(),
      builder: (context, snapshot) {
        // Error and loading checking
        if (snapshot.hasError) {
          return const Center(
            child: Text("Something went wrong"),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 2.5),
              child: const CircularProgressIndicator(),
            ),
          );
        }

        List<Hashtag> hashtags = [];
        hashtags.addAll(snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
          var hashtag = Hashtag.fromDocumentSnapshot(documentSnapshot);
          return hashtag;
        }));

        if (hashtags.isEmpty) {
          return Center(
            child: Text(
              "No Hashtags Yet",
              style: Theme.of(context).textTheme.headline2,
            ),
          );
        }

        return ListView.builder(
          clipBehavior: Clip.none,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: 10.0),
          itemCount: hashtags.length,
          itemBuilder: ((context, index) {
            var hashtag = hashtags[index];
            return HashtagListViewTile(hashtag: hashtag);
          }),
        );
      },
    );
  }
}
