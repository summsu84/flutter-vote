import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vote/repository/repository.dart';
import 'package:flutter_vote/screen/main/index.dart';
import 'package:splashscreen/splashscreen.dart';

import 'dart:core';
import 'dart:async';
import 'package:flutter/material.dart';

class VoteSplashScreen extends StatefulWidget {
  final int seconds;
  final Text title;
  final Color backgroundColor;
  final TextStyle styleTextUnderTheLoader;
  final dynamic navigateAfterSeconds;
  final double photoSize;
  final dynamic onClick;
  final Color loaderColor;
  final Image image;
  final Text loadingText;
  final ImageProvider imageBackground;
  final Gradient gradientBackground;

  VoteSplashScreen(
      {this.loaderColor,
      @required this.seconds,
      this.photoSize,
      this.onClick,
      this.navigateAfterSeconds,
      this.title = const Text(''),
      this.backgroundColor = Colors.white,
      this.styleTextUnderTheLoader = const TextStyle(
          fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
      this.image,
      this.loadingText = const Text(""),
      this.imageBackground,
      this.gradientBackground});

  @override
  _VoteSplashScreenState createState() => new _VoteSplashScreenState();
}

class _VoteSplashScreenState extends State<VoteSplashScreen> {
  /// 메인 화면에서 관련된 정보들을 가져오도록 설정 한다.
  /// 1. 전체 투표 정보
  /// 2. 전체 댓글 개수 정보 등

  //Vote 정보 스냅샷
  Future<List<DocumentSnapshot>> voteDocuments;
  final Repository _repository = Repository();

  @override
  void initState() {
    /// 초기화 후, _getVoteData를 가져온다.
    super.initState();
    print(">>>>>>init");
    _getVoteData();
/*    voteDocuments = _getVoteData().then((result) {
      if (widget.navigateAfterSeconds is String) {
        // It's fairly safe to assume this is using the in-built material
        // named route component
        Navigator.of(context).pushReplacementNamed(widget.navigateAfterSeconds);
      } else if (widget.navigateAfterSeconds is Widget) {
        Navigator.of(context).pushReplacement(new MaterialPageRoute(
            builder: (BuildContext context) => widget.navigateAfterSeconds));
      } else {
        throw new ArgumentError(
            'widget.navigateAfterSeconds must either be a String or Widget');
      }
    });*/
  }

  /// 기본 투표 정보 레퍼런스를 가져온다.
/*  Future<List<DocumentSnapshot>> _getVoteData() async {
    //콜백 처리
    Future<List<DocumentSnapshot>> _voteDocuments = _repository.fetchVoteInfo();
    return _voteDocuments;
  }*/

  void _getVoteData() async {
    //콜백 처리
    print('before calling...');
    List<DocumentSnapshot> _voteDocuments = await _repository.fetchVoteInfo();
    print('after calling...');
    if (widget.navigateAfterSeconds is String) {
      // It's fairly safe to assume this is using the in-built material
      // named route component
      Navigator.of(context).pushReplacementNamed(widget.navigateAfterSeconds);
    } else if (widget.navigateAfterSeconds is Widget) {
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (BuildContext context) => widget.navigateAfterSeconds));
    } else {
      throw new ArgumentError(
          'widget.navigateAfterSeconds must either be a String or Widget');
    }

    //return _voteDocuments;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new InkWell(
        onTap: widget.onClick,
        child: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            new Container(
              decoration: new BoxDecoration(
                image: widget.imageBackground == null
                    ? null
                    : new DecorationImage(
                        fit: BoxFit.cover,
                        image: widget.imageBackground,
                      ),
                gradient: widget.gradientBackground,
                color: widget.backgroundColor,
              ),
            ),
            new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Expanded(
                  flex: 2,
                  child: new Container(
                      child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: new Container(child: widget.image),
                        radius: widget.photoSize,
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                      ),
                      widget.title
                    ],
                  )),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            widget.loaderColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                      ),
                      widget.loadingText
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    /*return new SplashScreen(
        seconds: 13,
        navigateAfterSeconds: new VoteHome(),
        title: new Text('Welcome In SplashScreen',
          style: new TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0
          ),),
        image: new Image.network('https://i.imgur.com/TyCSG9A.png'),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        onClick: ()=>print("Flutter Egypt"),
        loaderColor: Colors.red
    );*/
  }
}
