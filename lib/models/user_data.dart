import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String id;
  String username;
  String displayName;
  String profilePhotoURL;
  int followers;
  int following;

  UserData({
    required this.id,
    required this.username,
    required this.displayName,
    required this.profilePhotoURL,
    required this.followers,
    required this.following,
  });

  factory UserData.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;

    return UserData(
      id: documentSnapshot.id,
      username: data['username'] as String,
      displayName: data['displayName'] as String,
      profilePhotoURL: data['profilePhotoURL'] as String,
      followers: data['followers'] as int,
      following: data['following'] as int,
    );
  }

  UserData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        username = json['username'],
        displayName = json['displayName'],
        profilePhotoURL = json['profilePhotoURL'],
        followers = json['followers'],
        following = json['following'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'displayName': displayName,
      'profilePhotoURL': profilePhotoURL,
      'followers': followers,
      'following': following
    };
  }
}
