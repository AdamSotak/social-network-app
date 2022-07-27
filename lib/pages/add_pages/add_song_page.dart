import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_network/auth/auth.dart';
import 'package:social_network/models/song.dart';
import 'package:social_network/widgets/main_widgets/main_app_bar.dart';
import 'package:social_network/widgets/main_widgets/main_button.dart';
import 'package:social_network/widgets/main_widgets/main_text_field.dart';
import 'package:social_network/widgets/song_listview_tile.dart';

class AddSongPage extends StatefulWidget {
  const AddSongPage({Key? key}) : super(key: key);

  @override
  State<AddSongPage> createState() => _AddSongPageState();
}

class _AddSongPageState extends State<AddSongPage> {
  final TextEditingController songNameTextEditingController = TextEditingController();
  String songButtonText = "Add Song";
  Song song = Song(
    id: "preview",
    userId: Auth().getUserId(),
    name: "",
    albumId: "",
    contentURL: "",
    likes: 0,
    created: DateTime.now(),
  );

  @override
  Widget build(BuildContext context) {
    void addSong() {}

    void onSongNameChanged(String value) {
      setState(() {
        song.contentURL = "";
        song.name = value;
      });
    }

    void chooseSong() async {
      try {
        FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: false, type: FileType.audio);
        if (result == null) return;
        File file = File(result.files.single.path!);
        setState(() {
          song.contentURL = file.path;
          songButtonText = "Change Song";
        });
      } on PlatformException catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enable storage permission")));
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
                title: "Add Song",
                icon: const Icon(CupertinoIcons.check_mark),
                onIconPressed: addSong,
              ),
              const SizedBox(
                height: 50.0,
              ),
              Column(
                children: [
                  SongListViewTile(
                    song: song,
                  ),
                  MainTextField(
                    controller: songNameTextEditingController,
                    hintText: "Song Name",
                    onChanged: onSongNameChanged,
                  )
                ],
              ),
              MainButton(text: songButtonText, onPressed: chooseSong)
            ],
          ),
        ),
      ),
    );
  }
}
