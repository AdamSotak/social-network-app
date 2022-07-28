import 'package:flutter/material.dart';
import 'package:social_network/models/playlist.dart';
import 'package:social_network/models/song.dart';
import 'package:social_network/widgets/music_widgets/playlists/playlist_gridview_tile.dart';

class PlaylistsPage extends StatefulWidget {
  const PlaylistsPage({Key? key}) : super(key: key);

  @override
  State<PlaylistsPage> createState() => _PlaylistsPageState();
}

class _PlaylistsPageState extends State<PlaylistsPage> {
  List<Playlist> playlists = [
    // Sample data
    Playlist(
        id: "id",
        userId: "userId",
        name: "Playlist",
        songs: [
          Song(
              id: "id",
              userId: "userId",
              name: "Song Name",
              albumId: "",
              artworkURL: "",
              contentURL: "",
              likes: 10,
              created: DateTime.now()),
          Song(
              id: "id",
              userId: "userId",
              name: "Song Name",
              albumId: "",
              artworkURL: "",
              contentURL: "",
              likes: 10,
              created: DateTime.now())
        ],
        created: DateTime.now()),
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0.0),
              child: Text(
                "Playlists",
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              clipBehavior: Clip.none,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(10.0),
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
          ],
        ),
      ),
    );
  }
}
