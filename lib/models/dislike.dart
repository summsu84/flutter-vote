import 'package:cloud_firestore/cloud_firestore.dart';

class DisLike {

  String ownerName;
  String ownerPhotoUrl;
  String ownerUid;
  FieldValue timeStamp;

  DisLike({this.ownerName, this.ownerPhotoUrl, this.ownerUid, this.timeStamp});

  Map toMap(DisLike like) {
    var data = Map<String, dynamic>();
    data['ownerName'] = like.ownerName;
    data['ownerPhotoUrl'] = like.ownerPhotoUrl;
    data['ownerUid'] = like.ownerUid;
    data['timestamp'] = like.timeStamp.toString();
    return data;
  }

  DisLike.fromMap(Map<String, dynamic> mapData) {
    this.ownerName = mapData['ownerName'];
    this.ownerPhotoUrl = mapData['ownerPhotoUrl'];
    this.ownerUid = mapData['ownerUid'];
    this.timeStamp = mapData['timestamp'];
  }

}