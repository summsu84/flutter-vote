import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


// Vote 정보를 DB로 부터 가져온다.

class VoteScreen extends StatelessWidget {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  // backing data
  List<Comment> comments = [];

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    for (var i = 0; i < 5; i++) {
      var comment = Comment(
        userId: 'test_' + i.toString(),
        username: 'testname_' + i.toString(),
        avatarUrl:
            'https://www.caralyns.com/wp-content/uploads/2014/10/sample-avatar.png',
        comment: '난 반댈새!',
        timestamp: '99',
      );
      comments.add(comment);
    }


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
              Navigator.of(context).pushNamed('/Comment');
            },
            tooltip: 'Comment Show',
            child: Icon(Icons.comment),
          ), //
        )
        //home: MyHomePage(title: 'Vode App Demo'),
//      home: new MyVoteNestedListView(title: 'Flutter Vote App'),
        );
  }

  // 투표 화면 생성
  buildVoteScreen() {
    return new Center(
        child: new Container(
      child: new Column(
        children: <Widget>[
          VoteTitleWidget(),
          VotebButtonWidget(),
          VoteNextButton(),
          SizedBox(
            height: 300,
            child: AnimatedList(
              // Give the Animated list the global key
              key: _listKey,
              initialItemCount: comments.length,
              // Similar to ListView itemBuilder, but AnimatedList has
              // an additional animation parameter.
              itemBuilder: (context, index, animation) {
                // Breaking the row widget out as a method so that we can
                // share it with the _removeSingleItem() method.
                return _buildItem(comments[index], animation);
              },
            ),
          ),
        ],
      ),
    ));
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



  // 투표 정보를 가져온다.
  Future<List<VoteInfo>>getVoteInfo() async {
    List<VoteInfo> items = [];
    var snap = await Firestore.instance
        .collection('vote_info')
        .getDocuments();

    for (var doc in snap.documents) {
      items.add(VoteInfo(name: doc['name']));
    }
    return items;
  }

  // This is the animated row with the Card.
  Widget _buildItem(Comment item, Animation animation) {
    /*return SizeTransition(
      sizeFactor: animation,
      child: Card(
        child: ListTile(
          title: Text(
            item,
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );*/
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        child: ListTile(
          title: Text(
            item.comment,
            style: TextStyle(fontSize: 20),
          ),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(item.avatarUrl),
          ),
        ),
      ),
    );
  }
}

class VoteInfo {
  final String name;

  VoteInfo({this.name});

  factory VoteInfo.fromDocument(DocumentSnapshot document) {
    return VoteInfo(
      name: document['name'],

    );
  }
}

class Comment {
  final String username;
  final String userId;
  final String avatarUrl;
  final String comment;
  final String timestamp;

  Comment(
      {this.username,
      this.userId,
      this.avatarUrl,
      this.comment,
      this.timestamp});
}

class CommentList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(child: ListView.builder(itemBuilder: (context, index) {}));
  }
}

class MyVoteNestedListView extends StatefulWidget {
  MyVoteNestedListView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyVoteNestedListView createState() => new _MyVoteNestedListView();
}

ScrollController _controller;

class _MyVoteNestedListView extends State<MyVoteNestedListView> {
  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  Color clr = Colors.lightGreen;

  _scrollListener() {
    if (_controller.offset > _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        clr = Colors.red;
      });
    }

    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        clr = Colors.lightGreen;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: new Text('투표앱')),
      body: new Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: new Container(
          child: CustomScrollView(
            controller: _controller,
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                expandedHeight: 250.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text("핫한 20개의 댓글",
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.green,
                      )),
                  background: Column(
                    children: <Widget>[
                      VoteTitleWidget(),
                      VotebButtonWidget(),
                      VoteNextButton()
                    ],
                  ),
                ),
              ),
              SliverFixedExtentList(
                itemExtent: 50.0,
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Container(
                      alignment: Alignment.center,
                      color: Colors.lightBlue[100 * (index % 9)],
                      child: Text('댓글 $index'),
                    );
                  },
                  childCount: 20,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => null),
          );
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), //
    );
  }
}

//Title Section
class VoteTitleWidget extends StatelessWidget {
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
                      '대한민국 국민이라면 일본제품 불매운동은 찬성이다',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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

// 투표 정보를 Firestore에 등록 한다.
/*
void postToFireStore(
    {String mediaUrl, String location, String description}) async {
  var reference = Firestore.instance.collection('insta_posts');

  reference.add({
    "username": currentUserModel.username,
    "location": location,
    "likes": {},
    "mediaUrl": mediaUrl,
    "description": description,
    "ownerId": googleSignIn.currentUser.id,
    "timestamp": DateTime.now().toString(),
  }).then((DocumentReference doc) {
    String docId = doc.documentID;
    reference.document(docId).updateData({"postId": docId});
  });
}
*/
