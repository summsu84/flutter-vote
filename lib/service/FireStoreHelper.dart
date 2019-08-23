
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreHelper {

  bool isLoggedIn() {
    if(FirebaseAuth.instance.currentUser() != null){
      return true;
    }else{
      return false;
    }
  }

  // 댓글 등록
  Future<void> addComment(comment) async {
    if(isLoggedIn()){
      Firestore.instance.collection('vote_comment').document('id').collection('comment').add(comment).catchError((e){
        print(e);
      });
    }else
      {
        print('Need to be logged in');
      }
  }

  // 베스트 5개 댓글 가져오기
  getComment(voteId) async {
    print('vote id : ' + voteId);
    return await Firestore.instance.collection('vote_comment').document(voteId).collection('comment').getDocuments();
  }

  // 투표 정보 등록
  Future<void> addVoteInfo(voteInfo) async {
    if(isLoggedIn()){
      Firestore.instance.collection('vote_info').add(voteInfo).catchError((e){
        print(e);
      });
    }else
    {
      print('Need to be logged in');
    }
  }

  // 투표 정보 Fetch
  getVoteInfo() async {
    return await Firestore.instance.collection('vote_info').getDocuments();
  }

}