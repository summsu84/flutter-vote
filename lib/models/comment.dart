import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String userName;
  final String userId;
  final String avatar;
  final String comment;
  final String timestamp;
  final String userUid;

  Comment(
      {this.userName,
        this.userId,
        this.avatar,
        this.comment,
        this.timestamp,
        this.userUid
      });

  Map toMap(Comment comment) {
    var data = Map<String, dynamic>();
    data['userName'] = comment.userName;
    data['userId'] = comment.userId;
    data['avatar'] = comment.avatar;
    data['comment'] = comment.comment;
    data['timestamp'] = comment.timestamp;
    data['userUid'] = comment.userUid;
    return data;
  }


  factory Comment.fromDocument(DocumentSnapshot document) {
    return Comment(
      userName: document['userName'],
      userId: document['userId'],
      avatar: document['avatar'],
      comment: document['comment'],
      timestamp: document['timestamp'],
      userUid: document['userUid']
    );
  }
}