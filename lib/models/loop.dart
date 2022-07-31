import 'package:cloud_firestore/cloud_firestore.dart';

class Loop {
  String id;
  String userId;
  String name;
  String description;
  String contentURL;
  int likes;
  DateTime created;

  Loop({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.contentURL,
    required this.likes,
    required this.created,
  });

  factory Loop.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;

    return Loop(
      id: documentSnapshot.id,
      userId: data['userId'] as String,
      name: data['name'] as String,
      description: data['description'] as String,
      contentURL: data['contentURL'] as String,
      likes: data['likes'] as int,
      created: DateTime.fromMillisecondsSinceEpoch(data['created'].seconds * 1000),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'description': description,
      'contentURL': contentURL,
      'likes': likes,
      'created': created,
    };
  }
}
