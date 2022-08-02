import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/models/album.dart';
import 'package:social_network/models/enums/audio_player_type.dart';
import 'package:social_network/models/enums/data_type.dart';
import 'package:social_network/styling/styles.dart';
import 'package:social_network/widgets/linked_text.dart';
import 'package:social_network/widgets/main_widgets/main_container.dart';
import 'package:social_network/widgets/main_widgets/main_icon_button.dart';
import 'package:social_network/widgets/music_widgets/audio_player_widget.dart';
import 'package:social_network/widgets/post_widgets/options_row.dart';
import 'package:social_network/widgets/post_widgets/user_data_widget.dart';

class AlbumListViewTile extends StatefulWidget {
  const AlbumListViewTile({Key? key, required this.album}) : super(key: key);

  final Album album;

  @override
  State<AlbumListViewTile> createState() => _AlbumListViewTileState();
}

class _AlbumListViewTileState extends State<AlbumListViewTile> {
  late bool preview = widget.album.id == "preview";

  @override
  Widget build(BuildContext context) {
    var album = widget.album;

    void deleteArtworkURL() {
      setState(() {
        album.artworkURL = "";
      });
    }

    return MainContainer(
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          UserDataWidget(userId: album.userId, created: album.created),
          const SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Album",
                  style: Theme.of(context).textTheme.headline1,
                ),
                LinkedText(
                  album.name,
                  style: Theme.of(context).textTheme.headline2!.copyWith(fontSize: 25.0),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          (album.artworkURL != "")
              ? (preview)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        MainContainer(
                          margin: const EdgeInsets.all(15.0),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.file(
                                File(album.artworkURL),
                              ),
                            ),
                          ),
                        ),
                        MainIconButton(icon: const Icon(CupertinoIcons.delete), onPressed: deleteArtworkURL)
                      ],
                    )
                  : MainContainer(
                      margin: const EdgeInsets.all(15.0),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(album.artworkURL),
                        ),
                      ),
                    )
              : Container(),
          !preview
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                  child: Column(
                    children: [
                      AudioPlayerWidget(audioPlayerType: AudioPlayerType.album, album: album, preview: preview),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Row(
                          children: [
                            (!preview)
                                ? (album.songs.length != 1)
                                    ? Text(
                                        "${Styles.getFormattedNumberString(album.songs.length)} Songs",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2!
                                            .copyWith(fontSize: 20.0, fontWeight: FontWeight.w500),
                                      )
                                    : Text(
                                        "${Styles.getFormattedNumberString(album.songs.length)} Song",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2!
                                            .copyWith(fontSize: 20.0, fontWeight: FontWeight.w500),
                                      )
                                : Container(),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
          const SizedBox(
            height: 30.0,
          ),
          OptionsRow(
            dataType: DataType.album,
            album: album,
            preview: preview,
          )
        ],
      ),
    );
  }
}
