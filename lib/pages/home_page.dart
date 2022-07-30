import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/auth/auth.dart';
import 'package:social_network/models/album.dart';
import 'package:social_network/models/hashtag.dart';
import 'package:social_network/models/loop.dart';
import 'package:social_network/models/post.dart';
import 'package:social_network/pages/search_page.dart';
import 'package:social_network/widgets/home/hashtag_listview_tile.dart';
import 'package:social_network/widgets/home/loop_listview_tile.dart';
import 'package:social_network/widgets/listview_widgets/posts_listview.dart';
import 'package:social_network/widgets/main_widgets/main_icon_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post> posts = [];
  List<Album> albums = [];
  List<Hashtag> hashtags = [
    // Sample data
    Hashtag(id: "id", name: "#trending", postCount: 100, created: DateTime.now()),
    Hashtag(id: "id", name: "#trending", postCount: 100, created: DateTime.now()),
    Hashtag(id: "id", name: "#trending", postCount: 100, created: DateTime.now()),
    Hashtag(id: "id", name: "#trending", postCount: 100, created: DateTime.now()),
    Hashtag(id: "id", name: "#trending", postCount: 100, created: DateTime.now()),
  ];
  List<Loop> loops = [
    Loop(
        id: "id",
        userId: Auth().getUserId(),
        name: "name",
        description: "description",
        contentURL: "",
        likes: 0,
        comments: 0,
        created: DateTime.now()),
  ];

  @override
  Widget build(BuildContext context) {
    void openSearchPage() {
      Navigator.push(context, CupertinoPageRoute(builder: (builder) => const SearchPage()));
    }

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
                  MainIconButton(icon: const Icon(CupertinoIcons.search), onPressed: openSearchPage)
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
            PostsListView(userId: Auth().getUserId())
          ],
        ),
      ),
    );
  }
}
