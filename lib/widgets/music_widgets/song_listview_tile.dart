import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/database/songs_database.dart';
import 'package:social_network/database/user_data_database.dart';
import 'package:social_network/managers/dialog_manager.dart';
import 'package:social_network/models/enums/audio_player_type.dart';
import 'package:social_network/models/song.dart';
import 'package:social_network/models/user_data.dart';
import 'package:social_network/widgets/main_widgets/main_container.dart';
import 'package:social_network/widgets/main_widgets/main_icon_button.dart';
import 'package:social_network/widgets/music_widgets/audio_player_widget.dart';
import 'package:social_network/widgets/post_widgets/options_row.dart';
import 'package:social_network/widgets/post_widgets/user_data_widget.dart';

class SongListViewTile extends StatefulWidget {
  const SongListViewTile({Key? key, required this.song}) : super(key: key);

  final Song song;

  @override
  State<SongListViewTile> createState() => _SongListViewTileState();
}

class _SongListViewTileState extends State<SongListViewTile> {
  late bool preview = widget.song.id == "preview";
  UserData userData = UserData(
    id: "",
    username: "",
    displayName: "",
    profilePhotoURL: "",
    followers: 0,
    following: 0,
  );

  Future<void> getUserData() async {
    userData = await UserDataDatabase().getUserData(widget.song.userId);
  }

  @override
  void initState() {
    super.initState();
    getUserData().whenComplete(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var song = widget.song;

    void openEditSongPage() {}

    void deleteSong() {
      DialogManager().displayConfirmationDialog(
        context: context,
        title: "Delete Song?",
        description: "Confirm song deletion",
        onConfirmation: () {
          SongsDatabase().deleteSong(song);
        },
        onCancellation: () {},
      );
    }

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
          UserDataWidget(userData: userData, created: song.created),
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
                Text(
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
          OptionsRow(preview: preview, playlist: true, onEdit: openEditSongPage, onDelete: deleteSong)
        ],
      ),
    );
  }
}
