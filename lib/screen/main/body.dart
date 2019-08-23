import 'package:flutter/material.dart';

import 'list.dart';

class VoteHomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        // Expanded(flex: 1, child: new InstaStories()),
        Flexible(child: VoteHomeList())
      ],
    );
  }
}