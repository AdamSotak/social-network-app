import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:social_network/database/albums_database.dart';
import 'package:social_network/database/user_data_database.dart';
import 'package:social_network/managers/dialog_manager.dart';
import 'package:social_network/models/album.dart';
import 'package:social_network/models/user_data.dart';
import 'package:social_network/styling/styles.dart';
import 'package:social_network/widgets/main_widgets/main_container.dart';
import 'package:social_network/widgets/main_widgets/main_icon_button.dart';
import 'package:social_network/widgets/music_widgets/song_seekbar.dart';

class AlbumListViewTile extends StatefulWidget {
  const AlbumListViewTile({Key? key, required this.album}) : super(key: key);

  final Album album;

  @override
  State<AlbumListViewTile> createState() => _AlbumListViewTileState();
}

class _AlbumListViewTileState extends State<AlbumListViewTile> {
  late bool preview = widget.album.id == "preview";
  UserData userData = UserData(id: "", username: "", displayName: "", profilePhotoURL: "");
  bool playing = false;
  final AudioPlayer audioPlayer = AudioPlayer();

  Future<void> getUserData() async {
    userData = await UserDataDatabase().getUserData(widget.album.userId);
  }

  @override
  void initState() {
    super.initState();
    getUserData().whenComplete(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var album = widget.album;
    final albumPlaylist = ConcatenatingAudioSource(
      useLazyPreparation: true,
      shuffleOrder: DefaultShuffleOrder(),
      children: album.songs.map((song) {
        return AudioSource.uri(Uri.parse(song.contentURL));
      }).toList(),
    );

    void editSong() {}

    void deleteSong() {
      DialogManager().displayConfirmationDialog(
        context: context,
        title: "Delete Album?",
        description: "Confirm album deletion",
        onConfirmation: () {
          AlbumsDatabase().deleteAlbum(album);
        },
        onCancellation: () {},
      );
    }

    void play() {
      audioPlayer.play();
    }

    void pause() {
      audioPlayer.pause();
    }

    void playPauseChanged() {
      playing = !playing;

      if (!playing) {
        pause();
      } else {
        play();
      }
    }

    void setupAudioPlayer() async {
      await audioPlayer.setAudioSource(albumPlaylist, initialIndex: 0, initialPosition: Duration.zero);
    }

    setupAudioPlayer();

    void displaySongOptions() {
      DialogManager().displayModalBottomSheet(context: context, title: "Post Options", options: [
        ListTile(
          leading: Icon(
            CupertinoIcons.wand_stars,
            color: Theme.of(context).iconTheme.color,
          ),
          title: Text("Edit", style: Theme.of(context).textTheme.headline4),
          onTap: () {
            Navigator.pop(context);
            editSong();
          },
        ),
        ListTile(
          leading: Icon(
            CupertinoIcons.delete,
            color: Theme.of(context).iconTheme.color,
          ),
          title: Text("Delete", style: Theme.of(context).textTheme.headline4),
          onTap: () {
            Navigator.pop(context);
            deleteSong();
          },
        ),
        ListTile(
          leading: Icon(
            CupertinoIcons.xmark,
            color: Theme.of(context).iconTheme.color,
          ),
          title: Text("Close", style: Theme.of(context).textTheme.headline4),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ]);
    }

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
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage("development_assets/images/profile_image.jpg"),
                  radius: 30.0,
                  backgroundColor: Styles.defaultImageBackgroundColor,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userData.displayName,
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    Text("@${userData.username}"),
                    Text(Styles.getFormattedDateString(album.created)),
                  ],
                )
              ],
            ),
          ),
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
                  style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 25.0),
                ),
                Text(
                  album.name,
                  style: Theme.of(context).textTheme.headline2!.copyWith(fontSize: 20.0),
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
                          margin: const EdgeInsets.all(10.0),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
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
                      margin: const EdgeInsets.all(10.0),
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
                      MainContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            StreamBuilder<Duration?>(
                              stream: audioPlayer.durationStream,
                              builder: ((context, snapshot) {
                                final duration = snapshot.data ?? Duration.zero;
                                return StreamBuilder<Duration>(
                                  stream: audioPlayer.createPositionStream(),
                                  builder: (context, snapshot) {
                                    var position = snapshot.data ?? Duration.zero;
                                    var seekbarValue = (100.0 / duration.inSeconds) * position.inSeconds;
                                    if (seekbarValue.toString() == "NaN") {
                                      seekbarValue = 0.0;
                                    }
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        SeekBar(
                                          duration: duration,
                                          position: position,
                                          bufferedPosition: const Duration(milliseconds: 0),
                                          onChangeEnd: (newPosition) async {
                                            await audioPlayer.seek(newPosition);
                                          },
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 10.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                Styles.getFormattedSeconds(position.inSeconds),
                                                style: Theme.of(context).textTheme.caption,
                                              ),
                                              Text(
                                                Styles.getFormattedSeconds(duration.inSeconds),
                                                style: Theme.of(context).textTheme.caption,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                      MainContainer(
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                        pressable: true,
                        toggleButton: true,
                        onPressed: playPauseChanged,
                        child: const Center(
                          child: Icon(CupertinoIcons.playpause_fill),
                        ),
                      ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  MainIconButton(
                    icon: const Icon(
                      CupertinoIcons.heart,
                      color: Colors.red,
                    ),
                    onPressed: () {},
                  ),
                  MainIconButton(
                    icon: Icon(
                      CupertinoIcons.bubble_left,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    onPressed: () {},
                  ),
                  MainIconButton(
                    icon: Icon(
                      CupertinoIcons.music_albums,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              MainIconButton(
                icon: Icon(
                  CupertinoIcons.settings,
                  color: Theme.of(context).iconTheme.color,
                ),
                onPressed: (preview) ? () {} : displaySongOptions,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
