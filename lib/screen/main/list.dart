import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vote/models/vote.dart';
import 'package:flutter_vote/screen/vote/index.dart';
import 'package:flutter_vote/service/FireStoreHelper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VoteHomeList extends StatefulWidget {
  @override
  _VoteHomeListState createState() => _VoteHomeListState();
}

class _VoteHomeListState extends State<VoteHomeList> {
  final FireStoreHelper fireStoreHelper = new FireStoreHelper();
  QuerySnapshot voteSnapshot;
  List<VoteInfo> voteInfos = [];

  // 초기화 함수
  @override
  void initState() {
    fireStoreHelper.getVoteInfo().then((results) {
      setState(() {
        voteSnapshot = results;
        for (var doc in voteSnapshot.documents) {
          voteInfos.add(VoteInfo.fromDocument(doc));
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return ListView.builder(
        //itemCount: 5,
        itemCount: voteInfos.length,
        itemBuilder: (context, index) {
          return _buildItem(voteInfos[index]);
        });
  }

  Widget _buildItem(VoteInfo item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        /*Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
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
                  new Text(
                    "imthpk",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
              new IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: null,
              )
            ],
          ),
        )*/
        Flexible(
            fit: FlexFit.loose,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute<bool>(builder: (BuildContext context) {
                  return VoteScreen(
                    voteId: item.id,
                    voteInfo: item,
                  );
                }));
                /*Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VoteScreen(),
                      // Pass the arguments as part of the RouteSettings. The
                      // ExtractArgumentScreen reads the arguments from these
                      // settings.
                      settings: RouteSettings(
                        arguments: ScreenArguments(
                          'Extract Arguments Screen',
                          'This message is extracted in the build method.',
                        ),
                      ),
                    ));*/
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
                    item.like.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  new SizedBox(
                    width: 16.0,
                  ),
                  new Icon(
                    FontAwesomeIcons.comment,
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
