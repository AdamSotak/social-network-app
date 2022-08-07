import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/models/enums/audio_player_type.dart';
import 'package:social_network/models/enums/data_type.dart';
import 'package:social_network/models/song.dart';
import 'package:social_network/widgets/linked_text.dart';
import 'package:social_network/widgets/main_widgets/main_container.dart';
import 'package:social_network/widgets/main_widgets/main_icon_button.dart';
import 'package:social_network/widgets/music_widgets/audio_player_widget.dart';
import 'package:social_network/widgets/post_widgets/options_row.dart';
import 'package:social_network/widgets/post_widgets/user_data_widget.dart';

// ListView tile for displaying a Song

class SongListViewTile extends StatefulWidget {
  const SongListViewTile({Key? key, required this.song}) : super(key: key);

  final Song song;

  @override
  State<SongListViewTile> createState() => _SongListViewTileState();
}

class _SongListViewTileState extends State<SongListViewTile> {
  late bool preview = widget.song.id == "preview";

  @override
  Widget build(BuildContext context) {
    var song = widget.song;

    // Delete the artwork URL
    void deleteArtworkURL() {
      setState(() {
        song.artworkURL = "";
      });
    }

    return MainContainer(
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          UserDataWidget(userId: song.userId, created: song.created),
          const SizedBox(
            height: 20.0,
          ),
          const SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            child: Column(
              children: [
                LinkedText(
                  song.name,
                  style: Theme.of(context).textTheme.headline2!.copyWith(fontSize: 25.0),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          (song.artworkURL != "")
              ? (preview)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        MainContainer(
                          margin: const EdgeInsets.all(15.0),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.file(
                                File(song.artworkURL),
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
                          child: Image.network(song.artworkURL),
                        ),
                      ),
                    )
              : Container(),
          AudioPlayerWidget(audioPlayerType: AudioPlayerType.song, song: song, preview: preview),
          const SizedBox(
            height: 30.0,
          ),
          OptionsRow(
            dataType: DataType.song,
            song: song,
            preview: preview,
          )
        ],
      ),
    );
  }
}
