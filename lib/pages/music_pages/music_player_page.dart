import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/managers/dialog_manager.dart';
import 'package:social_network/models/enums/music_player_repeat_type.dart';
import 'package:social_network/models/enums/music_player_type.dart';
import 'package:social_network/models/playlist.dart';
import 'package:social_network/models/song.dart';
import 'package:social_network/pages/playlists_pages/playlist_page.dart';
import 'package:social_network/styling/styles.dart';
import 'package:social_network/widgets/main_widgets/main_app_bar.dart';
import 'package:social_network/widgets/main_widgets/main_container.dart';
import 'package:social_network/widgets/main_widgets/main_icon_button.dart';

class MusicPlayerPage extends StatefulWidget {
  const MusicPlayerPage({
    Key? key,
    this.playlist,
    this.song,
    required this.musicPlayerType,
  }) : super(key: key);

  final Playlist? playlist;
  final Song? song;
  final MusicPlayerType musicPlayerType;

  @override
  State<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  double seekbarValue = 0.5;
  bool shufflePlaylist = false;
  bool playing = false;
  Icon playPauseIcon = const Icon(CupertinoIcons.play_fill);
  Icon musicPlayerRepeatIcon = const Icon(CupertinoIcons.chevron_right_2);
  MusicPlayerRepeatType musicPlayerRepeatType = MusicPlayerRepeatType.none;
  int musicPlayerRepeatValue = 0;

  @override
  Widget build(BuildContext context) {
    var playlist = widget.playlist;
    var song = widget.song;
    var musicPlayerType = widget.musicPlayerType;

    void openPlaylistPage() {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (builder) => PlaylistPage(
            playlist: playlist!,
            gradient: Styles.getRandomLinearGradient(),
          ),
        ),
      );
    }

    void seekbarValueChanged(double value) {
      setState(() {
        seekbarValue = value;
      });
    }

    void shufflePlaylistChanged() {
      setState(() {
        shufflePlaylist = !shufflePlaylist;
      });
    }

    void repeatChanged() {
      if (musicPlayerRepeatValue < 2) {
        musicPlayerRepeatValue++;
      } else {
        musicPlayerRepeatValue = 0;
      }

      setState(() {
        switch (musicPlayerRepeatValue) {
          case 0:
            musicPlayerRepeatIcon = const Icon(CupertinoIcons.chevron_right_2);
            musicPlayerRepeatType = MusicPlayerRepeatType.none;
            break;
          case 1:
            musicPlayerRepeatIcon = const Icon(CupertinoIcons.repeat);
            musicPlayerRepeatType = MusicPlayerRepeatType.playlist;
            break;
          case 2:
            musicPlayerRepeatIcon = const Icon(CupertinoIcons.repeat_1);
            musicPlayerRepeatType = MusicPlayerRepeatType.song;
            break;
        }
      });
    }

    void playPauseChanged() {
      playing = !playing;
      setState(() {
        if (playing) {
          playPauseIcon = const Icon(CupertinoIcons.pause_fill);
        } else {
          playPauseIcon = const Icon(CupertinoIcons.play_fill);
        }
      });
    }

    void deletePlaylist() {}

    void displayPlaylistOptions() {
      DialogManager().displayModalBottomSheet(context: context, title: "Playlist Options", options: [
        ListTile(
          leading: Icon(
            CupertinoIcons.wand_stars,
            color: Theme.of(context).iconTheme.color,
          ),
          title: Text("Edit", style: Theme.of(context).textTheme.headline4),
          onTap: () {
            Navigator.pop(context);
            openPlaylistPage();
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
            deletePlaylist();
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

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
          child: IconTheme(
            data: const IconThemeData(color: Colors.black),
            child: Column(
              children: [
                MainAppBar(
                  title: playlist!.name,
                  icon: const Icon(CupertinoIcons.bars),
                  onIconPressed: displayPlaylistOptions,
                ),
                Column(
                  children: [
                    MainContainer(
                      height: (musicPlayerType == MusicPlayerType.playlist)
                          ? MediaQuery.of(context).size.height / 3.0
                          : 350.0,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.all(5.0),
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
                              Row(
                                children: [
                                  Text(
                                    playlist.name,
                                    style: Theme.of(context).textTheme.headline1!.copyWith(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    MainContainer(
                      height: 100.0,
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                      pressable: true,
                      onPressed: openPlaylistPage,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Now Playing...",
                                style: Theme.of(context).textTheme.headline3!.copyWith(color: Colors.black),
                              ),
                              const Spacer(),
                              Text(
                                "Song Name",
                                style: Theme.of(context).textTheme.caption!.copyWith(color: Colors.black),
                                overflow: TextOverflow.fade,
                              ),
                              Text(
                                "Album Name",
                                style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 15.0, color: Colors.black),
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
                    const SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "0:00",
                          style: Theme.of(context).textTheme.caption,
                        ),
                        MainIconButton(
                            icon: const Icon(CupertinoIcons.shuffle), toggle: true, onPressed: shufflePlaylistChanged),
                        MainIconButton(icon: musicPlayerRepeatIcon, onPressed: repeatChanged),
                        Text(
                          "3:00",
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    MainContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: CupertinoSlider(
                              value: seekbarValue,
                              onChanged: (double value) {
                                seekbarValueChanged(value);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: MainContainer(
                            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                            pressable: true,
                            onPressed: () {},
                            child: const Center(
                              child: Icon(CupertinoIcons.backward_fill),
                            ),
                          ),
                        ),
                        MainContainer(
                          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                          pressable: true,
                          toggleButton: true,
                          onPressed: playPauseChanged,
                          child: Center(
                            child: playPauseIcon,
                          ),
                        ),
                        Flexible(
                          child: MainContainer(
                            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                            pressable: true,
                            onPressed: () {},
                            child: const Center(
                              child: Icon(CupertinoIcons.forward_fill),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
