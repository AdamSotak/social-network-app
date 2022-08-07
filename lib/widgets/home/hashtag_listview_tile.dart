import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/models/hashtag.dart';
import 'package:social_network/pages/trending_pages/trending_page.dart';
import 'package:social_network/styling/styles.dart';
import 'package:social_network/widgets/main_widgets/main_container.dart';

// ListView tile for displaying a Hashtag

class HashtagListViewTile extends StatefulWidget {
  const HashtagListViewTile({Key? key, required this.hashtag}) : super(key: key);

  final Hashtag hashtag;

  @override
  State<HashtagListViewTile> createState() => _HashtagListViewTileState();
}

class _HashtagListViewTileState extends State<HashtagListViewTile> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    var hashtag = widget.hashtag;

    // Open TrendingPage
    void openTrendingPage() {
      Navigator.push(context, CupertinoPageRoute(builder: (builder) => TrendingPage(hashtag: hashtag)));
    }

    return Listener(
      onPointerUp: (event) => setState(() {
        pressed = false;
      }),
      onPointerDown: (event) => setState(() {
        pressed = true;
      }),
      child: GestureDetector(
        onTap: openTrendingPage,
        child: MainContainer(
          margin: const EdgeInsets.all(5.0),
          width: 170.0,
          height: 250.0,
          pressable: true,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              gradient: (pressed) ? null : Styles.getRandomLinearGradient(),
              borderRadius: BorderRadius.circular(Styles.mainBorderRadius),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hashtag.name,
                        style: Theme.of(context).textTheme.headline3!.copyWith(color: Colors.white, fontSize: 25.0),
                      ),
                      (hashtag.postCount != 1)
                          ? Text(
                              "${Styles.getFormattedNumberString(hashtag.postCount)} Posts",
                              style:
                                  Theme.of(context).textTheme.headline3!.copyWith(color: Colors.white, fontSize: 15.0),
                            )
                          : Text(
                              "${Styles.getFormattedNumberString(hashtag.postCount)} Post",
                              style:
                                  Theme.of(context).textTheme.headline3!.copyWith(color: Colors.white, fontSize: 15.0),
                            ),
                    ],
                  ),
                  const Align(
                    alignment: Alignment.bottomRight,
                    child: Icon(
                      CupertinoIcons.arrow_right,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
