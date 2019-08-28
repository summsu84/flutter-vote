import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_vote/models/comment.dart';
import 'package:flutter_vote/models/like.dart';
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
        userId: currentUser.id);

    var map = comment.toMap(comment);

    return _collectionRef.add(map);
  }

  // Like 등록 하기
  Future<void> postLike(DocumentReference reference, User currentUser) {
    var _like = Like(
        ownerName: currentUser.displayName,
        ownerPhotoUrl: currentUser.photoUrl,
        ownerUid: currentUser.uid,
        timeStamp: FieldValue.serverTimestamp());
    reference
        .collection('likes')
        .document(currentUser.uid)
        .setData(_like.toMap(_like))
        .then((value) {
      print("Post Liked");
    });
  }

  Future<void> postLikeByVoteId(String voteId, User currentUser) {
    var _like = Like(
        ownerName: currentUser.displayName,
        ownerPhotoUrl: currentUser.photoUrl,
        ownerUid: currentUser.uid,
        timeStamp: FieldValue.serverTimestamp());

    CollectionReference _collectionRef = _firestore
        .collection("vote_info")
        .document(voteId)
        .collection('likes');
    _collectionRef
        .document(currentUser.uid)
        .setData(_like.toMap(_like))
        .then((value) {
      print("Post Liked");
    });

  }

  Future<List<DocumentSnapshot>> fetchPostLikeDetails(
      DocumentReference reference) async {
    print("REFERENCE : ${reference.path}");
    QuerySnapshot snapshot = await reference.collection("likes").getDocuments();
    return snapshot.documents;
  }

  Future<List<DocumentSnapshot>> fetchPostLikesByVoteId(
      String voteId) async {

    QuerySnapshot snapshot = await _firestore
        .collection("vote_info")
        .document(voteId)
        .collection('likes').getDocuments();
    return snapshot.documents;
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
