import 'package:cloud_firestore/cloud_firestore.dart';

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
  List<String> topics;
  String id;
  bool byProf;
  bool isDraft;

  Question(
      {this.heading,
      this.description,
      this.createdOn,
      this.editedOn,
      this.username,
      this.upvoteCount,
      this.downvoteCount,
      this.upvoters,
      this.downvoters,
      this.topics,
      this.byProf,
      this.id,
      this.isDraft});

  Question.fromSnapshot(DocumentSnapshot snapshot) {
    heading = snapshot.data['heading'];
    description = snapshot.data['description'];
    createdOn = (snapshot.data['createdOn'] as Timestamp)?.toDate();
    editedOn = (snapshot.data['editedOn'] as Timestamp)?.toDate();
    username = snapshot.data['username'];
    upvoteCount = snapshot.data['upvoteCount'] as int;
    downvoteCount = snapshot.data['downvoteCount'] as int;
    upvoters = snapshot.data['upvoters']?.cast<String>();
    downvoters = snapshot.data['downvoters']?.cast<String>();
    topics = snapshot.data['topic']?.cast<String>();
    id = snapshot.documentID;
    byProf = snapshot.data['byProf'] as bool;
    isDraft = snapshot.data['isDraft'] as bool;
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
        'topic': this.topics,
        'byProf': this.byProf,
        'isDraft': this.isDraft,
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
    return 'Question{heading: $heading, description: $description, createdOn: $createdOn, editedOn: $editedOn, username: $username, upvoteCount: $upvoteCount, downvoteCount: $downvoteCount, upvoters: $upvoters, downvoters: $downvoters, topics: $topics, id: $id, byProf: $byProf, isDraft: $isDraft}';
  }

//TODO edit,save question as draft
  Future<bool> updateQuestion() async {
    print('Questions/' + this.id);
    try {
      await Firestore.instance.document('Questions/' + this.id).updateData({
        'heading': this.heading,
        'description': this.description,
        'createdOn': this.createdOn,
        'editedOn': this.editedOn,
        'username': this.username,
        'upvoteCount': this.upvoteCount,
        'downvoteCount': this.downvoteCount,
        'upvoters': this.upvoters,
        'downvoters': this.downvoters,
        'topic': this.topics,
        'byProf': this.byProf,
        'isDraft': this.isDraft,
      });
      return true;
    } catch (e) {
      print("updateQuestion");
      print(e);
      return false;
    }
  }
    Future<bool> delete() async {
      try {
          await Firestore.instance.document('Questions/'+this.id).delete();
          return true;
      } catch (e) {
          print("Question.delete()");
          print(e);
          return false;
      }
    }
//TODO upvote question

//TODO downvote question
}
