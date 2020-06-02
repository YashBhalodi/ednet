import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/notification_classes.dart';

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
  int profUpvoteCount;
  int reportCount;

  Question({
    this.heading,
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
    this.descriptionJson,
    this.profUpvoteCount,
    this.reportCount,
  });

  @override
  String toString() {
    return 'Question{heading: $heading, description: $description, createdOn: $createdOn, editedOn: $editedOn, upvoteCount: $upvoteCount, downvoteCount: $downvoteCount, upvoters: $upvoters, downvoters: $downvoters, topics: $topics, id: $id, byProf: $byProf, isDraft: $isDraft, answerCount: $answerCount, userId: $userId, descriptionJson: $descriptionJson, profUpvoteCount: $profUpvoteCount}';
  }

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
    profUpvoteCount = snapshot.data['profUpvoteCount'] as int ?? 0;
    reportCount = snapshot.data['reportCount'] as int ?? 0;
  }

  Future<DocumentReference> uploadQuestion() async {
    try {
      DocumentReference queDocRef = await Firestore.instance.collection('Questions').add({
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
        'profUpvoteCount': this.profUpvoteCount,
        'reportCount': this.reportCount,
      });
      return queDocRef;
    } catch (e) {
      print("Question.uploadQuestion()");
      print(e);
      return null;
    }
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
        'profUpvoteCount': this.profUpvoteCount,
        'reportCount': this.reportCount,
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
    User user = await Constant.getCurrentUserObject();
    Constant.defaultVibrate();
    if (!this.upvoters.contains(user.id)) {
      if (this.downvoters.contains(user.id)) {
        //if user had downvoted it earlier, cancel the downvote and increase upvote
        if (user.isProf) {
          Firestore.instance.collection('Questions').document(this.id).updateData({
            'downvoteCount': FieldValue.increment(-1),
            'downvoters': FieldValue.arrayRemove([user.id]),
            'upvoteCount': FieldValue.increment(1),
            'upvoters': FieldValue.arrayUnion([user.id]),
            'profUpvoteCount': FieldValue.increment(1),
          });
        } else {
          Firestore.instance.collection('Questions').document(this.id).updateData({
            'downvoteCount': FieldValue.increment(-1),
            'downvoters': FieldValue.arrayRemove([user.id]),
            'upvoteCount': FieldValue.increment(1),
            'upvoters': FieldValue.arrayUnion([user.id]),
          });
        }
      } else {
        if (user.isProf) {
          Firestore.instance.collection('Questions').document(this.id).updateData({
            'upvoteCount': FieldValue.increment(1),
            'upvoters': FieldValue.arrayUnion([user.id]),
            'profUpvoteCount': FieldValue.increment(1),
          });
        } else {
          Firestore.instance.collection('Questions').document(this.id).updateData({
            'upvoteCount': FieldValue.increment(1),
            'upvoters': FieldValue.arrayUnion([user.id]),
          });
        }
      }
    } else {
      Constant.showToastInstruction("Already upvoted.\nCancelling upvote.");
      if (user.isProf) {
        Firestore.instance.collection('Questions').document(this.id).updateData({
          'upvoteCount': FieldValue.increment(-1),
          'upvoters': FieldValue.arrayRemove([user.id]),
          'profUpvoteCount': FieldValue.increment(-1),
        });
      } else {
        Firestore.instance.collection('Questions').document(this.id).updateData({
          'upvoteCount': FieldValue.increment(-1),
          'upvoters': FieldValue.arrayRemove([user.id]),
        });
      }
    }
    return true;
  }

  Future<bool> downvote() async {
    User user = await Constant.getCurrentUserObject();
    Constant.defaultVibrate();
    if (!this.downvoters.contains(user.id)) {
      if (this.upvoters.contains(user.id)) {
        //if user had upvoted it earlier, cancel the upvote and increase downvote
        if (user.isProf) {
          Firestore.instance.collection('Questions').document(this.id).updateData({
            'upvoteCount': FieldValue.increment(-1),
            'upvoters': FieldValue.arrayRemove([user.id]),
            'downvoteCount': FieldValue.increment(1),
            'downvoters': FieldValue.arrayUnion([user.id]),
            'profUpvoteCount': FieldValue.increment(-1),
          });
        } else {
          Firestore.instance.collection('Questions').document(this.id).updateData({
            'upvoteCount': FieldValue.increment(-1),
            'upvoters': FieldValue.arrayRemove([user.id]),
            'downvoteCount': FieldValue.increment(1),
            'downvoters': FieldValue.arrayUnion([user.id]),
          });
        }
      } else {
        Firestore.instance.collection('Questions').document(this.id).updateData({
          'downvoteCount': FieldValue.increment(1),
          'downvoters': FieldValue.arrayUnion([user.id]),
        });
      }
      return true;
    } else {
      Constant.showToastInstruction("Already Downvoted.\nCancelling downvote.");
      Firestore.instance.collection('Questions').document(this.id).updateData({
        'downvoteCount': FieldValue.increment(-1),
        'downvoters': FieldValue.arrayRemove([user.id]),
      });
      return true;
    }
  }

  Future<bool> discardAllReports() async {
    try {
      await Firestore.instance
          .collection('Questions')
          .document(this.id)
          .collection('reports')
          .getDocuments()
          .then((querySnapshot) {
        querySnapshot.documents.forEach((doc) {
          doc.reference.delete();
        });
      });
      await Firestore.instance.collection('Questions').document(this.id).updateData({
        'reportCount': 0,
      });
      return true;
    } catch (e) {
      print('328__Question__Question.discardAllReports__classes.dart');
      print(e);
      return false;
    }
  }

  Future<bool> deleteWithAnswers() async {
    try {
      await Firestore.instance
          .collection('Answers')
          .where('questionId', isEqualTo: this.id)
          .getDocuments()
          .then((querySnapshot) {
        querySnapshot.documents.forEach((doc) {
          Answer a = Answer.fromSnapshot(doc);
          a.deletePublished();
        });
      });
      await this.discardAllReports();
      await this.delete();
      notifyAuthor();
      return true;
    } catch (e) {
      print('346__Question__Question.deleteWithAnswers__classes.dart');
      print(e);
      return false;
    }
  }

  Future<bool> notifyAuthor() async {
    String adminId = await Constant.getCurrentUserDocId();
    QuestionRemovedNotification questionRemovedNotification = QuestionRemovedNotification(
        type: "QuestionRemoved", adminId: adminId, content: this.heading);
    questionRemovedNotification.sendNotification(this.userId);
    return true;
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
  int profUpvoteCount;
  int reportCount;

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
      this.contentJson,
      this.profUpvoteCount,
      this.reportCount});

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
    profUpvoteCount = snapshot.data['profUpvoteCount'] as int ?? 0;
    reportCount = snapshot.data['reportCount'] as int ?? 0;
  }

  @override
  String toString() {
    return 'Article{title: $title, subtitle: $subtitle, content: $content, createdOn: $createdOn, editedOn: $editedOn, upvoteCount: $upvoteCount, downvoteCount: $downvoteCount, upvoters: $upvoters, downvoters: $downvoters, topics: $topics, id: $id, byProf: $byProf, isDraft: $isDraft, userId: $userId, contentJson: $contentJson, profUpvoteCount: $profUpvoteCount}';
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
        'profUpvoteCount': this.profUpvoteCount,
        'reportCount': this.reportCount
      });
      return true;
    } catch (e) {
      print("updateArticle");
      print(e);
      return false;
    }
  }

  Future<DocumentReference> uploadArticle() async {
    try {
      DocumentReference articleDoc = await Firestore.instance.collection('Articles').add({
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
        'profUpvoteCount': this.profUpvoteCount,
        'reportCount': this.reportCount
      });
      return articleDoc;
    } catch (e) {
      print("Article.uploadArticle()");
      print(e);
      return null;
    }
  }

  Future<bool> delete() async {
    try {
      await this.discardAllReports();
      await Firestore.instance.document('Articles/' + this.id).delete();
      return true;
    } catch (e) {
      print("Article.delete()");
      print(e);
      return false;
    }
  }

  Future<bool> deletePublished() async {
    await this.delete();
    await notifyAuthor();
    return true;
  }

  Future<bool> notifyAuthor() async {
    String adminId = await Constant.getCurrentUserDocId();
    ArticleRemovedNotification articleRemovedNotification = ArticleRemovedNotification(
      content: this.title,
      adminId: adminId,
      type: "ArticleRemoved",
    );
    await articleRemovedNotification.sendNotification(this.userId);
    return true;
  }

  Future<bool> upvote() async {
    User user = await Constant.getCurrentUserObject();
    Constant.defaultVibrate();
    if (!this.upvoters.contains(user.id)) {
      if (this.downvoters.contains(user.id)) {
        //if user had downvoted it earlier, cancel the downvote and increase upvote
        if (user.isProf) {
          Firestore.instance.collection('Articles').document(this.id).updateData({
            'downvoteCount': FieldValue.increment(-1),
            'downvoters': FieldValue.arrayRemove([user.id]),
            'upvoteCount': FieldValue.increment(1),
            'upvoters': FieldValue.arrayUnion([user.id]),
            'profUpvoteCount': FieldValue.increment(1),
          });
        } else {
          Firestore.instance.collection('Articles').document(this.id).updateData({
            'downvoteCount': FieldValue.increment(-1),
            'downvoters': FieldValue.arrayRemove([user.id]),
            'upvoteCount': FieldValue.increment(1),
            'upvoters': FieldValue.arrayUnion([user.id]),
          });
        }
      } else {
        if (user.isProf) {
          Firestore.instance.collection('Articles').document(this.id).updateData({
            'upvoteCount': FieldValue.increment(1),
            'upvoters': FieldValue.arrayUnion([user.id]),
            'profUpvoteCount': FieldValue.increment(1),
          });
        } else {
          Firestore.instance.collection('Articles').document(this.id).updateData({
            'upvoteCount': FieldValue.increment(1),
            'upvoters': FieldValue.arrayUnion([user.id]),
          });
        }
      }
    } else {
      Constant.showToastInstruction("Already upvoted.\nCancelling upvote.");
      if (user.isProf) {
        Firestore.instance.collection('Articles').document(this.id).updateData({
          'upvoteCount': FieldValue.increment(-1),
          'upvoters': FieldValue.arrayRemove([user.id]),
          'profUpvoteCount': FieldValue.increment(-1),
        });
      } else {
        Firestore.instance.collection('Articles').document(this.id).updateData({
          'upvoteCount': FieldValue.increment(-1),
          'upvoters': FieldValue.arrayRemove([user.id]),
        });
      }
    }
    return true;
  }

  Future<bool> downvote() async {
    User user = await Constant.getCurrentUserObject();
    Constant.defaultVibrate();
    if (!this.downvoters.contains(user.id)) {
      if (this.upvoters.contains(user.id)) {
        //if user had upvoted it earlier, cancel the upvote and increase downvote
        if (user.isProf) {
          Firestore.instance.collection('Articles').document(this.id).updateData({
            'upvoteCount': FieldValue.increment(-1),
            'upvoters': FieldValue.arrayRemove([user.id]),
            'downvoteCount': FieldValue.increment(1),
            'downvoters': FieldValue.arrayUnion([user.id]),
            'profUpvoteCount': FieldValue.increment(-1),
          });
        } else {
          Firestore.instance.collection('Articles').document(this.id).updateData({
            'upvoteCount': FieldValue.increment(-1),
            'upvoters': FieldValue.arrayRemove([user.id]),
            'downvoteCount': FieldValue.increment(1),
            'downvoters': FieldValue.arrayUnion([user.id]),
          });
        }
      } else {
        Firestore.instance.collection('Articles').document(this.id).updateData({
          'downvoteCount': FieldValue.increment(1),
          'downvoters': FieldValue.arrayUnion([user.id]),
        });
      }
      return true;
    } else {
      Constant.showToastInstruction("Already Downvoted.\nCancelling downvote.");
      Firestore.instance.collection('Articles').document(this.id).updateData({
        'downvoteCount': FieldValue.increment(-1),
        'downvoters': FieldValue.arrayRemove([user.id]),
      });
      return true;
    }
  }

  Future<bool> discardAllReports() async {
    try {
      await Firestore.instance
          .collection('Articles')
          .document(this.id)
          .collection('reports')
          .getDocuments()
          .then((querySnapshot) {
        querySnapshot.documents.forEach((doc) {
          doc.reference.delete();
        });
      });
      await Firestore.instance.collection('Articles').document(this.id).updateData({
        'reportCount': 0,
      });
      return true;
    } catch (e) {
      print('600__Article__Article.discardAllReports__classes.dart');
      print(e);
      return false;
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
  int profUpvoteCount;
  int reportCount;

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
      this.contentJson,
      this.profUpvoteCount,
      this.reportCount});

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
    profUpvoteCount = snapshot.data['profUpvoteCount'] as int ?? 0;
    reportCount = snapshot.data['reportCount'] as int ?? 0;
  }

  Future<DocumentReference> uploadAnswer(bool doIncrement) async {
    //uploading answer
    try {
      DocumentReference ansDoc = await Firestore.instance.collection('Answers').add({
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
        'profUpvoteCount': this.profUpvoteCount,
        'reportCount': this.reportCount,
      });
      //updating answer count in the relevant question
      if (doIncrement) {
        await Firestore.instance.document('Questions/' + this.queID).updateData({
          'answerCount': FieldValue.increment(1),
        });
      }
      return ansDoc;
    } catch (e) {
      print("Answer.upload()");
      print(e.toString());
      return null;
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
        'profUpvoteCount': this.profUpvoteCount,
        'reportCount': this.reportCount,
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
    return 'Answer{content: $content, queID: $queID, id: $id, userId: $userId, createdOn: $createdOn, upvoters: $upvoters, downvoters: $downvoters, upvoteCount: $upvoteCount, downvoteCount: $downvoteCount, byProf: $byProf, isDraft: $isDraft, contentJson: $contentJson, profUpvoteCount: $profUpvoteCount}';
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

  Future<bool> deletePublished() async {
    //reduce answer count of relevant question
    try {
      await Firestore.instance
          .collection('Questions')
          .document(this.queID)
          .updateData({'answerCount': FieldValue.increment(-1)});
      await this.discardAllReports();
      await this.delete();
      notifyAuthor();
      return true;
    } catch (e) {
      print('721__Answer__Answer.deletePublished__classes.dart');
      print(e);
      return false;
    }
  }

  Future<bool> upvote() async {
    User user = await Constant.getCurrentUserObject();
    Constant.defaultVibrate();
    if (!this.upvoters.contains(user.id)) {
      if (this.downvoters.contains(user.id)) {
        //if user had downvoted it earlier, cancel the downvote and increase upvote
        if (user.isProf) {
          Firestore.instance.collection('Answers').document(this.id).updateData({
            'downvoteCount': FieldValue.increment(-1),
            'downvoters': FieldValue.arrayRemove([user.id]),
            'upvoteCount': FieldValue.increment(1),
            'upvoters': FieldValue.arrayUnion([user.id]),
            'profUpvoteCount': FieldValue.increment(1),
          });
        } else {
          Firestore.instance.collection('Answers').document(this.id).updateData({
            'downvoteCount': FieldValue.increment(-1),
            'downvoters': FieldValue.arrayRemove([user.id]),
            'upvoteCount': FieldValue.increment(1),
            'upvoters': FieldValue.arrayUnion([user.id]),
          });
        }
      } else {
        if (user.isProf) {
          Firestore.instance.collection('Answers').document(this.id).updateData({
            'upvoteCount': FieldValue.increment(1),
            'upvoters': FieldValue.arrayUnion([user.id]),
            'profUpvoteCount': FieldValue.increment(1),
          });
        } else {
          Firestore.instance.collection('Answers').document(this.id).updateData({
            'upvoteCount': FieldValue.increment(1),
            'upvoters': FieldValue.arrayUnion([user.id]),
          });
        }
      }
    } else {
      Constant.showToastInstruction("Already upvoted.\nCancelling upvote.");
      if (user.isProf) {
        Firestore.instance.collection('Answers').document(this.id).updateData({
          'upvoteCount': FieldValue.increment(-1),
          'upvoters': FieldValue.arrayRemove([user.id]),
          'profUpvoteCount': FieldValue.increment(-1),
        });
      } else {
        Firestore.instance.collection('Answers').document(this.id).updateData({
          'upvoteCount': FieldValue.increment(-1),
          'upvoters': FieldValue.arrayRemove([user.id]),
        });
      }
    }
    return true;
  }

  Future<bool> downvote() async {
    User user = await Constant.getCurrentUserObject();
    Constant.defaultVibrate();
    if (!this.downvoters.contains(user.id)) {
      if (this.upvoters.contains(user.id)) {
        //if user had upvoted it earlier, cancel the upvote and increase downvote
        if (user.isProf) {
          Firestore.instance.collection('Answers').document(this.id).updateData({
            'upvoteCount': FieldValue.increment(-1),
            'upvoters': FieldValue.arrayRemove([user.id]),
            'downvoteCount': FieldValue.increment(1),
            'downvoters': FieldValue.arrayUnion([user.id]),
            'profUpvoteCount': FieldValue.increment(-1),
          });
        } else {
          Firestore.instance.collection('Answers').document(this.id).updateData({
            'upvoteCount': FieldValue.increment(-1),
            'upvoters': FieldValue.arrayRemove([user.id]),
            'downvoteCount': FieldValue.increment(1),
            'downvoters': FieldValue.arrayUnion([user.id]),
          });
        }
      } else {
        Firestore.instance.collection('Answers').document(this.id).updateData({
          'downvoteCount': FieldValue.increment(1),
          'downvoters': FieldValue.arrayUnion([user.id]),
        });
      }
      return true;
    } else {
      Constant.showToastInstruction("Already Downvoted.\nCancelling downvote.");
      Firestore.instance.collection('Answers').document(this.id).updateData({
        'downvoteCount': FieldValue.increment(-1),
        'downvoters': FieldValue.arrayRemove([user.id]),
      });
      return true;
    }
  }

  Future<bool> discardAllReports() async {
    try {
      await Firestore.instance
          .collection('Answers')
          .document(this.id)
          .collection('reports')
          .getDocuments()
          .then((querySnapshot) {
        querySnapshot.documents.forEach((doc) {
          doc.reference.delete();
        });
      });
      await Firestore.instance.collection('Answers').document(this.id).updateData({
        'reportCount': 0,
      });
      return true;
    } catch (e) {
      print('821__Answer__Answer.discardAllReports__classes.dart');
      print(e);
      return false;
    }
  }

  Future<bool> notifyAuthor() async {
    String adminId = await Constant.getCurrentUserDocId();
    AnswerRemovedNotification answerRemovedNotification = AnswerRemovedNotification(
        type: "AnswerRemoved",
        adminId: adminId,
        content: this.content.substring(0, 46) + "...",
        questionId: this.queID);
    await answerRemovedNotification.sendNotification(this.userId);
    return true;
  }
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

class Report {
  String comment;
  String reporter;
  List<String> violations;
  DateTime reportedOn;
  double weight;
  String id;

  Report({this.comment, this.reporter, this.violations, this.reportedOn, this.weight});

  Report.fromSnapshot(DocumentSnapshot snapshot) {
    this.reportedOn = (snapshot.data['reportedOn'] as Timestamp)?.toDate();
    this.comment = snapshot.data['comment'] as String;
    this.reporter = snapshot.data['reporter'] as String;
    this.violations = snapshot.data['violations']?.cast<String>();
    this.weight = snapshot.data['weight'] as double;
    this.id = snapshot.documentID;
  }

  ///Upload report to the sub-collection named "reports" in respective content document in firebase.
  ///
  ///[contentCollection]=='Questions' or [contentCollection]=='Articles' or [contentCollection]=='Answers'
  Future<bool> upload(String contentCollection, String docId) async {
    try {
      //Checking if user has already submitted a report
      bool submittedOnce = false;
      await Firestore.instance
          .collection(contentCollection + "/" + docId + "/reports")
          .where('reporter', isEqualTo: this.reporter)
          .getDocuments()
          .then((v) {
        if (v.documents.length > 0) {
          submittedOnce = true;
        }
      });

      if (submittedOnce == false) {
        DocumentReference reportDoc =
            await Firestore.instance.collection(contentCollection + "/" + docId + "/reports").add({
          'comment': this.comment,
          'violations': this.violations,
          'weight': this.weight,
          'reporter': this.reporter,
          'reportedOn': this.reportedOn,
        });
        await Firestore.instance
            .collection(contentCollection)
            .document(docId)
            .updateData({'reportCount': FieldValue.increment(1)});
        Constant.showToastSuccess("Your report has been submitted");
        notifyOffender(contentCollection, reportDoc.documentID, docId);
        return true;
      } else {
        Constant.showToastInstruction(
            "You have already submitted a report for this content earlier");
        return false;
      }
    } catch (e) {
      print('860__Report__Report.upload__classes.dart');
      print(e);
      return false;
    }
  }

  Future<bool> delete(String contentCollection, String docID) async {
    try {
      await Firestore.instance
          .collection(contentCollection)
          .document(docID)
          .collection('reports')
          .document(this.id)
          .delete();
      await Firestore.instance.collection(contentCollection).document(docID).updateData({
        'reportCount': FieldValue.increment(-1),
      });
      return true;
    } catch (e) {
      print('879__Report__Report.delete__classes.dart');
      print(e);
      return false;
    }
  }

  /// send the notification of content being reported to author of content
  Future<bool> notifyOffender(String contentType, String reportId, String contentId) async {
    switch (contentType) {
      case "Questions":
        {
          QuestionReportedNotification queReportNotification = QuestionReportedNotification(
            type: "QuestionReported",
            questionId: contentId,
            reportId: reportId,
          );
          queReportNotification.sendNotification();
          break;
        }
      case "Answers":
        {
          AnswerReportedNotification ansReportedNotification = AnswerReportedNotification(
            type: "AnswerReported",
            answerId: contentId,
            reportId: reportId,
          );
          ansReportedNotification.sendNotification();
          break;
        }
      case "Articles":
        {
          ArticleReportedNotification articleReportedNotification = ArticleReportedNotification(
            type: "ArticleReported",
            articleId: contentId,
            reportId: reportId,
          );
          articleReportedNotification.sendNotification();
          break;
        }
      default:
        break;
    }
    return true;
  }
}
