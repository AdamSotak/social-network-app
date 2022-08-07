import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_network/database/songs_database.dart';
import 'package:social_network/models/song.dart';
import 'package:social_network/widgets/music_widgets/song_listview_tile.dart';
import 'package:social_network/widgets/no_data_tile.dart';

class SongsListView extends StatelessWidget {
  const SongsListView({Key? key, required this.userId}) : super(key: key);

  final String userId;

  // ListView for displaying songs

  @override
  Widget build(BuildContext context) {
    List<Song> songs = [];

    return StreamBuilder<QuerySnapshot>(
      stream: SongsDatabase().getSongStream(userId: userId),
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

        songs.clear();

        songs.addAll(snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
          var song = Song.fromDocumentSnapshot(documentSnapshot);
          return song;
        }));

        if (songs.isEmpty) {
          return const NoDataTile(text: "No Songs Yet");
        }

        return ListView.builder(
          clipBehavior: Clip.none,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: songs.length,
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          itemBuilder: (context, index) {
            var song = songs[index];
            return SongListViewTile(song: song);
          },
        );
      },
    );
  }
}
