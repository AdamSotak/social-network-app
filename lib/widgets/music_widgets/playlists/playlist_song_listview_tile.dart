import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/auth/auth.dart';
import 'package:social_network/models/song.dart';
import 'package:social_network/widgets/main_widgets/main_container.dart';
import 'package:social_network/widgets/main_widgets/main_icon_button.dart';

class PlaylistSongListViewTile extends StatelessWidget {
  const PlaylistSongListViewTile({
    Key? key,
    required this.song,
    this.chooseSong = false,
    this.onSongChosen,
  }) : super(key: key);

  final Song song;
  final bool chooseSong;
  final Function? onSongChosen;

  @override
  Widget build(BuildContext context) {
    return MainContainer(
        margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
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
                  !chooseSong
                      ? Text(
                          "Album Name",
                          style: Theme.of(context).textTheme.headline2,
                        )
                      : Container()
                ],
              ),
              Row(
                children: [
                  (song.userId == Auth().getUserId())
                      ? MainIconButton(
                          icon: Icon(
                            CupertinoIcons.wand_stars,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          onPressed: () {
                            onSongChosen!(song);
                          },
                        )
                      : Container(),
                  chooseSong
                      ? MainIconButton(
                          icon: Icon(
                            CupertinoIcons.add_circled,
                            size: 30.0,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          toggle: true,
                          onPressed: () {
                            onSongChosen!(song);
                          },
                        )
                      : MainIconButton(
                          icon: Icon(
                            CupertinoIcons.xmark,
                            size: 20.0,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          onPressed: () {},
                        ),
                ],
              )
            ],
          ),
        ));
  }
}
