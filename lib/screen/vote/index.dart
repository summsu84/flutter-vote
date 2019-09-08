import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vote/models/comment.dart';
import 'package:flutter_vote/models/user.dart';
import 'package:flutter_vote/models/vote.dart';
import 'package:flutter_vote/repository/repository.dart';
import 'package:flutter_vote/screen/comment/index.dart';
import 'package:flutter_vote/service/FireStoreHelper.dart';


/// 투표 화면
class VoteScreen extends StatefulWidget {

  final DocumentSnapshot documentSnapshot;
  final VoteInfo voteInfo;
  //생성자
  const VoteScreen({this.voteInfo, this.documentSnapshot});

  @override
  _VoteScreen createState() {
    return _VoteScreen(voteInfo: this.voteInfo, documentSnapshot: this.documentSnapshot);
  }
}

// Vote 정보를 DB로 부터 가져온다.
class _VoteScreen extends State<VoteScreen> {
  StreamSubscription<DocumentSnapshot> subscription;
  final Repository _repository = Repository();
  final DocumentSnapshot documentSnapshot;
  // backing data
  List<Comment> comments = [];
  VoteInfo voteInfo;
  int voteLike = 0;
  int voteDisLike = 0;

  _VoteScreen({this.voteInfo, this.documentSnapshot});

  // 초기화 함수
  @override
  void initState() {
    //커멘트 가져오기
    /// 아래는 기존 방법

    _repository.fetchCommentByTimestamp(this.voteInfo.id)
    .then((commentResult) {
      /// callback 함수
      /// 조회 개수 정보를가져온다.
      List<DocumentSnapshot> list = commentResult;
      for (var doc in list) {
        comments.add(Comment.fromDocument(doc));
      }
      /// 조회 개수 정보 검색
      _repository
          .fetchPostLikeAndDisLikeByBoteId(this.voteInfo.id)
          .then((result) {
        setState(() {
          Map map = result;
          voteLike = map['like'].length.toInt();
          voteDisLike = map['dislike'].length.toInt();
          print('like: ' +
              voteLike.toString() +
              ' unlike : ' +
              voteDisLike.toString());
        });
      });
    });
    super.initState();

  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: new AppBar(
              automaticallyImplyLeading: true,
              //`true` if you want Flutter to automatically add Back Button when needed,
              //or `false` if you want to force your own back button every where
              title: new Text(this.voteInfo.title),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context, false),
              )),
          body: buildVoteScreen(),
          bottomNavigationBar: buildVoteBottomNavigationBar(),

        ));
  }

  ///Floating
  ///floatingActionButton: FloatingActionButton(
  //            onPressed: () {
  //              //Navigator.of(context).pushNamed('/Comment');
  //
  //              Navigator.of(context).push(
  //                  MaterialPageRoute<bool>(builder: (BuildContext context) {
  //                return CommentScreen(
  //                  voteId: voteInfo.id,
  //                );
  //              }));
  //            },
  //            tooltip: 'Comment Show',
  //            child: Icon(Icons.comment),
  //          ), //


  // 투표 화면 생성
  buildVoteScreen() {
    return new Center(
        child: new Container(
      child: new Column(
        children: <Widget>[
          VoteTitleWidget(
            voteInfo: voteInfo,
          ),
          _buildButtons(),
          Divider(),
          Expanded(
            child: buildListView(),
          )

        ],
      ),
    ));
  }
// SizedBox(height: 300, child: buildListView()),
  // 리스트 뷰
  buildListView() {
    if (comments != null) {
      return Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              padding: EdgeInsets.all(5.0),
              itemBuilder: (context, i) {
                return buildListTile2(comments.elementAt(i));
              },
            ),
          ),
          Divider(),
          ListTile(
            trailing: OutlineButton(
              onPressed: () {
                Navigator.of(context).push(
                                      MaterialPageRoute<bool>(builder: (BuildContext context) {
                                    return CommentScreen(
                                      voteId: voteInfo.id,
                                    );
                                  }));
              },
              borderSide: BorderSide.none,
              child: Text("댓글 더보기 >"),
            ),
          ),
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
          title: Text(item.userId + " 4분전"),
          subtitle: Column(children: <Widget>[
            Text(item.comment),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Icon(Icons.thumb_up),
              Icon(Icons.thumb_down),
            ]),
          ]),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(item.avatar),
          ),
          trailing: Icon(Icons.more_vert),
          isThreeLine: true,
        ),
        Divider(),
      ],
    );
  }

  /// 댓글 레이아웃
  /// 1. 아바타
  /// 2. 댓글 정보
  buildListTile2(Comment item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        height: 120,
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

  /// 커맨트 설명 정보
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
                  fontSize: 13.0,
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
              /*Text(
                '2일전 ★',
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black54,
                ),
              ),*/
            ],
          ),
        ),
      ],
    );
  }

  // 투표 하단 바 생성
  buildVoteBottomNavigationBar() {
    return new Container(
      color: Colors.white,
      height: 50.0,
      alignment: Alignment.center,
      child: new BottomAppBar(
        child: new Row(
          // alignment: MainAxisAlignment.spaceAround,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new IconButton(
              icon: Icon(
                Icons.home,
              ),
              onPressed: () {},
            ),
            new IconButton(
              icon: Icon(
                Icons.search,
              ),
              onPressed: null,
            ),
            new IconButton(
              icon: Icon(
                Icons.add_box,
              ),
              onPressed: null,
            ),
            new IconButton(
              icon: Icon(
                Icons.favorite,
              ),
              onPressed: null,
            ),
            new IconButton(
              icon: Icon(
                Icons.account_box,
              ),
              onPressed: null,
            ),
          ],
        ),
      ),
    );
  }

  // This is the animated row with the Card.
  Widget _buildItem(Comment item, Animation animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        child: ListTile(
          title: Text(
            item.comment,
            style: TextStyle(fontSize: 20),
          ),
          leading: CircleAvatar(
            //backgroundImage: NetworkImage(item.avatar),
            backgroundImage: NetworkImage(
                'https://www.caralyns.com/wp-content/uploads/2014/10/sample-avatar.png'),
          ),
        ),
      ),
    );
  }

  //투표 빌드 항목 설정
  Widget _buildButtons() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonColumn(Icons.thumb_up, voteLike, '찬성'),
          _buildButtonColumn(Icons.thumb_down, voteDisLike, '반대'),
        ],
      ),
    );
  }

  Column _buildButtonColumn(IconData icon, int number, String label) {
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            print("Icon Clicked..");
            //
            if (label == '찬성') {
              postLikeByVoteId(voteInfo.id, currentUser);
              //repository.postLikeByVoteId(voteInfo.id, currentUser);
            } else {
              postDisLikeByVoteId(voteInfo.id, currentUser);
            }
            //.fetchPostLikes(widget.documentSnapshot.reference),
          },
          child: Icon(icon),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            number.toString(),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        /*Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),*/
      ],
    );
  }

  /// 투표 버튼을 클릭 한다.
  Future<void> postLikeByVoteId(String id, User currentUser) async {
    // 체크 하기
    print('postLikeByBoteId start');
    bool isChecked = await _repository.checkIfUserLikedOrNotByVoteId(
        voteInfo.id, currentUser);
    print('isChecked : ' + isChecked.toString());
    if (isChecked) {
      //체크가 된 상태이면, 체크를 해제 한다.
      print('post unliking..');
      await _repository.postUnlikeByVoteId(voteInfo.id, currentUser);
      print('post unliking..finnish');
      _repository
          .fetchPostLikeAndDisLikeByBoteId(this.voteInfo.id)
          .then((result) {
        setState(() {
          Map map = result;
          voteLike = map['like'].length.toInt();
          //voteDisLike = map['dislike'].length.toInt();
        });
      });
    } else {
      print('post liking..');
      await _repository.postLikeByVoteId(voteInfo.id, currentUser);
      print('post liking..finnish');
      _repository
          .fetchPostLikeAndDisLikeByBoteId(this.voteInfo.id)
          .then((result) {
        setState(() {
          Map map = result;
          voteLike = map['like'].length.toInt();
          //voteDisLike = map['dislike'].length.toInt();
        });
      });
    }
  }

  /// 투표 안좋아요 버튼을 클릭 한다.

  Future<void> postDisLikeByVoteId(String id, User currentUser) async {
    // 체크 하기
    print('postLikeByBoteId start');
    bool isChecked = await _repository.checkIfUserLikedOrNotByVoteId(
        voteInfo.id, currentUser);
    print('isChecked : ' + isChecked.toString());
    if (isChecked) {
      //체크가 된 상태이면, 체크를 해제 한다.
      print('post unliking..');
      await _repository.postUnlikeByVoteId(voteInfo.id, currentUser);
      print('post unliking..finnish');
      _repository
          .fetchPostLikeAndDisLikeByBoteId(this.voteInfo.id)
          .then((result) {
        setState(() {
          Map map = result;
          //voteLike = map['like'].length.toInt();
          voteDisLike = map['dislike'].length.toInt();
        });
      });
    } else {
      print('post liking..');
      await _repository.postLikeByVoteId(voteInfo.id, currentUser);
      print('post liking..finnish');
      _repository
          .fetchPostLikeAndDisLikeByBoteId(this.voteInfo.id)
          .then((result) {
        setState(() {
          Map map = result;
          //voteLike = map['like'].length.toInt();
          voteDisLike = map['dislike'].length.toInt();
        });
      });
    }
  }
}


/// 투표 화면 정보
class VoteTitleWidget extends StatelessWidget {
  VoteInfo voteInfo;

  VoteTitleWidget({this.voteInfo}) {
    print('VoteTitleConstructor');
  }

  /// 빌더 함수
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        padding: const EdgeInsets.all(32),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      voteInfo.desc,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

/// 투표 버튼 클래스
class VotebButtonWidget extends StatelessWidget {
  final VoteInfo voteInfo;
  final Repository repository;
  final int voteLike;
  final int voteDisLike;

  const VotebButtonWidget(
      {this.voteInfo, this.repository, this.voteLike, this.voteDisLike});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonColumn(Icons.thumb_up, voteLike, '찬성'),
          _buildButtonColumn(Icons.thumb_down, voteDisLike, '반대'),
        ],
      ),
    );
  }

  Column _buildButtonColumn(IconData icon, int number, String label) {
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            print("Icon Clicked..");
            //
            if (label == '찬성') {
              //postLikeByVoteId(voteInfo.id, currentUser);
              //repository.postLikeByVoteId(voteInfo.id, currentUser);
            } else {
              repository.postDisLikeByVoteId(voteInfo.id, currentUser);
            }
            //.fetchPostLikes(widget.documentSnapshot.reference),
          },
          child: Icon(icon),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            number.toString(),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        /*Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),*/
      ],
    );
  }
}

/*class VoteNextButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        const RaisedButton(
          onPressed: null,
          child: Text('다음 투표로 가기', style: TextStyle(fontSize: 20)),
        ),
      ]),
    );
  }
}*/
