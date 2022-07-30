import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String id;
  String userId;
  String postId;
  String text;
  DateTime created;

  Comment({
    required this.id,
    required this.userId,
    required this.postId,
    required this.text,
    required this.created,
  });

  factory Comment.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;

    return Comment(
      id: documentSnapshot.id,
      userId: data['userId'] as String,
      postId: data['postId'] as String,
      text: data['text'] as String,
      created: DateTime.fromMillisecondsSinceEpoch(data['created'].seconds * 1000),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'postId': postId,
      'text': text,
      'created': created,
    };
  }
}
