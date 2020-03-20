import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class User {
  String email;
  String userName;
  bool isAdmin;
  bool isProf;
  bool isProfileSet;
  String university;

  User(
      {@required this.isProfileSet,
      @required this.email,
      @required this.isAdmin,
      @required this.university,
      @required this.userName,
      @required this.isProf}) {
    this.email = email;
    this.userName = userName;
    this.university = university;
    this.isAdmin = isAdmin;
    this.isProfileSet = isProfileSet;
    this.isProf = isProf;
  }

  User.fromSnapshot(DocumentSnapshot snapshot) {
    print("from class definition:-"+snapshot.data.toString());
    User(
      isAdmin: snapshot.data['isAdmin'] as bool,
      email: snapshot.data['email'] as String,
      isProfileSet: snapshot.data['isProfileSet'] as bool,
      university: snapshot.data['university'] as String,
      userName: snapshot.data['userName'] as String,
      isProf: snapshot.data['isProf'] as bool,
    );
  }

  @override
  String toString() {
    return "User:-\nUsername:-$userName\nEmail:-$email\nUniversity:-$university\nIsAdmin:{$isAdmin}\nisProfileSet:{$isProfileSet}\nisProf:{$isProf}";
  }
}

