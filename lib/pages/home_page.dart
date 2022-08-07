import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/auth/auth.dart';
import 'package:social_network/pages/search_page.dart';
import 'package:social_network/widgets/listview_widgets/hashtags_listview.dart';
import 'package:social_network/widgets/listview_widgets/home_listview.dart';
import 'package:social_network/widgets/listview_widgets/loops_listview.dart';
import 'package:social_network/widgets/main_widgets/main_icon_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // Open SearchPage
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
            const SizedBox(
              height: 250.0,
              child: HashtagsListView(),
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
              child: LoopsListView(userId: Auth().getUserId()),
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
            const HomeListView()
          ],
        ),
      ),
    );
  }
}
