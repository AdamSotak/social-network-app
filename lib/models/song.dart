import 'package:cloud_firestore/cloud_firestore.dart';

class Song {
  String id;
  String userId;
  String name;
  String artworkURL;
  String contentURL;
  int likes;
  List<String> hashtags;
  DateTime created;

  Song({
    required this.id,
    required this.userId,
    required this.name,
    required this.artworkURL,
    required this.contentURL,
    required this.likes,
    required this.hashtags,
    required this.created,
  });

  factory Song.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;

    return Song(
      id: documentSnapshot.id,
      userId: data['userId'] as String,
      name: data['name'] as String,
      artworkURL: data['artworkURL'] as String,
      contentURL: data['contentURL'] as String,
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
      'contentURL': contentURL,
      'likes': likes,
      'hashtags': hashtags,
      'created': created,
    };
  }
}
