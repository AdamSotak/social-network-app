import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/database/playlists_database.dart';
import 'package:social_network/managers/dialog_manager.dart';
import 'package:social_network/models/playlist.dart';
import 'package:social_network/models/song.dart';
import 'package:social_network/styling/styles.dart';
import 'package:social_network/widgets/main_widgets/main_app_bar.dart';
import 'package:social_network/widgets/main_widgets/main_text_field.dart';
import 'package:social_network/widgets/music_widgets/playlists/playlist_song_listview_tile.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({Key? key, required this.playlist}) : super(key: key);

  final Playlist playlist;

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  final TextEditingController playlistNameTextEditingController = TextEditingController();

  @override
  void dispose() {
    playlistNameTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var playlist = widget.playlist;
    playlistNameTextEditingController.text = playlist.name;

    void playlistEditDone() async {
      if (Styles.checkIfStringEmpty(playlistNameTextEditingController.text)) {
        DialogManager().displaySnackBar(context: context, text: "Please enter playlist name");
        return;
      }

      if (playlistNameTextEditingController.text.length > 15) {
        DialogManager().displaySnackBar(context: context, text: "Please enter a name shorter than 15 characterse");
        return;
      }

      DialogManager().displayLoadingDialog(context: context);
      playlist.name = playlistNameTextEditingController.text;
      await PlaylistsDatabase().editPlaylist(playlist).then((value) {
        DialogManager().closeDialog(context: context);
        Navigator.pop(context);
      });
    }

    void removeSong(Song song) async {
      DialogManager().displayLoadingDialog(context: context);
      playlist.songs.remove(song);
      await PlaylistsDatabase().editPlaylist(playlist).then((value) {
        DialogManager().closeDialog(context: context);
        setState(() {});
        if (playlist.songs.isEmpty) {
          Navigator.pop(context, "Delete");
        }
      });
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
        child: Column(
          children: [
            MainAppBar(
              title: playlist.name,
              icon: const Icon(CupertinoIcons.check_mark),
              onIconPressed: playlistEditDone,
            ),
            const SizedBox(
              height: 20.0,
            ),
            MainTextField(
              controller: playlistNameTextEditingController,
              hintText: "Playlist Name",
            ),
            Expanded(
              child: ListView.builder(
                itemCount: playlist.songs.length,
                itemBuilder: (context, index) {
                  var song = playlist.songs[index];
                  return PlaylistSongListViewTile(
                    song: song,
                    onSongDelete: removeSong,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
