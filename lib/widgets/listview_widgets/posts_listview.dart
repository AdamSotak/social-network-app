import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_network/database/posts_database.dart';
import 'package:social_network/models/post.dart';
import 'package:social_network/widgets/no_data_tile.dart';
import 'package:social_network/widgets/post_widgets/post_listview_tile.dart';

class PostsListView extends StatelessWidget {
  const PostsListView({Key? key, required this.userId}) : super(key: key);

  final String userId;

  @override
  Widget build(BuildContext context) {
    List<Post> posts = [];

    return StreamBuilder<QuerySnapshot>(
      stream: PostsDatabase().getPostStream(userId: userId),
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

        posts.clear();

        posts.addAll(snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
          var post = Post.fromDocumentSnapshot(documentSnapshot);
          return post;
        }));

        if (posts.isEmpty) {
          return const NoDataTile(text: "No Posts Yet");
        }

        return ListView.builder(
          clipBehavior: Clip.none,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: posts.length,
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          itemBuilder: (context, index) {
            var post = posts[index];
            return PostListViewTile(post: post);
          },
        );
      },
    );
  }
}
