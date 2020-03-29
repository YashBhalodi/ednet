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
    topics = snapshot.data['topics']?.cast<String>();
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
//  String username;
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

  Question(
      {this.heading,
      this.description,
      this.createdOn,
      this.editedOn,
//      this.username,
      this.upvoteCount,
      this.downvoteCount,
      this.upvoters,
      this.downvoters,
      this.topics,
      this.byProf,
      this.id,
      this.isDraft,
      this.answerCount,
      this.userId});

  Question.fromSnapshot(DocumentSnapshot snapshot) {
    heading = snapshot.data['heading'];
    description = snapshot.data['description'];
    createdOn = (snapshot.data['createdOn'] as Timestamp)?.toDate();
    editedOn = (snapshot.data['editedOn'] as Timestamp)?.toDate();
//    username = snapshot.data['username'];
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

  }

  Future<bool> uploadQuestion() async {
    try {
      Firestore.instance.collection('Questions').add({
        'heading': this.heading,
        'description': this.description,
        'createdOn': this.createdOn,
        'editedOn': this.editedOn,
//        'username': this.username,
        'upvoteCount': this.upvoteCount,
        'downvoteCount': this.downvoteCount,
        'upvoters': this.upvoters,
        'downvoters': this.downvoters,
        'topic': this.topics,
        'byProf': this.byProf,
        'isDraft': this.isDraft,
        'answerCount': this.answerCount,
        'userid':this.userId,
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
    return 'Question{heading: $heading, description: $description, createdOn: $createdOn, editedOn: $editedOn, upvoteCount: $upvoteCount, downvoteCount: $downvoteCount, upvoters: $upvoters, downvoters: $downvoters, topics: $topics, id: $id, byProf: $byProf, isDraft: $isDraft, answerCount: $answerCount, userId: $userId}';
  }

  Future<bool> updateQuestion() async {
    print('Questions/' + this.id);
    try {
      await Firestore.instance.document('Questions/' + this.id).updateData({
        'heading': this.heading,
        'description': this.description,
        'createdOn': this.createdOn,
        'editedOn': this.editedOn,
//        'username': this.username,
        'upvoteCount': this.upvoteCount,
        'downvoteCount': this.downvoteCount,
        'upvoters': this.upvoters,
        'downvoters': this.downvoters,
        'topic': this.topics,
        'byProf': this.byProf,
        'isDraft': this.isDraft,
        'answerCount': this.answerCount,
        'userid':this.userId,
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
//TODO upvote question

//TODO downvote question
}

class Article {
  String title;
  String subtitle;
  String content;
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

  Article(
      {this.title,
      this.subtitle,
      this.content,
      this.createdOn,
      this.editedOn,
      this.username,
      this.upvoteCount,
      this.downvoteCount,
      this.upvoters,
      this.downvoters,
      this.topics,
      this.id,
      this.byProf,
      this.isDraft});

  Article.fromSnapshot(DocumentSnapshot snapshot) {
    title = snapshot.data['title'];
    subtitle = snapshot.data['subtitle'];
    content = snapshot.data['content'];
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

  @override
  String toString() {
    return 'Article{title: $title, subtitle: $subtitle, content: $content, createdOn: $createdOn, editedOn: $editedOn, username: $username, upvoteCount: $upvoteCount, downvoteCount: $downvoteCount, upvoters: $upvoters, downvoters: $downvoters, topics: $topics, id: $id, byProf: $byProf, isDraft: $isDraft}';
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
//TODO upvote article

//TODO downvote article
}

class Answer {
  String content;
  String queID;
  String id;
  String username;
  DateTime createdOn;
  List<String> upvoters;
  List<String> downvoters;
  int upvoteCount;
  int downvoteCount;
  bool byProf;
  bool isDraft;

  Answer({this.content, this.queID, this.id, this.username, this.createdOn, this.upvoters,
      this.downvoters, this.upvoteCount, this.downvoteCount, this.byProf, this.isDraft});

  Answer.fromSnapshot(DocumentSnapshot snapshot) {
    content = snapshot.data['content'];
    createdOn = (snapshot.data['createdOn'] as Timestamp)?.toDate();
    username = snapshot.data['username'];
    upvoteCount = snapshot.data['upvoteCount'] as int;
    downvoteCount = snapshot.data['downvoteCount'] as int;
    upvoters = snapshot.data['upvoters']?.cast<String>();
    downvoters = snapshot.data['downvoters']?.cast<String>();
    id = snapshot.documentID;
    byProf = snapshot.data['byProf'] as bool;
    isDraft = snapshot.data['isDraft'] as bool;
    queID = snapshot.data['questionId'] as String;
  }

  Future<bool> uploadAnswer(bool doIncrement) async {
    //uploading answer
    try {
      await Firestore.instance.collection('Answers').add({
        'content': this.content,
        'createdOn': this.createdOn,
        'username': this.username,
        'upvoteCount': this.upvoteCount,
        'downvoteCount': this.downvoteCount,
        'upvoters': this.upvoters,
        'downvoters': this.downvoters,
        'byProf': this.byProf,
        'isDraft': this.isDraft,
        'questionId': this.queID,
      });
      //updating answer count in the relevant question
      if (doIncrement) {
        int currentAnswerCount;
        await Firestore.instance.document('Questions/' + this.queID).get().then((snapshot) {
          currentAnswerCount = snapshot.data['answerCount'];
        }).catchError((e) {
          print("InGetting currentAnswerCount");
          print(e);
          return false;
        });
        await Firestore.instance.document('Questions/' + this.queID).updateData({
          'answerCount': currentAnswerCount + 1,
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
      Firestore.instance.document('Answers/'+this.id).updateData({
            'content': this.content,
            'createdOn': this.createdOn,
            'username': this.username,
            'upvoteCount': this.upvoteCount,
            'downvoteCount': this.downvoteCount,
            'upvoters': this.upvoters,
            'downvoters': this.downvoters,
            'byProf': this.byProf,
            'isDraft': this.isDraft,
            'questionId': this.queID,
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
    return 'Answer{content: $content, queID: $queID, id: $id, username: $username, createdOn: $createdOn, upvoters: $upvoters, downvoters: $downvoters, upvoteCount: $upvoteCount, downvoteCount: $downvoteCount, byProf: $byProf, isDraft: $isDraft}';
  }

//decrease answer count in question if applicable
 Future<bool> delete() async {
    try {
      Firestore.instance.document('Answers/'+this.id).delete();
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
