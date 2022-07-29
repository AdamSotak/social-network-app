import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_network/database/albums_database.dart';
import 'package:social_network/models/album.dart';
import 'package:social_network/widgets/music_widgets/album_listview_tile.dart';
import 'package:social_network/widgets/no_data_tile.dart';

class AlbumsListView extends StatelessWidget {
  const AlbumsListView({Key? key, required this.userId}) : super(key: key);

  final String userId;

  @override
  Widget build(BuildContext context) {
    List<Album> albums = [];

    return StreamBuilder<QuerySnapshot>(
      stream: AlbumsDatabase().getAlbumStream(userId: userId),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // Error and loading checking
        if (snapshot.hasError) {
          return const Center(
            child: Text("Something went wrong"),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        albums.clear();

        albums.addAll(snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
          var album = Album.fromDocumentSnapshot(documentSnapshot);
          return album;
        }));

        if (albums.isEmpty) {
          return const NoDataTile(text: "No Albums Yet");
        }

        return ListView.builder(
          clipBehavior: Clip.none,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: albums.length,
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          itemBuilder: (context, index) {
            var album = albums[index];
            return AlbumListViewTile(album: album);
          },
        );
      },
    );
  }
}
