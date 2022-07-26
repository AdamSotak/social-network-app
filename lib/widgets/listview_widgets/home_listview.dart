import 'package:flutter/material.dart';
import 'package:social_network/database/albums_database.dart';
import 'package:social_network/database/posts_database.dart';
import 'package:social_network/database/songs_database.dart';
import 'package:social_network/widgets/music_widgets/album_listview_tile.dart';
import 'package:social_network/widgets/music_widgets/song_listview_tile.dart';
import 'package:social_network/widgets/no_data_tile.dart';
import 'package:social_network/widgets/post_widgets/post_listview_tile.dart';

class HomeListView extends StatelessWidget {
  const HomeListView({Key? key}) : super(key: key);

  // ListView for displaying all post data types on the HomePage

  // Load all post data types into a Map with a data type key and shuffle
  Future<List<Map<String, dynamic>>> load() async {
    List<Map<String, dynamic>> data = [];
    List<dynamic> dataMix = [];
    var posts = await PostsDatabase().getPosts();
    var songs = await SongsDatabase().getSongs();
    var albums = await AlbumsDatabase().getAlbums();
    dataMix.addAll(posts);
    dataMix.addAll(songs);
    dataMix.addAll(albums);
    for (var value in dataMix) {
      if (posts.contains(value)) {
        data.add({"post": value});
      } else if (songs.contains(value)) {
        data.add({"song": value});
      } else if (albums.contains(value)) {
        data.add({"album": value});
      }
    }
    data.shuffle();
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: load(),
      builder: (context, snapshot) {
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

        List<Map<String, dynamic>> data = snapshot.data!;

        if (data.isEmpty) {
          return const NoDataTile(
            text: "Ooops...",
            subtext: "No Posts Yet",
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          clipBehavior: Clip.none,
          itemCount: data.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            var dataMap = data[index];
            var dataValue = data[index].values.first;
            switch (dataMap.keys.first) {
              case "post":
                return PostListViewTile(post: dataValue);
              case "song":
                return SongListViewTile(song: dataValue);
              case "album":
                return AlbumListViewTile(album: dataValue);
            }

            return Container();
          },
        );
      },
    );
  }
}
