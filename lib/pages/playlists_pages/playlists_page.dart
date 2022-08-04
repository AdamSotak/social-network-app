import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_network/database/playlists_database.dart';
import 'package:social_network/managers/dialog_manager.dart';
import 'package:social_network/models/album.dart';
import 'package:social_network/models/enums/data_type.dart';
import 'package:social_network/models/playlist.dart';
import 'package:social_network/models/song.dart';
import 'package:social_network/widgets/main_widgets/main_back_button.dart';
import 'package:social_network/widgets/music_widgets/playlists/playlist_gridview_tile.dart';
import 'package:social_network/widgets/no_data_tile.dart';

class PlaylistsPage extends StatefulWidget {
  const PlaylistsPage({
    Key? key,
    this.dataType = DataType.song,
    this.select = false,
    this.song,
    this.album,
  }) : super(key: key);

  final bool select;
  final DataType dataType;
  final Song? song;
  final Album? album;

  @override
  State<PlaylistsPage> createState() => _PlaylistsPageState();
}

class _PlaylistsPageState extends State<PlaylistsPage> {
  List<Playlist> playlists = [];

  @override
  Widget build(BuildContext context) {
    var select = widget.select;
    var song = widget.song;
    var album = widget.album;

    void playlistSelected(Playlist playlist) async {
      if (song != null && !playlist.songs.contains(song.id)) {
        playlist.songs.add(song.id);
      } else if (album != null) {
        playlist.songs.addAll(album.songs);
        playlist.songs = playlist.songs.toSet().toList();
      }

      DialogManager().displayLoadingDialog(context: context);
      await PlaylistsDatabase().editPlaylist(playlist).then((value) {
        DialogManager().closeDialog(context: context);
        Navigator.pop(context);
      });
    }

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            select
                ? Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10.0, 30.0, 0.0, 0.0),
                        child: MainBackButton(buildContext: context),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0.0),
                        child: Text(
                          "Playlists",
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0.0),
                    child: Text(
                      "Playlists",
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
            StreamBuilder<QuerySnapshot>(
              stream: PlaylistsDatabase().getPlaylistStream(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                // Error and loading checking
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Something went wrong"),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }

                playlists.clear();

                playlists.addAll(snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
                  var post = Playlist.fromDocumentSnapshot(documentSnapshot);
                  return post;
                }));

                if (playlists.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 5),
                    child: const NoDataTile(
                      text: "No Playlists Yet",
                      subtext: "Create playlists with songs you listen to",
                    ),
                  );
                }

                return GridView.builder(
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
                    return select
                        ? GestureDetector(
                            onTap: () {
                              playlistSelected(playlist);
                            },
                            child: PlaylistGridViewTile(playlist: playlist, select: true),
                          )
                        : PlaylistGridViewTile(playlist: playlist);
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
