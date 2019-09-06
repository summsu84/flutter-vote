import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vote/models/vote.dart';
import 'package:flutter_vote/repository/repository.dart';
import 'package:flutter_vote/screen/vote/index.dart';
import 'package:flutter_vote/service/FireStoreHelper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//메인 화면
class VoteHomeList extends StatefulWidget {
  @override
  _VoteHomeListState createState() => _VoteHomeListState();
}

class _VoteHomeListState extends State<VoteHomeList> {
  final FireStoreHelper fireStoreHelper = new FireStoreHelper();

  //Vote 정보 스냅샷
  Future<List<DocumentSnapshot>> voteDocuments;
  final Repository _repository = Repository();

  QuerySnapshot voteSnapshot;
  List<VoteInfo> voteInfos = [];

  // 초기화 함수
  @override
  void initState() {
/*    fireStoreHelper.getVoteInfo().then((results) {
      setState(() {
        voteSnapshot = results;
        for (var doc in voteSnapshot.documents) {
          voteInfos.add(VoteInfo.fromDocument(doc));
        }
      });
    });

    super.initState();*/
    /// 초기화 후, _getVoteData를 가져온다.
    super.initState();
    print(">>>>>>init");
    voteDocuments = _getVoteData();
  }

  //FutureBuilder 사용
  @override
  Widget build(BuildContext context) {
    ///FutureBuilder 를 통해서, 데이터를 가져온뒤, builder 를 수행 한다.
    var futureBuilder = new FutureBuilder(
      future: voteDocuments,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new Text('loading...');
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return createListView(context, snapshot);
        }
      },
    );

    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Home Page"),
        ),
        body: futureBuilder);
  }

  /// 기본 투표 정보 레퍼런스를 가져온다.
  Future<List<DocumentSnapshot>> _getVoteData() {
    //콜백 처리
    Future<List<DocumentSnapshot>> _voteDocuments = _repository.fetchVoteInfo();
    return _voteDocuments;
  }

  ///리스트 뷰 생성하기
  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<DocumentSnapshot> values = snapshot.data;
    return ListView.builder(
        itemCount: values.length,
        itemBuilder: (context, index) {
          return _buildItemByFutureBuilder(values[index], values[index].reference);
        });

    /*return new ListView.builder(
        itemCount: values.length,
        itemBuilder: (BuildContext context, int index) {
          return new Column(
            children: <Widget>[
              new ListTile(
                title: new Text(values[index]),
              ),
              new Divider(height: 2.0,),
            ],
          );
        },
      );*/
  }

  Future<Map> _getVoteViewCount(
      DocumentReference reference) async {

    Map map = new Map();
    QuerySnapshot snapshot =
        await reference.collection('viewCount').getDocuments();
    map['viewCount'] = snapshot.documents.length;
    snapshot = await reference.collection('likes').getDocuments();
    map['likeCount'] = snapshot.documents.length;
    snapshot = await reference.collection('dislikes').getDocuments();
    map['dislikeCount'] = snapshot.documents.length;

    return map;
  }

  //FutureBuilder 형태의 세부 아이템 템플릿
  Widget _buildItemByFutureBuilder(DocumentSnapshot value, DocumentReference reference) {
    return FutureBuilder(
        future: _getVoteViewCount(reference),
        builder: ((context, AsyncSnapshot<Map> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return new Text('loading...');
            default:
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              else
                return _buildItem(value, snapshot.data);
          }
        }));
  }

  ///세부 아이템 템플릿 생성하기
  ///1. 이미지
  ///2. 하단 정보
  ///3. 날짜 정보
  Widget _buildItem(DocumentSnapshot doc, Map map)  {
    VoteInfo item = VoteInfo.fromDocument(doc);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Flexible(
            fit: FlexFit.loose,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute<bool>(builder: (BuildContext context) {
                  return VoteScreen(
                    voteInfo: item,
                  );
                }));
              },
              child: new Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
              ),
            )
/*          child: new Image.network(
            item.imageUrl,
            fit: BoxFit.cover,
          ),*/
            ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            item.title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Icon(
                    FontAwesomeIcons.heart,
                  ),
                  new Text(
                    map['viewCount'].toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  new SizedBox(
                    width: 16.0,
                  ),
                  new Icon(
                    FontAwesomeIcons.comment,
                  ),
                  new Text(
                    map['likeCount'].toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  new SizedBox(
                    width: 16.0,
                  ),
                  /* new Icon(FontAwesomeIcons.paperPlane),*/
                ],
              ),
              /*new Icon(FontAwesomeIcons.bookmark)*/
            ],
          ),
        ),
        /*Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "Liked by pawankumar, pk and 528,331 others",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Container(
                height: 40.0,
                width: 40.0,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: new NetworkImage(
                          "https://pbs.twimg.com/profile_images/916384996092448768/PF1TSFOE_400x400.jpg")),
                ),
              ),
              new SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: new TextField(
                  decoration: new InputDecoration(
                    border: InputBorder.none,
                    hintText: "Add a comment...",
                  ),
                ),
              ),
            ],
          ),
        ),*/
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text("등록일 : 1 Day Ago", style: TextStyle(color: Colors.grey)),
        )
      ],
    );
  }
}
