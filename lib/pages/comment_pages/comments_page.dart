import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/database/comments_database.dart';
import 'package:social_network/models/comment.dart';
import 'package:social_network/pages/comment_pages/add_comment_page.dart';
import 'package:social_network/widgets/main_widgets/main_app_bar.dart';
import 'package:social_network/widgets/no_data_tile.dart';
import 'package:social_network/widgets/post_widgets/comment_listview_tile.dart';

class CommentsPage extends StatefulWidget {
  const CommentsPage({Key? key, required this.postId}) : super(key: key);

  final String postId;

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  List<Comment> comments = [];

  @override
  Widget build(BuildContext context) {
    var postId = widget.postId;

    void openAddCommentPage() {
      Navigator.push(context, CupertinoPageRoute(builder: (builder) => AddCommentsPage(id: postId)));
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
                title: "Comments",
                icon: const Icon(
                  CupertinoIcons.add_circled,
                  size: 30.0,
                ),
                onIconPressed: openAddCommentPage,
              ),
              const SizedBox(
                height: 20.0,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: CommentsDatabase().getCommentStream(postId: postId),
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

                  comments.clear();

                  comments.addAll(snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
                    var post = Comment.fromDocumentSnapshot(documentSnapshot);
                    return post;
                  }));

                  if (comments.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 5),
                      child: const NoDataTile(text: "No Comments Yet"),
                    );
                  }

                  return ListView.builder(
                    clipBehavior: Clip.none,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: comments.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      var comment = comments[index];
                      return CommentListViewTile(comment: comment);
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
