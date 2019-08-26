import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String id;
  final String photoUrl;
  final String username;
  final String displayName;
  final String bio;
  final String uid;
  final Map followers;
  final Map following;

  const User(
      {this.username,
      this.id,
      this.photoUrl,
      this.email,
      this.displayName,
      this.bio,
        this.uid,
      this.followers,
      this.following});

  factory User.fromDocument(DocumentSnapshot document) {
    return User(
      email: document['email'],
      username: document['username'],
      photoUrl: document['photoUrl'],
      id: document.documentID,
      displayName: document['displayName'],
      bio: document['bio'],
      uid: document['uid'],
      followers: document['followers'],
      following: document['following'],
    );
  }
}
