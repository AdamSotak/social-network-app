import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_network/auth/auth.dart';
import 'package:social_network/database/loops_database.dart';
import 'package:social_network/managers/dialog_manager.dart';
import 'package:social_network/models/enums/audio_player_type.dart';
import 'package:social_network/models/loop.dart';
import 'package:social_network/styling/styles.dart';
import 'package:social_network/widgets/main_widgets/main_app_bar.dart';
import 'package:social_network/widgets/main_widgets/main_button.dart';
import 'package:social_network/widgets/music_widgets/audio_player_widget.dart';

class AddLoopPage extends StatefulWidget {
  const AddLoopPage({Key? key}) : super(key: key);

  @override
  State<AddLoopPage> createState() => _AddLoopPageState();
}

class _AddLoopPageState extends State<AddLoopPage> {
  String loopAudioButtonText = "Add Audio";
  Loop loop = Loop(
    id: "id",
    userId: Auth().getUserId(),
    contentURL: "",
    likes: 0,
    created: DateTime.now(),
  );

  @override
  Widget build(BuildContext context) {
    void addLoop() async {
      if (Styles.checkIfStringEmpty(loop.contentURL)) {
        DialogManager().displaySnackBar(context: context, text: "Please choose Loop audio");
        return;
      }

      DialogManager().displayLoadingDialog(context: context);

      loop.id = Auth.getUUID();
      loop.created = DateTime.now();

      await LoopsDatabase().addLoop(loop).then((value) {
        DialogManager().closeDialog(context: context);
        Navigator.pop(context);
      });
    }

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
              AudioPlayerWidget(audioPlayerType: AudioPlayerType.loop, loop: loop, preview: true),
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
