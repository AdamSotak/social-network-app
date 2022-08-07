import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:social_network/database/playlists_database.dart';
import 'package:social_network/database/songs_database.dart';
import 'package:social_network/managers/dialog_manager.dart';
import 'package:social_network/models/enums/music_player_type.dart';
import 'package:social_network/models/playlist.dart';
import 'package:social_network/models/song.dart';
import 'package:social_network/pages/playlists_pages/playlist_page.dart';
import 'package:social_network/styling/styles.dart';
import 'package:social_network/widgets/main_widgets/main_app_bar.dart';
import 'package:social_network/widgets/main_widgets/main_container.dart';
import 'package:social_network/widgets/main_widgets/main_icon_button.dart';
import 'package:social_network/widgets/music_widgets/song_seekbar.dart';

class MusicPlayerPage extends StatefulWidget {
  const MusicPlayerPage({
    Key? key,
    required this.playlist,
    required this.musicPlayerType,
  }) : super(key: key);

  final Playlist playlist;
  final MusicPlayerType musicPlayerType;

  @override
  State<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  double seekbarValue = 0.5;
  bool shufflePlaylist = false;
  bool playing = false;
  final AudioPlayer audioPlayer = AudioPlayer();
  Icon musicPlayerLoopModeIcon = const Icon(CupertinoIcons.chevron_right_2);
  LoopMode musicPlayerLoopMode = LoopMode.off;
  int musicPlayerLoopModeValue = 0;
  List<Song> songs = [];
  late Future<List<Song>> loadSongsFuture;

  @override
  void initState() {
    loadSongsFuture = SongsDatabase().getSongsById(songs: widget.playlist.songs);
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var playlist = widget.playlist;
    var musicPlayerType = widget.musicPlayerType;

    // AudioPlayer controls
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

    // Setup AudioPlayer to play the playlist
    void setupAudioPlayer() async {
      try {
        final audioPlaylist = ConcatenatingAudioSource(
          useLazyPreparation: true,
          shuffleOrder: DefaultShuffleOrder(),
          children: songs.map((song) {
            return AudioSource.uri(Uri.parse(song.contentURL));
          }).toList(),
        );
        await audioPlayer.setAudioSource(audioPlaylist, initialIndex: 0, initialPosition: Duration.zero);
        await audioPlayer.setLoopMode(musicPlayerLoopMode);
      } catch (_) {}
    }

    // Remove Playlist from the database
    void deletePlaylist({bool confirmation = true}) async {
      if (!confirmation) {
        DialogManager().displayLoadingDialog(context: context);
        await PlaylistsDatabase().deletePlaylist(playlist).then((value) {
          DialogManager().closeDialog(context: context);
          Navigator.pop(context);
        });
        return;
      }

      DialogManager().displayConfirmationDialog(
        context: context,
        title: "Delete Playlist",
        description: "Confirm Playlist deletion",
        onConfirmation: () async {
          DialogManager().displayLoadingDialog(context: context);
          await PlaylistsDatabase().deletePlaylist(playlist).then((value) {
            DialogManager().closeDialog(context: context);
            Navigator.pop(context);
          });
        },
        onCancellation: () {},
      );
    }

    // Open PlaylistPage to edit the playlist
    void openPlaylistPage() {
      pause();
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (builder) => PlaylistPage(
            playlist: playlist,
            songs: songs,
            songRemovedFromPlaylist: (Song song) {
              playlist.songs.remove(song.id);
              songs.remove(song);
            },
          ),
        ),
      ).then((value) {
        if (value == "Delete") {
          deletePlaylist(confirmation: false);
          return;
        }
        if (playing) {
          play();
        }
        setState(() {});
      });
    }

    // Change the AudioPlayer shuffle mode setting
    void shufflePlaylistChanged() async {
      setState(() {
        shufflePlaylist = !shufflePlaylist;
      });

      await audioPlayer.setShuffleModeEnabled(shufflePlaylist);
    }

    // Change icon and the AudioPlayer loop mode setting
    void loopModeChanged() {
      if (musicPlayerLoopModeValue < 2) {
        musicPlayerLoopModeValue++;
      } else {
        musicPlayerLoopModeValue = 0;
      }

      setState(() {
        switch (musicPlayerLoopModeValue) {
          case 0:
            musicPlayerLoopModeIcon = const Icon(CupertinoIcons.chevron_right_2);
            musicPlayerLoopMode = LoopMode.off;
            break;
          case 1:
            musicPlayerLoopModeIcon = const Icon(CupertinoIcons.repeat);
            musicPlayerLoopMode = LoopMode.all;
            break;
          case 2:
            musicPlayerLoopModeIcon = const Icon(CupertinoIcons.repeat_1);
            musicPlayerLoopMode = LoopMode.one;
            break;
        }
      });
    }

    // Display a modal bottom sheet with playlist options
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
          child: Column(
            children: [
              MainAppBar(
                title: playlist.name,
                icon: const Icon(CupertinoIcons.bars),
                onIconPressed: displayPlaylistOptions,
              ),
              FutureBuilder<List<Song>>(
                future: loadSongsFuture,
                builder: (context, snapshot) {
                  // Error and loading checking
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Something went wrong"),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  songs = snapshot.data!;
                  setupAudioPlayer();

                  return Column(
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
                                    SizedBox(
                                      width: 300.0,
                                      child: Text(
                                        playlist.name,
                                        style: Theme.of(context).textTheme.headline1!.copyWith(color: Colors.white),
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      StreamBuilder<Duration?>(
                        stream: audioPlayer.durationStream,
                        builder: (context, snapshot) {
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
                                children: [
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
                                              audioPlayer.playing ? "Now Playing..." : "Play...",
                                              style: Theme.of(context).textTheme.headline3,
                                            ),
                                            const Spacer(),
                                            Text(
                                              songs[audioPlayer.currentIndex ?? 0].name,
                                              style: Theme.of(context).textTheme.caption,
                                              overflow: TextOverflow.fade,
                                            ),
                                            Text(
                                              playlist.name,
                                              style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 15.0),
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
                                        Styles.getFormattedSeconds(position.inSeconds),
                                        style: Theme.of(context).textTheme.caption,
                                      ),
                                      MainIconButton(
                                          icon: const Icon(CupertinoIcons.shuffle),
                                          toggleButton: true,
                                          toggled: shufflePlaylist,
                                          onPressed: shufflePlaylistChanged),
                                      MainIconButton(icon: musicPlayerLoopModeIcon, onPressed: loopModeChanged),
                                      Text(
                                        Styles.getFormattedSeconds(duration.inSeconds),
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
                                        SeekBar(
                                          duration: duration,
                                          position: position,
                                          bufferedPosition: const Duration(milliseconds: 0),
                                          onChangeEnd: (newPosition) async {
                                            await audioPlayer.seek(newPosition);
                                          },
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
                                          onPressed: previous,
                                          child: const Center(
                                            child: Icon(CupertinoIcons.backward_fill),
                                          ),
                                        ),
                                      ),
                                      MainContainer(
                                        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                                        pressable: true,
                                        toggleButton: true,
                                        toggled: playing,
                                        onPressed: playPauseChanged,
                                        child: const Center(
                                          child: Icon(CupertinoIcons.playpause_fill),
                                        ),
                                      ),
                                      Flexible(
                                        child: MainContainer(
                                          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                                          pressable: true,
                                          onPressed: next,
                                          child: const Center(
                                            child: Icon(CupertinoIcons.forward_fill),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
