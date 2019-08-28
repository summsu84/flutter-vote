import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_vote/models/comment.dart';
import 'package:flutter_vote/models/user.dart';
import "dart:async";

import 'package:flutter_vote/repository/repository.dart';

// 댓글 화면
class CommentScreen extends StatefulWidget {
  final String voteId;

  const CommentScreen({this.voteId});

  // 갱신 시 _CommentScreenState 호출
  @override
  _CommentScreenState createState() => _CommentScreenState(voteId: this.voteId);
}

// 실제 위젯
class _CommentScreenState extends State<CommentScreen> {
  final String voteId;
  List<Comment> comments = [];
  List<DocumentSnapshot> documentSnapshot;
  var _repository = Repository();
  final TextEditingController _commentController = TextEditingController();

  _CommentScreenState({this.voteId});

  @override
  void initState() {
    super.initState();
    fetchComment();
  }

  // Comment 가져오기
  void fetchComment() async {
    //FirebaseUser currentUser = await _repository.getCurrentUser();

    List<DocumentSnapshot> documentSnapshot =
        await _repository.fetchComment(voteId);
    setState(() {
      this.documentSnapshot = documentSnapshot;
      for (var doc in this.documentSnapshot) {
        comments.add(Comment.fromDocument(doc));
      }
    });
    /*User user = await _repository.fetchUserDetailsById(currentUser.uid);
    setState(() {
      this.currentUser = user;
    });*/

    //_future =  _repository.fetchComment(voteId);

/*    User user = await _repository.fetchUserDetailsById(currentUser.uid);
    setState(() {
      this.currentUser = user;
    });*/
  }

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
              //buildComments(),
              buildListView(),
        ),
        Divider(),
        // 아래는 댓글 쓰기 위젯
        ListTile(
          title: TextFormField(
            controller: _commentController,
            decoration: InputDecoration(labelText: 'Write a comment...'),
            onFieldSubmitted: addComment,
          ),
          trailing: OutlineButton(
            onPressed: () {
              addComment(_commentController.text);
            },
            borderSide: BorderSide.none,
            child: Text("Post"),
          ),
        ),
      ],
    );
  }

  buildListView() {
    if (comments != null) {
      return Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              padding: EdgeInsets.all(5.0),
              itemBuilder: (context, i) {
                //return buildListTile(comments.elementAt(i));
                return commentItem(comments.elementAt(i));
              },
            ),
          ),
          Divider(),
        ],
      );
    } else {
      return Text('Loading, Please wait..');
    }
  }

  buildListTile(Comment item) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Column(
            children: <Widget>[Text("테스트"),Text(item.comment)],
          ),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(item.avatar),
          ),
        ),
        Divider(),
      ],
    );
  }

  Widget commentItem(Comment item) {
    //   var time;
    //   List<String> dateAndTime;
    //   print('${snapshot.data['timestamp'].toString()}');
    //   if (snapshot.data['timestamp'].toString() != null) {
    //       Timestamp timestamp =snapshot.data['timestamp'];
    //  // print('${timestamp.seconds}');
    //  // print('${timestamp.toDate()}');
    //    time =timestamp.toDate().toString();
    //    dateAndTime = time.split(" ");
    //   }


    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(item.avatar),
                  radius: 20,
                ),
              ),
              SizedBox(
                width: 15.0,
              ),
              Row(
                children: <Widget>[
                  Text(item.userId,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(item.comment),
                  ),
                ],
              )
            ],
          ),
          Divider(),
        ],
      ),
    );
  }

  Widget buildComments() {
    return FutureBuilder<List<CommentWidget>>(
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
  Future<List<CommentWidget>> getComments() async {
    List<CommentWidget> comments = [];

    // 파이어베이스로 부터 가져오기
    /*QuerySnapshot data = await Firestore.instance
        .collection("insta_comments")
        .document(postId)
        .collection("comments")
        .getDocuments();
    data.documents.forEach((DocumentSnapshot doc) {
      comments.add(Comment.fromDocument(doc));
    });*/
    for (var i = 0; i < 20; i++) {
      var comment = CommentWidget(
        userId: 'test_' + i.toString(),
        username: 'testname_' + i.toString(),
        avatarUrl:
            'https://www.caralyns.com/wp-content/uploads/2014/10/sample-avatar.png',
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

    //임시
    User currentUser = new User(
      username: 'tester',
      id: 'testId',
      photoUrl:
          'https://www.caralyns.com/wp-content/uploads/2014/10/sample-avatar.png',
      email: '',
      displayName: '',
      bio: '',
      uid: 'uid',
    );
    _repository.addComment(currentUser, voteId, comment);
    /*
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
    });*/
  }
}

/*
class CustomListItemTwo extends StatelessWidget {
  CustomListItemTwo({
    Key key,
    this.thumbnail,
    this.title,
    this.subtitle,
    this.author,
    this.publishDate,
    this.readDuration,
  }) : super(key: key);

  final Widget thumbnail;
  final String title;
  final String subtitle;
  final String author;
  final String publishDate;
  final String readDuration;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        height: 100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1.0,
              child: thumbnail,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                child: _ArticleDescription(
                  title: title,
                  subtitle: subtitle,
                  author: author,
                  publishDate: publishDate,
                  readDuration: readDuration,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}*/

// 댓글 위젯
class CommentWidget extends StatelessWidget {
  final String username;
  final String userId;
  final String avatarUrl;
  final String comment;
  final String timestamp;

  //생성자
  CommentWidget(
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
