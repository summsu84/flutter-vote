import 'package:cloud_firestore/cloud_firestore.dart';

///커멘트 모델
///1. 사용자 이름
///2. 사용자 아이디
///3. 아바타 정보
///4. 댓글 정보
///5. 사용자 Uid
class Comment {
  final String id;
  final String userName;
  final String userId;
  final String avatar;
  final String comment;
  final String timestamp;
  final String userUid;
  List like;
  List dislike;

  Comment(
      {this.userName,
        this.userId,
        this.avatar,
        this.comment,
        this.timestamp,
        this.userUid,
        this.like,
        this.dislike,
        this.id
      });

  Map toMap(Comment comment) {
    var data = Map<String, dynamic>();
    data['userName'] = comment.userName;
    data['userId'] = comment.userId;
    data['avatar'] = comment.avatar;
    data['comment'] = comment.comment;
    data['timestamp'] = comment.timestamp;
    data['userUid'] = comment.userUid;
    data['like'] = comment.like;
    data['dislike'] = comment.dislike;
    data['id'] = comment.id;
    return data;
  }


  factory Comment.fromDocument(DocumentSnapshot document) {
    return Comment(
        id: document.documentID,
      userName: document['userName'],
      userId: document['userId'],
      avatar: document['avatar'],
      comment: document['comment'],
      timestamp: document['timestamp'],
      userUid: document['userUid'],
      like: document['like'],
      dislike: document['dislike']
    );
  }
}