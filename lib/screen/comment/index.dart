import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "dart:async";


// 댓글 화면
class CommentScreen extends StatefulWidget {
  final String postId;
  final String postOwner;
  final String postMediaUrl;

  const CommentScreen({this.postId, this.postOwner, this.postMediaUrl});
  // 갱신 시 _CommentScreenState 호출
  @override
  _CommentScreenState createState() => _CommentScreenState(
      postId: this.postId,
      postOwner: this.postOwner,
      postMediaUrl: this.postMediaUrl);
}

// 실제 위젯
class _CommentScreenState extends State<CommentScreen> {
  final String postId;
  final String postOwner;
  final String postMediaUrl;

  final TextEditingController _commentController = TextEditingController();

  _CommentScreenState({this.postId, this.postOwner, this.postMediaUrl});

  @override
  Widget build(BuildContext context) {
    // Scaffold Layout
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "댓글보기",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: buildPage(),
    );
  }

  // 위젯 생성
  Widget buildPage() {
    return Column(
      children: [
        // 화면 채우기
        Expanded(
          child:
          buildComments(),
        ),
        Divider(),
        // 아래는 댓글 쓰기 위젯
        ListTile(
          title: TextFormField(
            controller: _commentController,
            decoration: InputDecoration(labelText: 'Write a comment...'),
            onFieldSubmitted: addComment,
          ),
          trailing: OutlineButton(onPressed: (){addComment(_commentController.text);}, borderSide: BorderSide.none, child: Text("Post"),),
        ),

      ],
    );

  }


  Widget buildComments() {
    return FutureBuilder<List<Comment>>(
        future: getComments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Container(
                alignment: FractionalOffset.center,
                child: CircularProgressIndicator());

          return ListView(
            children: snapshot.data,
          );
        });
  }


  // CommentList 가져오기
  Future<List<Comment>> getComments() async {
    List<Comment> comments = [];

    // 파이어베이스로 부터 가져오기
    /*QuerySnapshot data = await Firestore.instance
        .collection("insta_comments")
        .document(postId)
        .collection("comments")
        .getDocuments();
    data.documents.forEach((DocumentSnapshot doc) {
      comments.add(Comment.fromDocument(doc));
    });*/
    for(var i = 0 ; i < 20; i++)
      {
        var comment = Comment(
          userId: 'test_' + i.toString(),
          username: 'testname_' + i.toString(),
          avatarUrl: 'https://www.caralyns.com/wp-content/uploads/2014/10/sample-avatar.png',
          comment: '난 반댈새!',
          timestamp: '99',
        );
        comments.add(comment);
      }


    return comments;
  }

  // 댓글 등록 하기
  addComment(String comment) {

    _commentController.clear();
    Firestore.instance
        .collection("vote_comments")
        .document(postId)
        .collection("comments")
        .add({
      "username": 'tester',
      "comment": comment,
      "timestamp": DateTime.now().toString(),
      "avatarUrl": 'https://www.caralyns.com/wp-content/uploads/2014/10/sample-avatar.png',
      "userId": 'tester'
    });

    //adds to postOwner's activity feed
    Firestore.instance
        .collection("insta_a_feed")
        .document(postOwner)
        .collection("items")
        .add({
      "username": 'tester',
      "userId": 'tester',
      "type": "comment",
      "userProfileImg": 'https://www.caralyns.com/wp-content/uploads/2014/10/sample-avatar.png',
      "commentData": comment,
      "timestamp": DateTime.now().toString(),
      "postId": postId,
      "mediaUrl": postMediaUrl,
    });
  }
}

// 댓글 위젯
class Comment extends StatelessWidget {
  final String username;
  final String userId;
  final String avatarUrl;
  final String comment;
  final String timestamp;

  //생성자
  Comment(
      {this.username,
        this.userId,
        this.avatarUrl,
        this.comment,
        this.timestamp});

  /*factory Comment.fromDocument(DocumentSnapshot document) {
    return Comment(
      username: document['username'],
      userId: document['userId'],
      comment: document["comment"],
      timestamp: document["timestamp"],
      avatarUrl: document["avatarUrl"],
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(comment),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(avatarUrl),
          ),
        ),
        Divider(),
      ],
    );
  }
}