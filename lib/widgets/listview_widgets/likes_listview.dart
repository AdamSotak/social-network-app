import 'package:flutter/material.dart';
import 'package:social_network/database/albums_database.dart';
import 'package:social_network/database/likes_database.dart';
import 'package:social_network/database/posts_database.dart';
import 'package:social_network/database/songs_database.dart';
import 'package:social_network/widgets/music_widgets/album_listview_tile.dart';
import 'package:social_network/widgets/music_widgets/song_listview_tile.dart';
import 'package:social_network/widgets/no_data_tile.dart';
import 'package:social_network/widgets/post_widgets/post_listview_tile.dart';

class LikesListView extends StatelessWidget {
  const LikesListView({Key? key, required this.userId}) : super(key: key);

  final String userId;

  // ListView for displaying liked posts

  // Load all liked post data types into a Map with a data type key in the liked order
  Future<List<Map<String, dynamic>>> load() async {
    List<Map<String, dynamic>> data = [];
    var likes = await LikesDatabase().getLikes(userId: userId);
    likes.sort((a, b) {
      return b.created.compareTo(a.created);
    });
    if (likes.isEmpty) {
      return [];
    }
    List<String> likedPosts = likes.map((like) => like.postId).toList();
    List<dynamic> dataMix = [];
    var posts = await PostsDatabase().getLikedPosts(likedPosts: likedPosts);
    var songs = await SongsDatabase().getLikedSongs(likedSongs: likedPosts);
    var albums = await AlbumsDatabase().getLikedAlbums(likedAlbums: likedPosts);
    dataMix.addAll(posts);
    dataMix.addAll(songs);
    dataMix.addAll(albums);
    for (var like in likes) {
      var dataValue = dataMix.where((element) => element.id == like.postId).toList().first;
      if (posts.contains(dataValue)) {
        data.add({"post": dataValue});
      } else if (songs.contains(dataValue)) {
        data.add({"song": dataValue});
      } else if (albums.contains(dataValue)) {
        data.add({"album": dataValue});
      }
    }
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
          return const NoDataTile(text: "No Likes Yet");
        }

        return ListView.builder(
          itemCount: data.length,
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
