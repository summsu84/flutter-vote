import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vote/models/comment.dart';
import 'package:flutter_vote/models/vote.dart';
import 'package:flutter_vote/screen/comment/index.dart';
import 'package:flutter_vote/service/FireStoreHelper.dart';

class VoteScreen extends StatefulWidget {
  //final ScreenArguments args = ModalRoute.of(context).settings.arguments;
  final String voteId;
  final VoteInfo voteInfo;

  const VoteScreen({this.voteId, this.voteInfo});

  @override
  _VoteScreen createState() {
    return _VoteScreen(voteId: this.voteId, voteInfo: this.voteInfo);
  }
}
// Vote 정보를 DB로 부터 가져온다.

class _VoteScreen extends State<VoteScreen> {
  String myText = '';
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  StreamSubscription<DocumentSnapshot> subscription;
  final FireStoreHelper fireStoreHelper = new FireStoreHelper();
  QuerySnapshot voteSnapshot;

  // backing data
  List<Comment> comments = [];
  List<VoteInfo> voteInfos = [];

  final String voteId;
  final VoteInfo voteInfo;

  _VoteScreen({this.voteId, this.voteInfo});

  // 초기화 함수
  @override
  void initState() {
    /*fireStoreHelper.getVoteInfo().then((results) {
      setState(() {
        voteSnapshot = results;
        for (var doc in voteSnapshot.documents) {
          voteInfos.add(VoteInfo.fromDocument(doc));
        }
        //커멘트 가져오기
        fireStoreHelper
            .getComment(voteInfos.elementAt(0).id)
            .then((commentResults) {
          setState(() {
            voteSnapshot = commentResults;
            for (var doc in voteSnapshot.documents) {
              comments.add(Comment.fromDocument(doc));
            }
          });
        });
      });
    });*/

    //커멘트 가져오기
    print("voteId : " + voteId);
    fireStoreHelper.getComment(voteId).then((commentResults) {
      setState(() {
        voteSnapshot = commentResults;
        for (var doc in voteSnapshot.documents) {
          comments.add(Comment.fromDocument(doc));
        }
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
          appBar: new AppBar(title: new Text('투표앱')),
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
          VotebButtonWidget(),
          VoteNextButton(),
          SizedBox(
              height: 300,
              child:
                  buildListView() /*AnimatedList(
              // Give the Animated list the global key
              key: _listKey,
              initialItemCount: comments.length,
              // Similar to ListView itemBuilder, but AnimatedList has
              // an additional animation parameter.
              itemBuilder: (context, index, animation) {
                // Breaking the row widget out as a method so that we can
                // share it with the _removeSingleItem() method.
                //print("index : " + index.toString());
                return _buildItem(comments[index], animation);
              },
            ),*/
              ),
        ],
      ),
    ));
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
                return buildListTile(comments.elementAt(i));
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
          title: Text(item.comment),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(item.avatar),
          ),
        ),
        Divider(),
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
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
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
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonColumn(Icons.call, '찬성'),
          _buildButtonColumn(Icons.near_me, '반대'),
        ],
      ),
    );
  }

  Column _buildButtonColumn(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
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
