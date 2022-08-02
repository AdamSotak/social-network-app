import 'package:flutter/material.dart';
import 'package:social_network/models/hashtag.dart';
import 'package:social_network/widgets/listview_widgets/trending_listview.dart';
import 'package:social_network/widgets/main_widgets/main_back_button.dart';

class TrendingPage extends StatelessWidget {
  const TrendingPage({Key? key, required this.hashtag}) : super(key: key);

  final Hashtag hashtag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
          child: Column(
            children: [
              Row(
                children: [
                  MainBackButton(buildContext: context),
                  const SizedBox(width: 20.0),
                  Text(hashtag.name, style: Theme.of(context).textTheme.headline1)
                ],
              ),
              TrendingListView(hashtag: hashtag)
            ],
          ),
        ),
      ),
    );
  }
}
