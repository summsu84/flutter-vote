import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vote/Routes.dart';



Future<void> main() async {
  // enable timestamps in firebase
  Firestore.instance.settings(timestampsInSnapshotsEnabled: true).then((_) {
    print('[Main] Firestore timestamps in snapshots set');},
      onError: (_) => print('[Main] Error setting timestamps in snapshots')
  );
  new Routes();
}