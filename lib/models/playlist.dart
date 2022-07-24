import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_network/models/song.dart';

class Playlist {
  String id;
  String userId;
  String name;
  List<Song> songs;
  DateTime created;

  Playlist({
    required this.id,
    required this.userId,
    required this.name,
    required this.songs,
    required this.created,
  });

  factory Playlist.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;

    return Playlist(
      id: documentSnapshot.id,
      userId: data['userId'] as String,
      name: data['name'] as String,
      songs: (data['songs'] as List).map((song) => Song.fromJson(song)).toList(),
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
      'songs': songsJson,
      'created': created,
    };
  }
}
