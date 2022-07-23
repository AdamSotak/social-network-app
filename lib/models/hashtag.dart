import 'package:cloud_firestore/cloud_firestore.dart';

class Hashtag {
  String id;
  String name;
  int postCount;
  DateTime created;

  Hashtag({
    required this.id,
    required this.name,
    required this.postCount,
    required this.created,
  });

  factory Hashtag.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;

    return Hashtag(
      id: documentSnapshot.id,
      name: data['name'] as String,
      postCount: data['postCount'] as int,
      created: DateTime.fromMillisecondsSinceEpoch(data['created'].seconds * 1000),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'postCount': postCount,
      'created': created,
    };
  }
}
