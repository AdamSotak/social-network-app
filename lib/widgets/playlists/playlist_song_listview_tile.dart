import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/models/song.dart';
import 'package:social_network/widgets/main_widgets/main_container.dart';
import 'package:social_network/widgets/main_widgets/main_icon_button.dart';

class PlaylistSongListViewTile extends StatelessWidget {
  const PlaylistSongListViewTile({Key? key, required this.song}) : super(key: key);

  final Song song;

  @override
  Widget build(BuildContext context) {
    return MainContainer(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                song.name,
                style: Theme.of(context).textTheme.headline3,
              ),
              Text(
                "Album Name",
                style: Theme.of(context).textTheme.headline2,
              )
            ],
          ),
          MainIconButton(
            icon: const Icon(
              CupertinoIcons.xmark,
              size: 20.0,
            ),
            onPressed: () {},
          )
        ],
      ),
    ));
  }
}
