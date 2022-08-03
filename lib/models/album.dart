import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_network/models/song.dart';

class Album {
  String id;
  String userId;
  String name;
  String artworkURL;
  List<Song> songs;
  int likes;
  List<String> hashtags;
  DateTime created;

  Album({
    required this.id,
    required this.userId,
    required this.name,
    required this.artworkURL,
    required this.songs,
    required this.likes,
    required this.hashtags,
    required this.created,
  });

  factory Album.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;

    return Album(
      id: documentSnapshot.id,
      userId: data['userId'] as String,
      name: data['name'] as String,
      artworkURL: data['artworkURL'] as String,
      songs: (data['songs'] as List).map((song) => Song.fromJson(song)).toList(),
      likes: data['likes'] as int,
      hashtags: (data['hashtags'] as List).map((hashtag) => hashtag.toString()).toList(),
      created: DateTime.fromMillisecondsSinceEpoch(data['created'].seconds * 1000),
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> songsJson = [];
    for (var song in songs) {
      songsJson.add(song.toJson());
    }
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'artworkURL': artworkURL,
      'songs': songsJson,
      'likes': likes,
      'hashtags': hashtags,
      'created': created,
    };
  }
}
