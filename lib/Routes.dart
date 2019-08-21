import 'package:flutter/material.dart';
import 'package:flutter_vote/screen/comment/index.dart';
import 'package:flutter_vote/screen/vote/index.dart';


class Routes {

  var routes = <String, WidgetBuilder>{
/*    "/SignUp": (BuildContext context) => new SignUpScreen(),
    "/HomePage": (BuildContext context) => new HomeScreen(),*/
    "/Vote" : (BuildContext context) => new VoteScreen(),
    "/Comment" : (BuildContext context) => new CommentScreen(),
  };

  Routes() {
    runApp(new MaterialApp(
      title: "Flutter Flat App",
      home: new VoteScreen(),
      routes: routes,
    ));
  }
}
