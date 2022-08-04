import 'package:cloud_firestore/cloud_firestore.dart';

class Album {
  String id;
  String userId;
  String name;
  String artworkURL;
  List<String> songs;
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
      songs: (data['songs'] as List).map((song) => song.toString()).toList(),
      likes: data['likes'] as int,
      hashtags: (data['hashtags'] as List).map((hashtag) => hashtag.toString()).toList(),
      created: DateTime.fromMillisecondsSinceEpoch(data['created'].seconds * 1000),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'artworkURL': artworkURL,
      'songs': songs,
      'likes': likes,
      'hashtags': hashtags,
      'created': created,
    };
  }
}
