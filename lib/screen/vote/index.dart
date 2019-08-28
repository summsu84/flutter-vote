import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vote/models/comment.dart';
import 'package:flutter_vote/models/user.dart';
import 'package:flutter_vote/models/vote.dart';
import 'package:flutter_vote/repository/repository.dart';
import 'package:flutter_vote/screen/comment/index.dart';
import 'package:flutter_vote/service/FireStoreHelper.dart';

/**
 *  투표 화면 위젯
 */
class VoteScreen extends StatefulWidget {
  //final ScreenArguments args = ModalRoute.of(context).settings.arguments;
  final VoteInfo voteInfo;

  //생성자
  const VoteScreen({this.voteInfo});

  @override
  _VoteScreen createState() {
    return _VoteScreen(voteInfo: this.voteInfo);
  }
}

// Vote 정보를 DB로 부터 가져온다.
class _VoteScreen extends State<VoteScreen> {
  StreamSubscription<DocumentSnapshot> subscription;
  final FireStoreHelper fireStoreHelper = new FireStoreHelper();
  final Repository _repository = Repository();

  QuerySnapshot voteSnapshot;

  // backing data
  List<Comment> comments = [];
  VoteInfo voteInfo;
  int voteLike = 0;

  _VoteScreen({this.voteInfo});

  // 초기화 함수
  @override
  void initState() {
    //커멘트 가져오기
    fireStoreHelper.getComment(this.voteInfo).then((commentResults) {
      setState(() {
        voteSnapshot = commentResults;
        for (var doc in voteSnapshot.documents) {
          comments.add(Comment.fromDocument(doc));
        }
        // Coute 가져오기
        _repository.fetchPostLikesByVoteId(this.voteInfo.id).then((result){
          setState((){
            voteLike = result.length.toInt();
          });
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
          appBar: new AppBar(title: new Text(this.voteInfo.title)),
          body: buildVoteScreen(),
          bottomNavigationBar: buildVoteBottomNavigationBar(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              //Navigator.of(context).pushNamed('/Comment');
              Navigator.of(context).push(
                  MaterialPageRoute<bool>(builder: (BuildContext context) {
                return CommentScreen(
                  voteId: voteInfo.id,
                );
              }));
            },
            tooltip: 'Comment Show',
            child: Icon(Icons.comment),
          ), //
        ));
  }

  // 투표 화면 생성
  buildVoteScreen() {
    return new Center(
        child: new Container(
      child: new Column(
        children: <Widget>[
          VoteTitleWidget(
            voteInfo: voteInfo,
          ),
          VotebButtonWidget(
            voteInfo: voteInfo,
            repository: _repository,
            voteLike: voteLike,
          ),
          VoteNextButton(),
          SizedBox(height: 300, child: buildListView()),
        ],
      ),
    ));
  }

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
}

class ScreenArguments {
  final String voteId;
  final String message;

  ScreenArguments(this.voteId, this.message);
}

//Title Section
class VoteTitleWidget extends StatelessWidget {
  VoteInfo voteInfo;

  VoteTitleWidget({this.voteInfo}) {
    print('VoteTitleConstructor');
  }

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
            /*3*/
            Icon(
              Icons.star,
              color: Colors.red[500],
            ),
            Text('41'),
          ],
        ));
  }
}

// Button Widget
class VotebButtonWidget extends StatelessWidget {
  final VoteInfo voteInfo;
  final Repository repository;
  final int voteLike;

  const VotebButtonWidget({this.voteInfo, this.repository, this.voteLike});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonColumn(Icons.thumb_up, voteLike, '찬성'),
          _buildButtonColumn(Icons.thumb_down, voteInfo.dislike, '반대'),
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
              repository.postLikeByVoteId(voteInfo.id, currentUser);
            } else {}
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

class VoteNextButton extends StatelessWidget {
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
}
