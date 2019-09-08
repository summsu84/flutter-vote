import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_vote/models/comment.dart';
import 'package:flutter_vote/models/like.dart';
import 'package:flutter_vote/models/user.dart';
import 'package:flutter_vote/models/vote.dart';

class FirebaseProvider {
  final String VOTE_INFO_COLLECTION = 'vote_info';
  final String VOTE_COMMENT_COLLECTION = 'vote_comment';
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

  Future<void> postLikeByVoteId(String voteId, User currentUser) async{
    var _like = Like(
        ownerName: currentUser.displayName,
        ownerPhotoUrl: currentUser.photoUrl,
        ownerUid: currentUser.uid,
        timeStamp: FieldValue.serverTimestamp());

    CollectionReference _collectionRef = await _firestore
        .collection("vote_info")
        .document(voteId)
        .collection('likes');
    _collectionRef
        .document(currentUser.uid)
        .setData(_like.toMap(_like));

    print("Post Liked");
      /*  .then((value) {
      print("Post Liked");
    });*/

  }

  /// 추천정보를 제거 한다.
  // ignore: missing_return
  Future<void> postUnlikeByVoteId(String voteId, User currentUser) {

    _firestore
        .collection("vote_info")
        .document(voteId)
        .collection('likes')
        .document(currentUser.uid)
        .delete()
        .then((value) {
      print("Post Unliked");
    });
  }

  Future<void> postDisLikeByVoteId(String voteId, User currentUser) {
    var _like = Like(
        ownerName: currentUser.displayName,
        ownerPhotoUrl: currentUser.photoUrl,
        ownerUid: currentUser.uid,
        timeStamp: FieldValue.serverTimestamp());

    CollectionReference _collectionRef = _firestore
        .collection("vote_info")
        .document(voteId)
        .collection('dislikes');
    _collectionRef
        .document(currentUser.uid)
        .setData(_like.toMap(_like))
        .then((value) {
      print("Post Liked");
    });

  }


  Future<Map<String, List<DocumentSnapshot>>> fetchPostLikeAndDisLikeByBoteId(String voteId) async {
    Map<String, List<DocumentSnapshot>> map = new Map();

    QuerySnapshot snapshot = await _firestore
        .collection("vote_info")
        .document(voteId)
        .collection('likes').getDocuments();

    map['like'] = snapshot.documents;

    QuerySnapshot snapshot2 = await _firestore
        .collection("vote_info")
        .document(voteId)
        .collection('dislikes').getDocuments();
    map['dislike'] = snapshot.documents;

    return map;
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


  Future<List<DocumentSnapshot>> fetchPostDisLikesByVoteId(
      String voteId) async {

    QuerySnapshot snapshot = await _firestore
        .collection("vote_info")
        .document(voteId)
        .collection('dislikes').getDocuments();
    return snapshot.documents;
  }


  //좋아요 체크하기
  Future<bool> checkIfUserLikedOrNot(
      User user, DocumentReference reference) async {
    DocumentSnapshot snapshot =
    await reference.collection("likes").document(user.uid).get();
    print('DOC ID : ${snapshot.reference.path}');
    return snapshot.exists;
  }

  Future<bool> checkIfUserLikedOrNotByVoteId (
      String voteId, User currentUser) async {

    DocumentSnapshot snapshot = await _firestore
        .collection("vote_info")
        .document(voteId)
        .collection('likes').document(currentUser.uid).get();

    print('DOC ID : ${snapshot.reference.path}');
    return snapshot.exists;
  }



  Future<bool> checkIfUserDisLikedOrNot(
      User user, DocumentReference reference) async {
    DocumentSnapshot snapshot =
    await reference.collection("likes").document(user.uid).get();
    print('DOC ID : ${snapshot.reference.path}');
    return snapshot.exists;
  }


  Future<List<DocumentSnapshot>> fetchComment(String voteId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection("vote_comment")
        .document(voteId)
        .collection("comment")
        .getDocuments();
    return querySnapshot.documents;
  }

  /// 타임스탬프 기반 댓글정보를 5개 가져온다.

  Future<List<DocumentSnapshot>> fetchCommentByTimestamp(String voteId) async {

    QuerySnapshot querySnapshot = await _firestore
        .collection("vote_comment")
        .document(voteId)
        .collection("comment")
        .orderBy("timestamp")
        .limit(5)
        .getDocuments();
    return querySnapshot.documents;
  }

  /// 투표 기본 정보를 가져온다.
  Future<List<DocumentSnapshot>> fetchVoteInfo() async {
    QuerySnapshot querySnapshot = await _firestore.collection('vote_info').getDocuments();

    return querySnapshot.documents;
  }

  /// 좋아요 개수로 투표 정보를 가져온다.
  Future<List<DocumentSnapshot>> fetchVoteInfoByLike() async {
    CollectionReference reference = _firestore.collection(VOTE_INFO_COLLECTION);

    QuerySnapshot querySnapshot = await _firestore.collection('vote_info').orderBy("timestamp").limit(5).getDocuments();
    // Like 개수에 따라 재정렬 한다.
/*    List<DocumentSnapshot> documentSnapshots = querySnapshot.documents;
    List<DocumentSnapshot> retDocumentSnapshots = [];
    for(DocumentSnapshot doc in documentSnapshots)
      {
        int likeCount =
      }*/

    return querySnapshot.documents;
  }

  /// 투표 정보 조회수를 증가 시킨다.
  Future<int> updateVoteViewCount(String voteId, User currentUser) async {

    var _like = Like(
        ownerName: currentUser.displayName,
        ownerPhotoUrl: currentUser.photoUrl,
        ownerUid: currentUser.uid,
        timeStamp: FieldValue.serverTimestamp());


    CollectionReference _collectionRef =  _firestore
        .collection("vote_info")
        .document(voteId)
        .collection('viewCount');
    _collectionRef
        .document()
        .setData(_like.toMap(_like));


    QuerySnapshot querySnapshot = await _collectionRef.getDocuments();

    return querySnapshot.documents.length;
  }

  /// Vote 관련 조회수 정보를 가져온다.
  Future<int> fetchVoteViewCount(DocumentReference reference) async{

    QuerySnapshot querySnapshot = await reference.collection('viewCount').getDocuments();

    return querySnapshot.documents.length;

  }

  /// Vote 관련 조회수 정보를 가져온다. (Document 베이스)
  Future<int> fetchVoteViewCountByVoteId(String voteId) async {
    DocumentSnapshot snapshot = await _firestore.collection(VOTE_INFO_COLLECTION).document(voteId).get();

    int viewNumber = VoteInfo.fromDocument(snapshot).voteNumber;

    return viewNumber;


  }

}
