import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_network/auth/auth.dart';
import 'package:social_network/database/songs_database.dart';
import 'package:social_network/managers/dialog_manager.dart';
import 'package:social_network/models/song.dart';
import 'package:social_network/styling/styles.dart';
import 'package:social_network/widgets/main_widgets/main_app_bar.dart';
import 'package:social_network/widgets/main_widgets/main_button.dart';
import 'package:social_network/widgets/main_widgets/main_text_field.dart';
import 'package:social_network/widgets/music_widgets/song_listview_tile.dart';

class AddSongPage extends StatefulWidget {
  const AddSongPage({Key? key}) : super(key: key);

  @override
  State<AddSongPage> createState() => _AddSongPageState();
}

class _AddSongPageState extends State<AddSongPage> {
  final TextEditingController songNameTextEditingController = TextEditingController();
  String songButtonText = "Add Song";
  String songArtworkButtonText = "Add Artwork";
  String songContentURL = "";
  Song song = Song(
    id: "preview",
    userId: Auth().getUserId(),
    name: "",
    albumId: "",
    artworkURL: "",
    contentURL: "",
    likes: 0,
    created: DateTime.now(),
  );

  @override
  void dispose() {
    songNameTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void addSong() async {
      if (Styles.checkIfStringEmpty(songNameTextEditingController.text)) {
        DialogManager().displaySnackBar(context: context, text: "Please enter song name");
        return;
      }

      if (Styles.checkIfStringEmpty(songContentURL)) {
        DialogManager().displaySnackBar(context: context, text: "Please choose a song");
        return;
      }

      DialogManager().displayLoadingDialog(context: context);

      song.id = Auth.getUUID();
      song.contentURL = songContentURL;
      song.created = DateTime.now();

      await SongsDatabase().addSong(song).then((value) {
        DialogManager().closeDialog(context: context);
        Navigator.pop(context);
      });
    }

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
          songContentURL = file.path;
          songButtonText = "Change Song";
        });
      } on PlatformException catch (_) {
        DialogManager().displaySnackBar(context: context, text: "Please enable storage permission");
      } catch (error) {
        log(error.toString());
      }
    }

    void chooseSongArtwork() async {
      final ImagePicker imagePicker = ImagePicker();
      final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);

      if (image == null) return;
      var decodedImage = await decodeImageFromList(await image.readAsBytes());
      if (decodedImage.width - decodedImage.height > 5 || decodedImage.width - decodedImage.height < 0) {
        DialogManager().displaySnackBar(context: context, text: "Please use an image with equal width and height");
        return;
      }

      setState(() {
        songArtworkButtonText = "Change Song Artwork";
        song.artworkURL = image.path;
      });
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
              MainButton(text: songButtonText, onPressed: chooseSong),
              MainButton(text: songArtworkButtonText, onPressed: chooseSongArtwork),
            ],
          ),
        ),
      ),
    );
  }
}
