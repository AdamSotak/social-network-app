import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/database/albums_database.dart';
import 'package:social_network/managers/dialog_manager.dart';
import 'package:social_network/models/album.dart';
import 'package:social_network/styling/styles.dart';
import 'package:social_network/widgets/main_widgets/main_app_bar.dart';
import 'package:social_network/widgets/main_widgets/main_text_field.dart';
import 'package:social_network/widgets/music_widgets/album_listview_tile.dart';

class EditAlbumPage extends StatefulWidget {
  const EditAlbumPage({Key? key, required this.album}) : super(key: key);

  final Album album;

  @override
  State<EditAlbumPage> createState() => _EditAlbumPageState();
}

class _EditAlbumPageState extends State<EditAlbumPage> {
  final TextEditingController albumNameTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    albumNameTextEditingController.text = widget.album.name;
  }

  @override
  Widget build(BuildContext context) {
    var album = widget.album;

    // Check data and update the album in the database
    void editAlbum() async {
      if (Styles.checkIfStringEmpty(albumNameTextEditingController.text)) {
        DialogManager().displaySnackBar(context: context, text: "Please enter album name");
        return;
      }

      DialogManager().displayLoadingDialog(context: context);

      album.name = albumNameTextEditingController.text;
      album.created = DateTime.now();

      await AlbumsDatabase().editAlbum(album).then((value) {
        DialogManager().closeDialog(context: context);
        Navigator.pop(context);
      });
    }

    // Update the AlbumListViewTile preview widget with new album name
    void onAlbumNameChanged(String value) {
      setState(() {
        album.name = value;
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
                title: "Edit Album",
                icon: const Icon(CupertinoIcons.check_mark),
                onIconPressed: editAlbum,
              ),
              const SizedBox(
                height: 50.0,
              ),
              AlbumListViewTile(album: album),
              MainTextField(
                controller: albumNameTextEditingController,
                hintText: "Album Name",
                onChanged: onAlbumNameChanged,
              ),
              const SizedBox(
                height: 100.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
