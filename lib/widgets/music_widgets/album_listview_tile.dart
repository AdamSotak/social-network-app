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
  UserData userData = UserData(
    id: "",
    username: "",
    displayName: "",
    profilePhotoURL: "",
    followers: 0,
    following: 0,
  );
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

    void openEditAlbumPage() {}

    void deleteAlbum() {
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

    void previous() async {
      await audioPlayer.seekToPrevious();
    }

    void next() async {
      await audioPlayer.seekToNext();
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
      try {
        await audioPlayer.setAudioSource(albumPlaylist, initialIndex: 0, initialPosition: Duration.zero);
        await audioPlayer.setLoopMode(LoopMode.all);
      } catch (_) {}
    }

    setupAudioPlayer();

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
          UserDataWidget(userData: userData, created: album.created),
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
                  style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 25.0, color: Colors.black),
                ),
                Text(
                  album.name,
                  style: Theme.of(context).textTheme.headline2!.copyWith(fontSize: 20.0, color: Colors.black),
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
                                        MainContainer(
                                          height: 100.0,
                                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    audioPlayer.playing ? "Now Playing..." : "Play...",
                                                    style: Theme.of(context).textTheme.headline3,
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    album.songs[audioPlayer.currentIndex ?? 0].name,
                                                    style: Theme.of(context).textTheme.caption,
                                                    overflow: TextOverflow.fade,
                                                  ),
                                                  Text(
                                                    album.name,
                                                    style:
                                                        Theme.of(context).textTheme.caption!.copyWith(fontSize: 15.0),
                                                    overflow: TextOverflow.fade,
                                                  )
                                                ],
                                              ),
                                              const Icon(
                                                CupertinoIcons.arrow_right,
                                                size: 30.0,
                                              )
                                            ],
                                          ),
                                        ),
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
                      Row(
                        children: [
                          Flexible(
                            child: MainContainer(
                              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                              pressable: true,
                              onPressed: previous,
                              child: const Center(
                                child: Icon(CupertinoIcons.backward_fill),
                              ),
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
                          Flexible(
                            child: MainContainer(
                              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                              pressable: true,
                              onPressed: next,
                              child: const Center(
                                child: Icon(CupertinoIcons.forward_fill),
                              ),
                            ),
                          ),
                        ],
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
          OptionsRow(preview: preview, song: true, onEdit: openEditAlbumPage, onDelete: deleteAlbum)
        ],
      ),
    );
  }
}
