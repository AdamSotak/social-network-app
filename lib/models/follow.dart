import 'package:cloud_firestore/cloud_firestore.dart';

class Follow {
  String id;
  String userId;
  String toUserId;
  DateTime created;

  Follow({
    required this.id,
    required this.userId,
    required this.toUserId,
    required this.created,
  });

  factory Follow.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;

    return Follow(
      id: data['id'] as String,
      userId: data['userId'] as String,
      toUserId: data['toUserId'] as String,
      created: DateTime.fromMillisecondsSinceEpoch(data['created'].seconds * 1000),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'toUserId': toUserId,
      'created': created,
    };
  }
}
