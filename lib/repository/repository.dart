import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_vote/models/user.dart';
import 'package:flutter_vote/models/vote.dart';

import 'firebaseProvider.dart';

class Repository {

  final _firebaseProvider = FirebaseProvider();


  /*Future<void> addDataToDb(FirebaseUser user) => _firebaseProvider.addDataToDb(user);

  //투표 리스트 가져오기
  Future<FirebaseUser> signIn() => _firebaseProvider.signIn();

  // 투표 상세 정보 가져오기
  Future<bool> authenticateUser(FirebaseUser user) => _firebaseProvider.authenticateUser(user);

  // 투표 수정 하기
  // 투표 삭제 하기
  Future<FirebaseUser> getCurrentUser() => _firebaseProvider.getCurrentUser();


  // 댓글 가져오기
  Future<void> signOut() => _firebaseProvider.signOut();

  Future<User> retrieveUserDetails(FirebaseUser user) => _firebaseProvider.retrieveUserDetails(user);

  //투표 등록
  Future<void> addPostToDb(User currentUser, VoteInfo voteInfo) => _firebaseProvider.addPostToDb(currentUser, imgUrl, caption, location);
  // 투표 리스트 가져오기
  Future<List<DocumentSnapshot>> retrievePosts() => _firebaseProvider.retrievePosts(user);

  // 댓글 리스트 가져오기
  Future<List<DocumentSnapshot>> retrievePosts() => _firebaseProvider.retrievePosts(user);



  Future<String> uploadImageToStorage(File imageFile) => _firebaseProvider.uploadImageToStorage(imageFile);*/

  //투 표 등록
  Future<void> addComment(User currentUser, String voteId, String text) => _firebaseProvider.addComment(currentUser, voteId, text);
  // 댓글 가져오기
  //Future<List<DocumentSnapshot>> fetchComment(String voteId) => _firebaseProvider.fetchComment(voteId);
  Future<List<DocumentSnapshot>> fetchComment(String voteId) => _firebaseProvider.fetchComment(voteId);

  // 투표 찬성하기
  Future<void> postLike(DocumentReference reference, User currentUser) => _firebaseProvider.postLike(reference, currentUser);
  Future<void> postLikeByVoteId(String voteId, User currentUser) => _firebaseProvider.postLikeByVoteId(voteId, currentUser);

  // 투표 좋아요 정보 가져오기
  Future<List<DocumentSnapshot>> fetchPostLikes(DocumentReference reference) => _firebaseProvider.fetchPostLikeDetails(reference);
  Future<List<DocumentSnapshot>> fetchPostLikesByVoteId(String voteId) => _firebaseProvider.fetchPostLikesByVoteId(voteId);



/*
  Future<List<DocumentSnapshot>> retrieveUserPosts(String userId) => _firebaseProvider.retrieveUserPosts(userId);

  Future<List<DocumentSnapshot>> fetchPostComments(DocumentReference reference) => _firebaseProvider.fetchPostCommentDetails(reference);

  Future<List<DocumentSnapshot>> fetchPostLikes(DocumentReference reference) => _firebaseProvider.fetchPostLikeDetails(reference);

  Future<bool> checkIfUserLikedOrNot(String userId, DocumentReference reference) => _firebaseProvider.checkIfUserLikedOrNot(userId, reference);*/



 /* Future<List<String>> fetchAllUserNames(FirebaseUser user) => _firebaseProvider.fetchAllUserNames(user);

  Future<String> fetchUidBySearchedName(String name) => _firebaseProvider.fetchUidBySearchedName(name);

  Future<User> fetchUserDetailsById(String uid) => _firebaseProvider.fetchUserDetailsById(uid);

  Future<void> followUser({String currentUserId, String followingUserId}) => _firebaseProvider.followUser(currentUserId: currentUserId, followingUserId: followingUserId);

  Future<void> unFollowUser({String currentUserId, String followingUserId}) => _firebaseProvider.unFollowUser(currentUserId: currentUserId, followingUserId: followingUserId);

  Future<bool> checkIsFollowing(String name, String currentUserId) => _firebaseProvider.checkIsFollowing(name, currentUserId);

  Future<List<DocumentSnapshot>> fetchStats({String uid, String label}) => _firebaseProvider.fetchStats(uid: uid, label: label);

  Future<void> updatePhoto(String photoUrl, String uid) => _firebaseProvider.updatePhoto(photoUrl, uid);

  Future<void> updateDetails(String uid, String name, String bio, String email, String phone) => _firebaseProvider.updateDetails(uid, name, bio, email, phone);

  Future<List<String>> fetchUserNames(FirebaseUser user) => _firebaseProvider.fetchUserNames(user);

  Future<List<User>> fetchAllUsers(FirebaseUser user) => _firebaseProvider.fetchAllUsers(user);

  void uploadImageMsgToDb(String url, String receiverUid, String senderuid) => _firebaseProvider.uploadImageMsgToDb(url, receiverUid, senderuid);

  Future<void> addMessageToDb(Message message, String receiverUid) => _firebaseProvider.addMessageToDb(message, receiverUid);

  Future<List<DocumentSnapshot>> fetchFeed(FirebaseUser user) => _firebaseProvider.fetchFeed(user);

  Future<List<String>> fetchFollowingUids(FirebaseUser user) => _firebaseProvider.fetchFollowingUids(user);*/

//Future<List<DocumentSnapshot>> retrievePostByUID(String uid) => _firebaseProvider.retrievePostByUID(uid);

}