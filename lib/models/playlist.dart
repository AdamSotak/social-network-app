import 'package:cloud_firestore/cloud_firestore.dart';

class Playlist {
  String id;
  String userId;
  String name;
  List<String> songs;
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
      songs: (data['songs'] as List).map((song) => song.toString()).toList(),
      created: DateTime.fromMillisecondsSinceEpoch(data['created'].seconds * 1000),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'songs': songs,
      'created': created,
    };
  }
}
