import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String userName;
  final String userId;
  final String avatar;
  final String comment;
  final String timestamp;

  Comment(
      {this.userName,
        this.userId,
        this.avatar,
        this.comment,
        this.timestamp});

  factory Comment.fromDocument(DocumentSnapshot document) {
    return Comment(
      userName: document['userName'],
      userId: document['userId'],
      avatar: document['avatar'],
      comment: document['comment'],
      timestamp: document['timestamp'],
    );
  }
}