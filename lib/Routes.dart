import 'package:flutter/material.dart';
import 'package:flutter_vote/screen/comment/index.dart';
import 'package:flutter_vote/screen/main/index.dart';
import 'package:flutter_vote/screen/vote/index.dart';


class Routes {

  var routes = <String, WidgetBuilder>{
/*    "/SignUp": (BuildContext context) => new SignUpScreen(),
    "/HomePage": (BuildContext context) => new HomeScreen(),*/
    "/Vote" : (BuildContext context) => new VoteScreen(),
    "/Comment" : (BuildContext context) => new CommentScreen(),
    "/Home" : (BuildContext context) => new VoteHome(),
  };
/*  Routes() {
    runApp(new MyApp());
  }*/
  Routes() {
    runApp(new MaterialApp(
      title: "Flutter Flat App",
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.black,
          primaryIconTheme: IconThemeData(color: Colors.black),
          primaryTextTheme: TextTheme(
              title: TextStyle(color: Colors.black, fontFamily: "Aveny")),
          textTheme: TextTheme(title: TextStyle(color: Colors.black))),
      home: new VoteHome(),
      routes: routes,
    ));
  }
}
/*


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Instagram',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.black,
          primaryIconTheme: IconThemeData(color: Colors.black),
          primaryTextTheme: TextTheme(
              title: TextStyle(color: Colors.black, fontFamily: "Aveny")),
          textTheme: TextTheme(title: TextStyle(color: Colors.black))),
      home: new VoteHome(),

    );
  }
}*/
