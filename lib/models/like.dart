import 'package:cloud_firestore/cloud_firestore.dart';

class Like {
  String id;
  String userId;
  String postId;
  DateTime created;

  Like({
    required this.id,
    required this.userId,
    required this.postId,
    required this.created,
  });

  factory Like.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;

    return Like(
      id: documentSnapshot.id,
      userId: data['userId'] as String,
      postId: data['postId'] as String,
      created: DateTime.fromMillisecondsSinceEpoch(data['created'].seconds * 1000),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'postId': postId,
      'created': created,
    };
  }
}
