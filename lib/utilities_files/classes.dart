import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/utilities_files/constant.dart';

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
  String id;

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
      this.topics,
      this.id});

  User.fromSnapshot(DocumentSnapshot snapshot) {
    isAdmin = snapshot.data['isAdmin'] as bool;
    id = snapshot.documentID;
    email = snapshot.data['email'] as String;
    isProfileSet = snapshot.data['isProfileSet'] as bool;
    university = snapshot.data['university'] as String;
    userName = snapshot.data['username'] as String;
    isProf = snapshot.data['isProf'] as bool;
    bio = snapshot.data['bio'] as String;
    fname = snapshot.data['fname'] as String;
    lname = snapshot.data['lname'] as String;
    mobile = snapshot.data['mobile_number'] as String;
    topics = snapshot.data['topics']?.cast<String>();
  }

  @override
  String toString() {
    return 'User{email: $email, userName: $userName, isAdmin: $isAdmin, isProf: $isProf, isProfileSet: $isProfileSet, university: $university, fname: $fname, lname: $lname, bio: $bio, mobile: $mobile, topics: $topics, id: $id}';
  }

  static Future<User> getUserFromID(String id) async {
    DocumentSnapshot userDoc = await Firestore.instance.collection('Users').document(id).get();
    return User.fromSnapshot(userDoc);
  }

  Future<bool> updateUser() async {
    try {
      await Firestore.instance.collection('Users').document(this.id).updateData({
        'username': this.userName,
        'bio': this.bio,
        'mobile_number': this.mobile,
        'fname': this.fname,
        'lname': this.lname,
      });
      return true;
    } catch (e) {
      print("User.updateUser");
      print(e);
      return false;
    }
  }

  Future<bool> updateTopicList() async {
    try {
      await Firestore.instance.collection('Users').document(this.id).updateData({
        'topics': this.topics,
      });
      return true;
    } catch (e) {
      print("User.updateTopicList");
      print(e);
      return false;
    }
  }
}

class Question {
  String heading;
  String description;
  DateTime createdOn;
  DateTime editedOn;
  int upvoteCount;
  int downvoteCount;
  List<String> upvoters;
  List<String> downvoters;
  List<String> topics;
  String id;
  bool byProf;
  bool isDraft;
  int answerCount;
  String userId;
  String descriptionJson;

  Question(
      {this.heading,
      this.description,
      this.createdOn,
      this.editedOn,
      this.upvoteCount,
      this.downvoteCount,
      this.upvoters,
      this.downvoters,
      this.topics,
      this.byProf,
      this.id,
      this.isDraft,
      this.answerCount,
      this.userId,
      this.descriptionJson});

  Question.fromSnapshot(DocumentSnapshot snapshot) {
    heading = snapshot.data['heading'];
    description = snapshot.data['description'];
    createdOn = (snapshot.data['createdOn'] as Timestamp)?.toDate();
    editedOn = (snapshot.data['editedOn'] as Timestamp)?.toDate();
    upvoteCount = snapshot.data['upvoteCount'] as int;
    downvoteCount = snapshot.data['downvoteCount'] as int;
    upvoters = snapshot.data['upvoters']?.cast<String>();
    downvoters = snapshot.data['downvoters']?.cast<String>();
    topics = snapshot.data['topic']?.cast<String>();
    id = snapshot.documentID;
    byProf = snapshot.data['byProf'] as bool;
    isDraft = snapshot.data['isDraft'] as bool;
    answerCount = snapshot.data['answerCount'] as int;
    userId = snapshot.data['userid'] as String;
    descriptionJson = snapshot.data['descriptionJson'] as String;
  }

  Future<bool> uploadQuestion() async {
    try {
      Firestore.instance.collection('Questions').add({
        'heading': this.heading,
        'description': this.description,
        'createdOn': this.createdOn,
        'editedOn': this.editedOn,
        'upvoteCount': this.upvoteCount,
        'downvoteCount': this.downvoteCount,
        'upvoters': this.upvoters,
        'downvoters': this.downvoters,
        'topic': this.topics,
        'byProf': this.byProf,
        'isDraft': this.isDraft,
        'answerCount': this.answerCount,
        'userid': this.userId,
        'descriptionJson': this.descriptionJson,
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
    return 'Question{heading: $heading, description: $description, createdOn: $createdOn, editedOn: $editedOn, upvoteCount: $upvoteCount, downvoteCount: $downvoteCount, upvoters: $upvoters, downvoters: $downvoters, topics: $topics, id: $id, byProf: $byProf, isDraft: $isDraft, answerCount: $answerCount, userId: $userId, descriptionJson: $descriptionJson}';
  }

  Future<bool> updateQuestion() async {
    print('Questions/' + this.id);
    try {
      await Firestore.instance.document('Questions/' + this.id).updateData({
        'heading': this.heading,
        'description': this.description,
        'createdOn': this.createdOn,
        'editedOn': this.editedOn,
        'upvoteCount': this.upvoteCount,
        'downvoteCount': this.downvoteCount,
        'upvoters': this.upvoters,
        'downvoters': this.downvoters,
        'topic': this.topics,
        'byProf': this.byProf,
        'isDraft': this.isDraft,
        'answerCount': this.answerCount,
        'userid': this.userId,
        'descriptionJson': this.descriptionJson,
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
      await Firestore.instance.document('Questions/' + this.id).delete();
      return true;
    } catch (e) {
      print("Question.delete()");
      print(e);
      return false;
    }
  }

  Future<bool> upvote() async {
    String userDocId = await Constant.getCurrentUserDocId();
    if (!this.upvoters.contains(userDocId)) {
      if (this.downvoters.contains(userDocId)) {
        //if user had downvoted it earlier, cancel the downvote and increase upvote
        Firestore.instance.collection('Questions').document(this.id).updateData({
          'downvoteCount': FieldValue.increment(-1),
          'downvoters':FieldValue.arrayRemove([userDocId]),
          'upvoteCount': FieldValue.increment(1),
          'upvoters': FieldValue.arrayUnion([userDocId]),
        });
      } else {
        Firestore.instance.collection('Questions').document(this.id).updateData({
          'upvoteCount': FieldValue.increment(1),
          'upvoters': FieldValue.arrayUnion([userDocId]),
        });
      }
    } else {
      Constant.showToastInstruction("Already upvoted. Cancelling upvote.");
      Firestore.instance.collection('Questions').document(this.id).updateData({
        'upvoteCount': FieldValue.increment(-1),
        'upvoters': FieldValue.arrayRemove([userDocId]),
      });
    }
    return true;
  }

  Future<bool> downvote() async {
    String userDocId = await Constant.getCurrentUserDocId();
    if(!this.downvoters.contains(userDocId)){
      if(this.upvoters.contains(userDocId)){
        //if user had upvoted it earlier, cancel the upvote and increase downvote
        Firestore.instance.collection('Questions').document(this.id).updateData({
          'upvoteCount': FieldValue.increment(-1),
          'upvoters':FieldValue.arrayRemove([userDocId]),
          'downvoteCount': FieldValue.increment(1),
          'downvoters': FieldValue.arrayUnion([userDocId]),
        });
      } else {
        Firestore.instance.collection('Questions').document(this.id).updateData({
          'downvoteCount': FieldValue.increment(1),
          'downvoters': FieldValue.arrayUnion([userDocId]),
        });
      }
      return true;
    } else {
      Constant.showToastInstruction("Already Downvoted. Cancelling downvote.");
      Firestore.instance.collection('Questions').document(this.id).updateData({
        'downvoteCount': FieldValue.increment(-1),
        'downvoters': FieldValue.arrayRemove([userDocId]),
      });
      return true;
    }
  }
}

class Article {
  String title;
  String subtitle;
  String content;
  DateTime createdOn;
  DateTime editedOn;
  int upvoteCount;
  int downvoteCount;
  List<String> upvoters;
  List<String> downvoters;
  List<String> topics;
  String id;
  bool byProf;
  bool isDraft;
  String userId;
  String contentJson;

  Article(
      {this.title,
      this.subtitle,
      this.content,
      this.createdOn,
      this.editedOn,
      this.upvoteCount,
      this.downvoteCount,
      this.upvoters,
      this.downvoters,
      this.topics,
      this.id,
      this.byProf,
      this.isDraft,
      this.userId,
      this.contentJson});

  Article.fromSnapshot(DocumentSnapshot snapshot) {
    title = snapshot.data['title'];
    subtitle = snapshot.data['subtitle'];
    content = snapshot.data['content'];
    createdOn = (snapshot.data['createdOn'] as Timestamp)?.toDate();
    editedOn = (snapshot.data['editedOn'] as Timestamp)?.toDate();
    upvoteCount = snapshot.data['upvoteCount'] as int;
    downvoteCount = snapshot.data['downvoteCount'] as int;
    upvoters = snapshot.data['upvoters']?.cast<String>();
    downvoters = snapshot.data['downvoters']?.cast<String>();
    topics = snapshot.data['topic']?.cast<String>();
    id = snapshot.documentID;
    byProf = snapshot.data['byProf'] as bool;
    isDraft = snapshot.data['isDraft'] as bool;
    userId = snapshot.data['userid'] as String;
    contentJson = snapshot.data['contentJson'] as String;
  }

  @override
  String toString() {
    return 'Article{title: $title, subtitle: $subtitle, content: $content, createdOn: $createdOn, editedOn: $editedOn, upvoteCount: $upvoteCount, downvoteCount: $downvoteCount, upvoters: $upvoters, downvoters: $downvoters, topics: $topics, id: $id, byProf: $byProf, isDraft: $isDraft, userId: $userId, contentJson: $contentJson}';
  }

  Future<bool> updateArticle() async {
    print('Articles/' + this.id);
    try {
      await Firestore.instance.document('Articles/' + this.id).updateData({
        'title': this.title,
        'subtitle': this.subtitle,
        'content': this.content,
        'createdOn': this.createdOn,
        'editedOn': this.editedOn,
        'upvoteCount': this.upvoteCount,
        'downvoteCount': this.downvoteCount,
        'upvoters': this.upvoters,
        'downvoters': this.downvoters,
        'topic': this.topics,
        'byProf': this.byProf,
        'isDraft': this.isDraft,
        'userid': this.userId,
        'contentJson': this.contentJson,
      });
      return true;
    } catch (e) {
      print("updateArticle");
      print(e);
      return false;
    }
  }

  Future<bool> uploadArticle() async {
    try {
      Firestore.instance.collection('Articles').add({
        'title': this.title,
        'subtitle': this.subtitle,
        'content': this.content,
        'createdOn': this.createdOn,
        'editedOn': this.editedOn,
        'upvoteCount': this.upvoteCount,
        'downvoteCount': this.downvoteCount,
        'upvoters': this.upvoters,
        'downvoters': this.downvoters,
        'topic': this.topics,
        'byProf': this.byProf,
        'isDraft': this.isDraft,
        'userid': this.userId,
        'contentJson': this.contentJson,
      });
      return true;
    } catch (e) {
      print("Article.uploadArticle()");
      print(e);
      return false;
    }
  }

  Future<bool> delete() async {
    try {
      await Firestore.instance.document('Articles/' + this.id).delete();
      return true;
    } catch (e) {
      print("Article.delete()");
      print(e);
      return false;
    }
  }

  Future<bool> upvote() async {
    String userDocId = await Constant.getCurrentUserDocId();
    if (!this.upvoters.contains(userDocId)) {
      if (this.downvoters.contains(userDocId)) {
        //if user had downvoted it earlier, cancel the downvote and increase upvote
        Firestore.instance.collection('Articles').document(this.id).updateData({
          'downvoteCount': FieldValue.increment(-1),
          'downvoters':FieldValue.arrayRemove([userDocId]),
          'upvoteCount': FieldValue.increment(1),
          'upvoters': FieldValue.arrayUnion([userDocId]),
        });
      } else {
        Firestore.instance.collection('Articles').document(this.id).updateData({
          'upvoteCount': FieldValue.increment(1),
          'upvoters': FieldValue.arrayUnion([userDocId]),
        });
      }
    } else {
      Constant.showToastInstruction("Already upvoted. Cancelling upvote.");
      Firestore.instance.collection('Articles').document(this.id).updateData({
        'upvoteCount': FieldValue.increment(-1),
        'upvoters': FieldValue.arrayRemove([userDocId]),
      });
    }
    return true;
  }

  Future<bool> downvote() async {
    String userDocId = await Constant.getCurrentUserDocId();
    if(!this.downvoters.contains(userDocId)){
      if(this.upvoters.contains(userDocId)){
        //if user had upvoted it earlier, cancel the upvote and increase downvote
        Firestore.instance.collection('Articles').document(this.id).updateData({
          'upvoteCount': FieldValue.increment(-1),
          'upvoters':FieldValue.arrayRemove([userDocId]),
          'downvoteCount': FieldValue.increment(1),
          'downvoters': FieldValue.arrayUnion([userDocId]),
        });
      } else {
        Firestore.instance.collection('Articles').document(this.id).updateData({
          'downvoteCount': FieldValue.increment(1),
          'downvoters': FieldValue.arrayUnion([userDocId]),
        });
      }
      return true;
    } else {
      Constant.showToastInstruction("Already Downvoted. Cancelling downvote.");
      Firestore.instance.collection('Articles').document(this.id).updateData({
        'downvoteCount': FieldValue.increment(-1),
        'downvoters': FieldValue.arrayRemove([userDocId]),
      });
      return true;
    }
  }

}

class Answer {
  String content;
  String queID;
  String id;
  String userId;
  DateTime createdOn;
  List<String> upvoters;
  List<String> downvoters;
  int upvoteCount;
  int downvoteCount;
  bool byProf;
  bool isDraft;
  String contentJson;

  Answer(
      {this.content,
      this.queID,
      this.id,
      this.userId,
      this.createdOn,
      this.upvoters,
      this.downvoters,
      this.upvoteCount,
      this.downvoteCount,
      this.byProf,
      this.isDraft,
      this.contentJson});

  Answer.fromSnapshot(DocumentSnapshot snapshot) {
    content = snapshot.data['content'];
    createdOn = (snapshot.data['createdOn'] as Timestamp)?.toDate();
    userId = snapshot.data['userid'];
    upvoteCount = snapshot.data['upvoteCount'] as int;
    downvoteCount = snapshot.data['downvoteCount'] as int;
    upvoters = snapshot.data['upvoters']?.cast<String>();
    downvoters = snapshot.data['downvoters']?.cast<String>();
    id = snapshot.documentID;
    byProf = snapshot.data['byProf'] as bool;
    isDraft = snapshot.data['isDraft'] as bool;
    queID = snapshot.data['questionId'] as String;
    contentJson = snapshot.data['contentJson'] as String;
  }

  Future<bool> uploadAnswer(bool doIncrement) async {
    //uploading answer
    try {
      await Firestore.instance.collection('Answers').add({
        'content': this.content,
        'createdOn': this.createdOn,
        'userid': this.userId,
        'upvoteCount': this.upvoteCount,
        'downvoteCount': this.downvoteCount,
        'upvoters': this.upvoters,
        'downvoters': this.downvoters,
        'byProf': this.byProf,
        'isDraft': this.isDraft,
        'questionId': this.queID,
        'contentJson': this.contentJson,
      });
      //updating answer count in the relevant question
      if (doIncrement) {
        await Firestore.instance.document('Questions/' + this.queID).updateData({
          'answerCount': FieldValue.increment(1),
        });
      }
      return true;
    } catch (e) {
      print("Answer.upload()");
      print(e.toString());
      return false;
    }
  }

  Future<bool> update() async {
    try {
      Firestore.instance.document('Answers/' + this.id).updateData({
        'content': this.content,
        'createdOn': this.createdOn,
        'userid': this.userId,
        'upvoteCount': this.upvoteCount,
        'downvoteCount': this.downvoteCount,
        'upvoters': this.upvoters,
        'downvoters': this.downvoters,
        'byProf': this.byProf,
        'isDraft': this.isDraft,
        'questionId': this.queID,
        'contentJson': this.contentJson,
      });
      return true;
    } catch (e) {
      print("Answer.update()");
      print(e);
      return false;
    }
  }

  @override
  String toString() {
    return 'Answer{content: $content, queID: $queID, id: $id, userId: $userId, createdOn: $createdOn, upvoters: $upvoters, downvoters: $downvoters, upvoteCount: $upvoteCount, downvoteCount: $downvoteCount, byProf: $byProf, isDraft: $isDraft, contentJson: $contentJson}';
  }

  //decrease answer count in question if applicable
  //For now we are only deleting draft answer, that's why we don't need to decrease answerCount.
  Future<bool> delete() async {
    try {
      Firestore.instance.document('Answers/' + this.id).delete();
      return true;
    } catch (e) {
      print("Answer.delete()");
      print(e);
      return false;
    }
  }

//TODO upvote answer

//TODO downvote answer

}

class University {
  String name;
  String country;
  String state;
  String city;
  List<String> topics;
  String id;

  University({this.name, this.country, this.state, this.city, this.topics, this.id});

  University.fromSnapshot(DocumentSnapshot snapshot) {
    this.name = snapshot.data['name'] as String;
    this.country = snapshot.data['country'] as String;
    this.state = snapshot.data['state'] as String;
    this.topics = snapshot.data['topics']?.cast<String>();
    this.id = snapshot.documentID;
  }

  Future<bool> updateTopics() async {
    try {
      await Firestore.instance.collection('University').document(this.id).updateData({
        'topics': this.topics,
      });
      return true;
    } catch (e) {
      print("University.updateTopics()");
      print(e);
      return false;
    }
  }
}
