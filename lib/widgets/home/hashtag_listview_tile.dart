import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/models/hashtag.dart';
import 'package:social_network/styling/styles.dart';

class HashtagListViewTile extends StatefulWidget {
  const HashtagListViewTile({Key? key, required this.hashtag}) : super(key: key);

  final Hashtag hashtag;

  @override
  State<HashtagListViewTile> createState() => _HashtagListViewTileState();
}

class _HashtagListViewTileState extends State<HashtagListViewTile> {
  @override
  Widget build(BuildContext context) {
    var hashtag = widget.hashtag;

    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.fromLTRB(7.0, 7.0, 7.0, 20.0),
        child: Material(
          elevation: 10.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Styles.mainBorderRadius),
          ),
          child: Container(
            width: 170.0,
            height: 250.0,
            decoration: BoxDecoration(
              gradient: Styles.getRandomLinearGradient(),
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
                      (hashtag.postCount > 1)
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
