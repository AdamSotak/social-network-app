import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_network/database/post_database.dart';
import 'package:social_network/models/post.dart';
import 'package:social_network/widgets/no_data_tile.dart';
import 'package:social_network/widgets/posts/post_listview_tile.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({Key? key}) : super(key: key);

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  List<Post> posts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: PostDatabase().getPostStream(),
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
              itemCount: posts.length,
              itemBuilder: (context, index) {
                var post = posts[index];
                return PostListViewTile(post: post);
              },
            );
          }),
    );
  }
}
