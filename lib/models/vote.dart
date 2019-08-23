
//VoteInfoModel
import 'package:cloud_firestore/cloud_firestore.dart';

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