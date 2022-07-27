import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/auth/auth.dart';
import 'package:social_network/database/posts_database.dart';
import 'package:social_network/models/hashtag.dart';
import 'package:social_network/models/loop.dart';
import 'package:social_network/models/post.dart';
import 'package:social_network/widgets/home/hashtag_listview_tile.dart';
import 'package:social_network/widgets/home/loop_listview_tile.dart';
import 'package:social_network/widgets/main_widgets/main_icon_button.dart';
import 'package:social_network/widgets/no_data_tile.dart';
import 'package:social_network/widgets/posts/post_listview_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post> posts = [];
  List<Hashtag> hashtags = [
    // Sample data
    Hashtag(id: "id", name: "#trending", postCount: 100, created: DateTime.now()),
    Hashtag(id: "id", name: "#trending", postCount: 100, created: DateTime.now()),
    Hashtag(id: "id", name: "#trending", postCount: 100, created: DateTime.now()),
    Hashtag(id: "id", name: "#trending", postCount: 100, created: DateTime.now()),
    Hashtag(id: "id", name: "#trending", postCount: 100, created: DateTime.now()),
  ];
  List<Loop> loops = [
    // Sample data
    Loop(
        id: "id",
        userId: Auth().getUserId(),
        name: "name",
        description: "description",
        contentURL: "",
        created: DateTime.now()),
    Loop(id: "id", userId: "userId", name: "name", description: "description", contentURL: "", created: DateTime.now()),
    Loop(id: "id", userId: "userId", name: "name", description: "description", contentURL: "", created: DateTime.now()),
    Loop(id: "id", userId: "userId", name: "name", description: "description", contentURL: "", created: DateTime.now()),
    Loop(id: "id", userId: "userId", name: "name", description: "description", contentURL: "", created: DateTime.now()),
    Loop(id: "id", userId: "userId", name: "name", description: "description", contentURL: "", created: DateTime.now()),
    Loop(id: "id", userId: "userId", name: "name", description: "description", contentURL: "", created: DateTime.now()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Trending",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  MainIconButton(icon: const Icon(CupertinoIcons.search), onPressed: () {})
                ],
              ),
            ),
            SizedBox(
              height: 250.0,
              child: ListView.builder(
                clipBehavior: Clip.none,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 10.0),
                itemCount: hashtags.length,
                itemBuilder: ((context, index) {
                  var hashtag = hashtags[index];
                  return HashtagListViewTile(hashtag: hashtag);
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Loops",
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            SizedBox(
              height: 80.0,
              child: ListView.builder(
                clipBehavior: Clip.none,
                padding: const EdgeInsets.only(left: 15.0),
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: loops.length,
                itemBuilder: ((context, index) {
                  var loop = loops[index];
                  return LoopListViewTile(loop: loop);
                }),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Posts",
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: PostsDatabase().getPostStream(),
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

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      clipBehavior: Clip.none,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: posts.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        var post = posts[index];
                        return PostListViewTile(post: post);
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
