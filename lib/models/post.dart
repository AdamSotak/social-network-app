import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String id;
  String userId;
  String description;
  String contentURL;
  int likes;
  bool video;
  List<String> hashtags;
  DateTime created;

  Post(
      {required this.id,
      required this.userId,
      required this.description,
      required this.contentURL,
      required this.likes,
      required this.video,
      required this.hashtags,
      required this.created});

  factory Post.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;

    return Post(
        id: documentSnapshot.id,
        userId: data['userId'] as String,
        description: data['description'] as String,
        contentURL: data['contentURL'] as String,
        likes: data['likes'] as int,
        video: data['video'] == true,
        hashtags: (data['hashtags'] as List).map((hashtag) => hashtag.toString()).toList(),
        created: DateTime.fromMillisecondsSinceEpoch(data['created'].seconds * 1000));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'description': description,
      'contentURL': contentURL,
      'likes': likes,
      'video': video,
      'hashtags': hashtags,
      'created': created
    };
  }
}
