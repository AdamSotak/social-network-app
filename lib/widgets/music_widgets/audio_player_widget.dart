import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:social_network/models/album.dart';
import 'package:social_network/models/enums/audio_player_type.dart';
import 'package:social_network/models/loop.dart';
import 'package:social_network/models/playlist.dart';
import 'package:social_network/models/song.dart';
import 'package:social_network/styling/styles.dart';
import 'package:social_network/widgets/main_widgets/main_container.dart';
import 'package:social_network/widgets/music_widgets/song_seekbar.dart';

class AudioPlayerWidget extends StatefulWidget {
  const AudioPlayerWidget({
    Key? key,
    this.loop,
    this.song,
    this.playlist,
    this.album,
    required this.audioPlayerType,
    required this.preview,
  }) : super(key: key);

  final Loop? loop;
  final Song? song;
  final Playlist? playlist;
  final Album? album;
  final AudioPlayerType audioPlayerType;
  final bool preview;

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool playing = false;

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var loop = widget.loop;
    var song = widget.song;
    var playlist = widget.playlist;
    var album = widget.album;
    var audioPlayerType = widget.audioPlayerType;
    var preview = widget.preview;

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
      switch (audioPlayerType) {
        case AudioPlayerType.loop:
          if (loop!.contentURL != "") {
            try {
              await audioPlayer.setFilePath(loop.contentURL);
              await audioPlayer.setLoopMode(LoopMode.one);
            } catch (_) {}
          }
          break;
        case AudioPlayerType.song:
          try {
            if (widget.song!.contentURL != "" && preview) {
              await audioPlayer.setFilePath(widget.song!.contentURL);
              await audioPlayer.setLoopMode(LoopMode.one);
            } else if (widget.song!.contentURL != "" && !preview) {
              await audioPlayer.setUrl(widget.song!.contentURL);
              await audioPlayer.setLoopMode(LoopMode.one);
            }
          } catch (_) {}
          break;
        case AudioPlayerType.playlist:
          // TODO: Handle this case.
          break;
        case AudioPlayerType.album:
          final albumPlaylist = ConcatenatingAudioSource(
            useLazyPreparation: true,
            shuffleOrder: DefaultShuffleOrder(),
            children: album!.songs.map((song) {
              return AudioSource.uri(Uri.parse(song.contentURL));
            }).toList(),
          );
          try {
            await audioPlayer.setAudioSource(albumPlaylist, initialIndex: 0, initialPosition: Duration.zero);
            await audioPlayer.setLoopMode(LoopMode.all);
          } catch (_) {}
          break;
      }
    }

    setupAudioPlayer();

    return Column(children: [
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
                        (audioPlayerType == AudioPlayerType.album)
                            ? MainContainer(
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
                                          album!.songs[audioPlayer.currentIndex ?? 0].name,
                                          style: Theme.of(context).textTheme.caption,
                                          overflow: TextOverflow.fade,
                                        ),
                                        Text(
                                          album.name,
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
                              )
                            : Container(),
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
          (audioPlayerType == AudioPlayerType.album)
              ? Flexible(
                  child: MainContainer(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                    pressable: true,
                    onPressed: previous,
                    child: const Center(
                      child: Icon(CupertinoIcons.backward_fill),
                    ),
                  ),
                )
              : Container(),
          Flexible(
            child: MainContainer(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
              pressable: true,
              toggleButton: true,
              onPressed: playPauseChanged,
              child: const Center(
                child: Icon(CupertinoIcons.playpause_fill),
              ),
            ),
          ),
          (audioPlayerType == AudioPlayerType.album)
              ? Flexible(
                  child: MainContainer(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                    pressable: true,
                    onPressed: next,
                    child: const Center(
                      child: Icon(CupertinoIcons.forward_fill),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    ]);
  }
}
