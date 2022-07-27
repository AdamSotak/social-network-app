import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:social_network/auth/auth.dart';
import 'package:social_network/database/loops_database.dart';
import 'package:social_network/managers/dialog_manager.dart';
import 'package:social_network/models/loop.dart';
import 'package:social_network/styling/styles.dart';
import 'package:social_network/widgets/main_widgets/main_app_bar.dart';
import 'package:social_network/widgets/main_widgets/main_button.dart';
import 'package:social_network/widgets/main_widgets/main_container.dart';
import 'package:social_network/widgets/music_widgets/song_seekbar.dart';

class AddLoopPage extends StatefulWidget {
  const AddLoopPage({Key? key}) : super(key: key);

  @override
  State<AddLoopPage> createState() => _AddLoopPageState();
}

class _AddLoopPageState extends State<AddLoopPage> {
  bool playing = false;
  AudioPlayer audioPlayer = AudioPlayer();
  String loopAudioButtonText = "Add Audio";
  Loop loop = Loop(
    id: "id",
    userId: Auth().getUserId(),
    name: "",
    description: "",
    contentURL: "",
    created: DateTime.now(),
  );

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void addLoop() async {
      DialogManager().displayLoadingDialog(context: context);

      loop.id = Auth.getUUID();
      loop.created = DateTime.now();

      await LoopsDatabase().addLoop(loop).then((value) {
        DialogManager().closeDialog(context: context);
        Navigator.pop(context);
      });
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
      if (loop.contentURL != "") {
        await audioPlayer.setFilePath(loop.contentURL);
        await audioPlayer.setLoopMode(LoopMode.one);
      }
    }

    setupAudioPlayer();

    void chooseLoopAudio() async {
      try {
        FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: false, type: FileType.audio);
        if (result == null) return;
        File file = File(result.files.single.path!);
        setState(() {
          loop.contentURL = file.path;
          loopAudioButtonText = "Change Audio";
        });
      } on PlatformException catch (_) {
        DialogManager().displaySnackBar(context: context, text: "Please enable storage permission");
      } catch (error) {
        log(error.toString());
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
          child: Column(
            children: [
              MainAppBar(
                title: "Add Loop",
                icon: const Icon(CupertinoIcons.check_mark),
                onIconPressed: addLoop,
              ),
              const SizedBox(
                height: 50.0,
              ),
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
                height: 20.0,
              ),
              MainButton(
                text: loopAudioButtonText,
                margin: const EdgeInsets.all(5.0),
                onPressed: chooseLoopAudio,
              )
            ],
          ),
        ),
      ),
    );
  }
}
