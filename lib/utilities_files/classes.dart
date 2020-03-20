import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User {
  String email;
  String userName;
  bool isAdmin;
  bool isProf;
  bool isProfileSet;
  String university;
  String fname;
  String lname;
  String bio;
  String mobile;
  List<String> topics;

  User(
      {this.email,
      this.userName,
      this.isAdmin,
      this.isProf,
      this.isProfileSet,
      this.university,
      this.fname,
      this.lname,
      this.bio,
      this.mobile,
      this.topics});

  User.fromSnapshot(DocumentSnapshot snapshot) {
    isAdmin = snapshot.data['isAdmin'] as bool;
    email = snapshot.data['email'] as String;
    isProfileSet = snapshot.data['isProfileSet'] as bool;
    university = snapshot.data['university'] as String;
    userName = snapshot.data['username'] as String;
    isProf = snapshot.data['isProf'] as bool;
    bio = snapshot.data['bio'] as String;
    fname = snapshot.data['fname'] as String;
    lname = snapshot.data['lname'] as String;
    mobile = snapshot.data['mobile_number'] as String;
    topics = snapshot.data['topics'].cast<String>();
  }

  @override
  String toString() {
    return 'User{email: $email, userName: $userName, isAdmin: $isAdmin, isProf: $isProf, isProfileSet: $isProfileSet, university: $university, fname: $fname, lname: $lname, bio: $bio, mobile: $mobile, topics: $topics}';
  }

  static Future<String> getCurrentUsername() async {
      try {
          FirebaseUser curUser = await FirebaseAuth.instance.currentUser();
          QuerySnapshot curUserQuery = await Firestore.instance.collection('Users').where('email',isEqualTo: curUser.email).getDocuments();
          String username = curUserQuery.documents[0].data['username'];
          return username;
      } catch (e) {
          print("User.getCurrentUsername:");
          print(e);
          return null;
      }
  }
}

class Question {
  String heading;
  String description;
  DateTime createdOn;
  DateTime editedOn;
  String username;
  int upvoteCount;
  int downvoteCount;
  List<String> upvoters;
  List<String> downvoters;
  String topic;
  String id;

  Question({this.heading, this.description, this.createdOn, this.editedOn, this.username,
      this.upvoteCount, this.downvoteCount, this.upvoters, this.downvoters, this.topic});

  Question.fromSnapshot(DocumentSnapshot snapshot) {
    heading = snapshot.data['heading'];
    description = snapshot.data['description'];
    createdOn = snapshot.data['createdOn'] as DateTime;
    editedOn = snapshot.data['editedOn'] as DateTime;
    username = snapshot.data['username'];
    upvoteCount = snapshot.data['upvoteCounts'] as int;
    downvoteCount = snapshot.data['downvoteCounts'] as int;
    upvoters = snapshot.data['upvoters'].cast<String>();
    downvoters = snapshot.data['downvoters'].cast<String>();
    topic = snapshot.data['topic'];
    id = snapshot.documentID;
  }

  //TODO upload,publish question
  Future<bool> uploadQuestion() async {
    try {
      Firestore.instance.collection('Questions').add({
            'heading': this.heading,
            'description': this.description,
            'createdOn': this.createdOn,
            'editedOn': this.editedOn,
            'username': this.username,
            'upvoteCount': this.upvoteCount,
            'downvoteCount': this.downvoteCount,
            'upvoters': this.upvoters,
            'downvoters': this.downvoters,
            'topic': this.topic,
          });
      return true;
    } catch (e) {
      print("Question.uploadQuestion()");
      print(e);
      return false;
    }
  }

  @override
  String toString() {
    return 'Question{heading: $heading, description: $description, createdOn: $createdOn, editedOn: $editedOn, username: $username, upvoteCount: $upvoteCount, downvoteCount: $downvoteCount, upvoters: $upvoters, downvoters: $downvoters, topic: $topic, id: $id}';
  }
//TODO edit,save question as draft

//TODO delete question

//TODO upvote question

//TODO downvote question
}
