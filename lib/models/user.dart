import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String username;
  final String email;
  final String photoUrl;
  final String displayName;
  final String bio;
  final String collageName;
  final String departmentName;

  User({
    this.id,
    this.username,
    this.email,
    this.photoUrl,
    this.displayName,
    this.bio,
    this.collageName,
    this.departmentName,
  });

  factory User.fromDocument(DocumentSnapshot doc){
    return User(
      id: doc["id"],
      email: doc["email"],
      username: doc["username"],
      photoUrl: doc["photoUrl"],
      displayName: doc["displayName"],
      bio: doc["bio"],
      collageName: doc["collageName"],
      departmentName: doc["departmentName"]
    );
  }

}

