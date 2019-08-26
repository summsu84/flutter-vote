import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_vote/models/comment.dart';
import 'package:flutter_vote/models/user.dart';
import 'package:flutter_vote/models/vote.dart';

class FirebaseProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  User user;
  VoteInfo voteInfo;
  Comment comment;

/*  final GoogleSignIn _googleSignIn = GoogleSignIn();
  StorageReference _storageReference;*/

  Future<void> addComment(User currentUser, String voteId, String text) {
    //Collection 가져오기
    CollectionReference _collectionRef = _firestore
        .collection("vote_comment")
        .document(voteId)
        .collection("comment");

 /*   comment = Comment(
        currentUserUid: currentUser.uid,
        imgUrl: imgUrl,
        caption: caption,
        location: location,
        postOwnerName: currentUser.displayName,
        postOwnerPhotoUrl: currentUser.photoUrl,
        time: FieldValue.serverTimestamp());*/
    comment = Comment(
        userUid: currentUser.uid,
        avatar: currentUser.photoUrl,
        comment: text,
        userName: currentUser.username,
        userId: currentUser.id
    );

    var map = comment.toMap(comment);

    return _collectionRef.add(map);
  }


  Future<List<DocumentSnapshot>> fetchComment(String voteId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection("vote_comment")
        .document(voteId)
        .collection("comment")
        .getDocuments();
    return querySnapshot.documents;
  }
}
