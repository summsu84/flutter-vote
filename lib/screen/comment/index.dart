import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_vote/models/comment.dart';
import 'package:flutter_vote/models/user.dart';
import "dart:async";

import 'package:flutter_vote/repository/repository.dart';

/// 댓글 화면
/// 1. 추가작업 내용
/// - 페이징 기법
/// - 댓글 등록 후 리프레쉬 기능
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
  final isTextEdit = false;

  _CommentScreenState({this.voteId});

  @override
  void dispose() {
    super.dispose();
    _commentController?.dispose();
  }

  ///빌드 시작 지점
  ///1. FutureBuilder 사용
  Widget build(BuildContext context) {
    var futureBuilder = new FutureBuilder(
      future: _getVoteComments(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new Text('댓글 가져오는 중...');
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return buildPage(context, snapshot);

          /// buildPage 호출
        }
      },
    );
    return new Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          //`true` if you want Flutter to automatically add Back Button when needed,
          //or `false` if you want to force your own back button every where
          title: Text(
            "댓글보기",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          )),
      body: futureBuilder,
    );
  }

  //FutureBuilder로 가져오기
  // 리스트 뷰
  buildListView(BuildContext context, AsyncSnapshot snapshot) {
    List<DocumentSnapshot> values = snapshot.data;
    if (values != null) {
      return Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: values.length,
              padding: EdgeInsets.all(5.0),
              itemBuilder: (context, i) {
                return buildListTile2(Comment.fromDocument(values[i]));
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

  buildListTile2(Comment item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        height: 130,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(item.avatar),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                child: buildDescription(item),
              ),
            )
          ],
        ),
      ),
    );
  }

  buildDescription(Comment item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                item.userId,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 2.0)),
              Text(
                item.comment,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('2일전 ★',
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.black54,
                          )),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      new Icon(Icons.thumb_up, color: Colors.grey, size: 18),
                      Text('100',
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.black54,
                          )),
                      new SizedBox(
                        width: 16.0,
                      ),
                      new Icon(Icons.thumb_down, color: Colors.grey, size: 18),
                      Text('100',
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.black54,
                          )),
                      new SizedBox(
                        width: 16.0,
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  ///투표에 대한 댓글 정보를 가져온다.
  /// Future async -> Future async 로 가져가야 할지?? 테스트 필요
  Future<List<DocumentSnapshot>> _getVoteComments() async {
    //콜백 처리
    var voteDocuments = await _repository.fetchComment(this.voteId);
    print(voteDocuments.length);
    return voteDocuments;
  }

  /// Future를 통해서, 댓글 정보를 가져오게 되면, 해당 위젯을 호출 한다.
  Widget buildPage(BuildContext context, AsyncSnapshot snapshot) {
    return Column(
      children: [
        // 화면 채우기
        Expanded(
          child: buildListView(context, snapshot),
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

  buildListTile(Comment item) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Column(
            children: <Widget>[Text("테스트"), Text(item.comment)],
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
  }
}
