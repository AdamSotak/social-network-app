import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/database/songs_database.dart';
import 'package:social_network/managers/dialog_manager.dart';
import 'package:social_network/models/song.dart';
import 'package:social_network/styling/styles.dart';
import 'package:social_network/widgets/main_widgets/main_app_bar.dart';
import 'package:social_network/widgets/main_widgets/main_text_field.dart';
import 'package:social_network/widgets/music_widgets/song_listview_tile.dart';

class EditSongPage extends StatefulWidget {
  const EditSongPage({Key? key, required this.song}) : super(key: key);

  final Song song;

  @override
  State<EditSongPage> createState() => _EditSongPageState();
}

class _EditSongPageState extends State<EditSongPage> {
  final TextEditingController songNameTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    songNameTextEditingController.text = widget.song.name;
  }

  @override
  Widget build(BuildContext context) {
    var song = widget.song;

    // Check data and update the Song in the database
    void editSong() async {
      if (Styles.checkIfStringEmpty(songNameTextEditingController.text)) {
        DialogManager().displaySnackBar(context: context, text: "Please enter song name");
        return;
      }

      DialogManager().displayLoadingDialog(context: context);

      song.name = songNameTextEditingController.text;
      song.created = DateTime.now();

      await SongsDatabase().editSong(song).then((value) {
        DialogManager().closeDialog(context: context);
        Navigator.pop(context);
      });
    }

    // Update the SongListViewTile preview widget with new song name
    void onSongNameChanged(String value) {
      setState(() {
        song.name = value;
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
                title: "Edit Song",
                icon: const Icon(CupertinoIcons.check_mark),
                onIconPressed: editSong,
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
              const SizedBox(
                height: 50.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
