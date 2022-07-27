import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/models/playlist.dart';
import 'package:social_network/widgets/main_widgets/main_back_button.dart';
import 'package:social_network/widgets/main_widgets/main_icon_button.dart';
import 'package:social_network/widgets/music_widgets/playlists/playlist_song_listview_tile.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({Key? key, required this.playlist, required this.gradient}) : super(key: key);

  final Playlist playlist;
  final LinearGradient gradient;

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  @override
  Widget build(BuildContext context) {
    var playlist = widget.playlist;
    var gradient = widget.gradient;

    void deletePlaylist() {}

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
        child: Column(
          children: [
            Row(
              children: [
                const MainBackButton(),
                const Spacer(),
                Text(
                  playlist.name,
                  style: Theme.of(context).textTheme.headline1,
                ),
                const Spacer(),
                MainIconButton(
                  icon: const Icon(CupertinoIcons.delete),
                  onPressed: deletePlaylist,
                )
              ],
            ),
            Expanded(
                child: ListView.builder(
              itemCount: playlist.songs.length,
              itemBuilder: (context, index) {
                var song = playlist.songs[index];
                return PlaylistSongListViewTile(song: song);
              },
            ))
          ],
        ),
      ),
    );
  }
}
