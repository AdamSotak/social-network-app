import 'package:cloud_firestore/cloud_firestore.dart';

class Song {
  String id;
  String userId;
  String contentURL;
  int likes;
  DateTime created;

  Song({
    required this.id,
    required this.userId,
    required this.contentURL,
    required this.likes,
    required this.created,
  });

  factory Song.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;

    return Song(
      id: documentSnapshot.id,
      userId: data['userId'] as String,
      contentURL: data['contentURL'] as String,
      likes: data['likes'] as int,
      created: DateTime.fromMillisecondsSinceEpoch(data['created'].seconds * 1000),
    );
  }

  Song.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userId = json['userId'],
        contentURL = json['contentURL'],
        likes = json['likes'],
        created = DateTime.fromMillisecondsSinceEpoch(json['created'].seconds * 1000);

  Map<String, dynamic> toJson() {
    return {'id': id, 'userId': userId, 'contentURL': contentURL, 'likes': likes, 'created': created};
  }
}
