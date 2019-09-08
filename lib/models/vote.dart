
//VoteInfoModel
import 'package:cloud_firestore/cloud_firestore.dart';

///투표 정보
///1. 투표ID
///2. 투표 타이틀
///3. 투표 설명
///4. 이미지 정보
///5. 노출 여부
///6. 게시 기간
///7. 조회수
class VoteInfo {
  final String id;
  final String title;
  final String desc;
  final int like;
  final int dislike;
  final int voteNumber;
  final int voteComments;
  final String imageUrl;

  VoteInfo(
      {
        this.id,
        this.title,
        this.desc,
        this.like,
        this.dislike,
        this.voteNumber,
        this.voteComments,
        this.imageUrl
      });

  factory VoteInfo.fromDocument(DocumentSnapshot document) {


    return VoteInfo(
        id: document.documentID,
        title: document['title'],
        desc: document['desc'],
        like: document['like'],
        dislike: document['dislike'],
        voteNumber: document['voteNumber'],
        voteComments: document['voteComments'],
        imageUrl: document['imageUrl']
    );
  }
}