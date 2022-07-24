import 'package:flutter/material.dart';
import 'package:social_network/models/playlist.dart';
import 'package:social_network/widgets/main_app_bar.dart';
import 'package:social_network/widgets/playlists/playlist_gridview_tile.dart';

class PlaylistsPage extends StatefulWidget {
  const PlaylistsPage({Key? key}) : super(key: key);

  @override
  State<PlaylistsPage> createState() => _PlaylistsPageState();
}

class _PlaylistsPageState extends State<PlaylistsPage> {
  List<Playlist> playlists = [
    // Sample data
    Playlist(id: "id", userId: "userId", name: "Playlist", songs: [], created: DateTime.now()),
    Playlist(id: "id", userId: "userId", name: "Playlist", songs: [], created: DateTime.now()),
    Playlist(id: "id", userId: "userId", name: "Playlist", songs: [], created: DateTime.now()),
    Playlist(id: "id", userId: "userId", name: "Playlist", songs: [], created: DateTime.now()),
    Playlist(id: "id", userId: "userId", name: "Playlist", songs: [], created: DateTime.now()),
    Playlist(id: "id", userId: "userId", name: "Playlist", songs: [], created: DateTime.now()),
    Playlist(id: "id", userId: "userId", name: "Playlist", songs: [], created: DateTime.now()),
    Playlist(id: "id", userId: "userId", name: "Playlist", songs: [], created: DateTime.now()),
    Playlist(id: "id", userId: "userId", name: "Playlist", songs: [], created: DateTime.now()),
    Playlist(id: "id", userId: "userId", name: "Playlist", songs: [], created: DateTime.now()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(title: "Playlists"),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
        child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 200,
          ),
          itemCount: playlists.length,
          itemBuilder: ((context, index) {
            var playlist = playlists[index];
            return PlaylistGridViewTile(playlist: playlist);
          }),
        ),
      ),
    );
  }
}
