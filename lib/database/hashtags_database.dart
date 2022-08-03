import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_network/models/hashtag.dart';

class HashtagsDatabase {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final String hashtagsCollectionName = "hashtags";

  // Get Hashtags data Stream for loading
  Stream<QuerySnapshot> getHashtagStream() {
    return firestore.collection(hashtagsCollectionName).orderBy('postCount').limit(10).snapshots();
  }

  // Get Hashtags
  Future<List<Hashtag>> getHashtags() async {
    return await firestore.collection(hashtagsCollectionName).get().then((value) {
      return value.docs.map((hashtag) => Hashtag.fromDocumentSnapshot(hashtag)).toList();
    });
  }

  // Get Hashtag
  Future<Hashtag> getHashtag({required String hashtagName}) async {
    return await firestore.collection(hashtagsCollectionName).where('name', isEqualTo: hashtagName).get().then((value) {
      return value.docs.map((hashtag) => Hashtag.fromDocumentSnapshot(hashtag)).toList().first;
    });
  }
}
