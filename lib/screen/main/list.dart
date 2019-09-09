import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vote/models/vote.dart';
import 'package:flutter_vote/repository/repository.dart';
import 'package:flutter_vote/screen/vote/index.dart';
import 'package:flutter_vote/service/FireStoreHelper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

///메인 화면
///1. stateful widget 선언
class VoteHomeList extends StatefulWidget {
  /// 위젯이 호출되면, createState를 호출 한다.
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

  ///initState를 호출한다.
  @override
  void initState() {

    /// 초기화 후, _getVoteData를 가져온다.
    super.initState();
    print(">>>>>>init");
    voteDocuments = _getVoteData();
  }

  /// setState 호출 된 뒤, builder를 호출 한다.
  @override
  Widget build(BuildContext context) {
    ///FutureBuilder 를 통해서, 데이터를 가져온뒤, builder 를 수행 한다.
    var futureBuilder = new FutureBuilder(
      future: voteDocuments,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return createListViewShimmer(context);
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
          title: new Text("찬반투표 워리어"),
        ),
        body: futureBuilder);
  }

  /// 기본 투표 정보 레퍼런스를 가져온다.
  Future<List<DocumentSnapshot>> _getVoteData() {
    //콜백 처리
    Future<List<DocumentSnapshot>> _voteDocuments = _repository.fetchVoteInfo();
    return _voteDocuments;
  }

  ///Shimmen
  Widget createListViewShimmer(BuildContext context) {



    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        child: Column(
          children: [0, 1, 2, 3, 4, 5, 6]
              .map((_) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48.0,
                  height: 48.0,
                  color: Colors.white,
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8.0),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 8.0,
                        color: Colors.white,
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(vertical: 2.0),
                      ),
                      Container(
                        width: double.infinity,
                        height: 8.0,
                        color: Colors.white,
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(vertical: 2.0),
                      ),
                      Container(
                        width: 40.0,
                        height: 8.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ))
              .toList(),
        ),
      ),
    );
  }


  ///리스트 뷰 생성하기
  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<DocumentSnapshot> values = snapshot.data;
    return ListView.builder(
        itemCount: values.length,
        itemBuilder: (context, index) {
          return _buildItem(values[index]);
          //return _buildItemByFutureBuilder(values[index], values[index].reference);
        });
  }

  /// 투표 정보 관련 카운팅 정보를 가져온다.
  /// 해당 방법은 다큐먼트의 컬렉션을 생성하여 뷰 카운트를 가져오는 방식
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

  /// FutureBuilder를 통해서, 세부 아이템 템플릿 정보를 가져온다.
  /// 해당 방법은 조회수를 따로 가져왔을때 사용
  /*Widget _buildItemByFutureBuilder(DocumentSnapshot value, DocumentReference reference) {
    return FutureBuilder(
        future: _getVoteViewCount(reference),
        builder: ((context, AsyncSnapshot<Map> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              *//*return Center(child: CircularProgressIndicator(),);*//*
            default:
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              else
                return _buildItem(value, snapshot.data);
          }
        }));
  }*/

  ///세부 아이템 템플릿 생성하기
  ///1. 이미지
  ///2. 하단 정보
  ///3. 날짜 정보
//  Widget _buildItem(DocumentSnapshot doc, Map map)  {
  Widget _buildItem(DocumentSnapshot doc)  {
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

                /// 이미지 를 클릭 시, 해당 투표 상세 정보로 넘어간다.
                /// 1. 이때, 먼저 조회수를 증가 시키고, 투표 정보로 넘어간다.
                navigateToVoteInfo(doc, item);

              },
              child: new Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
              ),
            )
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
                    FontAwesomeIcons.eye,
                  ),
                  new SizedBox(
                    width: 16.0,
                  ),
                  new Text(
                    item.voteNumber.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  new SizedBox(
                    width: 16.0,
                  ),
                  new Icon(
                    FontAwesomeIcons.comment,
                  ),
                  new SizedBox(
                    width: 16.0,
                  ),
                  new Text(
                    item.voteComments.toString(),
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

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text("등록일 : 1 Day Ago", style: TextStyle(color: Colors.grey)),
        )
      ],
    );
  }


  ///BuildShimmer
  ///세부 아이템 템플릿 생성하기
  ///1. 이미지
  ///2. 하단 정보
  ///3. 날짜 정보
//  Widget _buildItem(DocumentSnapshot doc, Map map)  {
  Widget _buildItemShimmer(DocumentSnapshot doc)  {
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

                /// 이미지 를 클릭 시, 해당 투표 상세 정보로 넘어간다.
                /// 1. 이때, 먼저 조회수를 증가 시키고, 투표 정보로 넘어간다.
                navigateToVoteInfo(doc, item);

              },
              child: new Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
              ),
            )
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
                    FontAwesomeIcons.eye,
                  ),
                  new SizedBox(
                    width: 16.0,
                  ),
                  new Text(
                    item.voteNumber.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  new SizedBox(
                    width: 16.0,
                  ),
                  new Icon(
                    FontAwesomeIcons.comment,
                  ),
                  new SizedBox(
                    width: 16.0,
                  ),
                  new Text(
                    item.voteComments.toString(),
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

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text("등록일 : 1 Day Ago", style: TextStyle(color: Colors.grey)),
        )
      ],
    );
  }



  void navigateToVoteInfo(DocumentSnapshot snapshot, VoteInfo item) async {
    print('before update');
    await updateVoteNumber(snapshot, item);
    /// navigate
    print('after update');
    Navigator.of(context).push(
        MaterialPageRoute<bool>(builder: (BuildContext context) {
          return VoteScreen(
            voteInfo: item,
            documentSnapshot: snapshot,
          );
        }));
  }

  Future<void> updateVoteNumber(DocumentSnapshot snapshot, VoteInfo item) async
  {
    ///1. 해당 투표 정보의 조회수 정보를 가져온다.
    print('item number ${item.voteNumber}');

    /// ** 레퍼런스로 바로 접근 가능한가??

    int viewNumber = await _repository.fetchVoteViewCountByVoteId(item.id);

    await snapshot.reference.updateData({
      'voteNumber': viewNumber + 1}
    );
    print('item number update');
   }
}


class _PlaceHolder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 100.0,
          height: 100.0,
          color: Colors.white,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100.0,
                height: 16.0,
                color: Colors.white,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  width: 50.0,
                  height: 16.0,
                  color: Colors.white,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}