import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

class Notification {
  String id;
  String type;

  Notification({@required this.type, @required this.id});

  /// Dismiss/Remove the current notification
  Future<void> remove() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentReference notificationDocRef = Firestore.instance
        .collection('Users')
        .document(user.uid)
        .collection('notifications')
        .document(this.id);
    await notificationDocRef.delete();
  }
}

class QuestionPostedNotification extends Notification {
  String questionId;
  String quesAuthorId;

  QuestionPostedNotification(
      {String id, @required String type, @required this.questionId, @required this.quesAuthorId})
      : super(id: id, type: type);

  QuestionPostedNotification.fromJson(DocumentSnapshot snapshot) {
    this.id = snapshot.documentID;
    this.type = snapshot.data['type'];
    this.questionId = snapshot.data['questionID'];
    this.quesAuthorId = snapshot.data['quesAuthorID'];
  }

  Future<bool> deliverPayload(String userId) async {
    await Firestore.instance.collection('Users').document(userId).collection('notifications').add({
      "type": this.type,
      "questionID": this.questionId,
      "quesAuthorID": this.quesAuthorId,
    });
    return true;
  }

  /// send notifications to concerned university admin and all users who are interested in at least one topic of the question
  Future<bool> sendNotification(DocumentReference questionDoc) async {
    try {
      DocumentSnapshot queSnap = await questionDoc.get();
      Question q = Question.fromSnapshot(queSnap);
      DocumentSnapshot authorDoc =
          await Firestore.instance.collection('Users').document(q.userId).get();
      User author = User.fromSnapshot(authorDoc);
      QuerySnapshot allUsers = await Firestore.instance.collection('Users').getDocuments();
      allUsers.documents.forEach((doc) async {
        //admins will receive notification about all the content from their university
        User u = User.fromSnapshot(doc);
        if (u.isAdmin) {
          //check if the author of question is from same university, if yes, send the notification
          if ((author.id != u.id) && (u.university == author.university)) {
            await deliverPayload(doc.documentID);
          }
        } else {
          //check if the user is interested in this topic
          bool userInterested = q.topics.any((qt) => u.topics.contains(qt));
          if (doc.documentID != q.userId && userInterested) {
            await deliverPayload(doc.documentID);
          }
        }
      });
      return true;
    } catch (e) {
      print(e);
      print(
          '60__QuestionPostedNotification__QuestionPostedNotification.sendNotification__notification_classes.dart');
      return false;
    }
  }
}

class AnswerPostedNotification extends Notification {
  String answerId;
  String questionId;
  String ansAuthorId;

  AnswerPostedNotification(
      {String id,
      @required String type,
      @required this.answerId,
      @required this.questionId,
      @required this.ansAuthorId})
      : super(id: id, type: type);

  AnswerPostedNotification.fromJson(DocumentSnapshot snapshot) {
    this.id = snapshot.documentID;
    this.type = snapshot.data['type'];
    this.answerId = snapshot.data['answerID'];
    this.questionId = snapshot.data['questionID'];
    this.ansAuthorId = snapshot.data['ansAuthorID'];
  }

  Future<bool> deliverPayload(String userId) async {
    await Firestore.instance.collection('Users').document(userId).collection('notifications').add({
      "type": this.type,
      "questionID": this.questionId,
      "answerID": this.answerId,
      "ansAuthorID": this.ansAuthorId,
    });
    return true;
  }

  /// send notification to the question author, admin concerned with answer author and users who has shown interest in the question by up-voting it.
  Future<bool> sendNotification() async {
    try {
      DocumentSnapshot authorDoc =
          await Firestore.instance.collection('Users').document(ansAuthorId).get();
      User author = User.fromSnapshot(authorDoc);
      //this notification will be sent to question author and university admins and question upvoters
      //sending notification to question author
      DocumentSnapshot queDoc =
          await Firestore.instance.collection('Questions').document(this.questionId).get();
      Question q = Question.fromSnapshot(queDoc);
      await deliverPayload(q.userId);
      //sending notification to question upvoters
      q.upvoters.forEach((upVoter) async {
        if (upVoter != ansAuthorId) {
          await deliverPayload(upVoter);
        }
      });
      //sending notification to concerned admins
      QuerySnapshot allValidAdmin = await Firestore.instance
          .collection('Users')
          .where('isAdmin', isEqualTo: true)
          .where('university', isEqualTo: author.university)
          .getDocuments();
      allValidAdmin.documents.forEach((doc) async {
        if (doc.documentID != ansAuthorId) {
          await deliverPayload(doc.documentID);
        }
      });
      return true;
    } catch (e) {
      print(
          '168__AnswerPostedNotification__AnswerPostedNotification.sendNotification__notification_classes.dart');
      print(e);
      return false;
    }
  }
}

class ArticlePostedNotification extends Notification {
  String articleId;
  String authorId;

  ArticlePostedNotification(
      {String id, @required String type, @required this.articleId, @required this.authorId})
      : super(id: id, type: type);

  ArticlePostedNotification.fromJson(DocumentSnapshot snapshot) {
    this.id = snapshot.documentID;
    this.type = snapshot.data['type'];
    this.articleId = snapshot.data['articleID'];
    this.authorId = snapshot.data['authorID'];
  }

  Future<bool> deliverPayload(String userId) async {
    await Firestore.instance.collection('Users').document(userId).collection('notifications').add({
      "type": this.type,
      "authorID": this.authorId,
      "articleID": this.articleId,
    });
    return true;
  }

  /// send notification to concerned admin and users interested in article's topic
  Future<bool> sendNotification(DocumentReference articleDoc) async {
    DocumentSnapshot authorSnap =
        await Firestore.instance.collection('Users').document(this.authorId).get();
    User author = User.fromSnapshot(authorSnap);
    DocumentSnapshot articleSnap = await articleDoc.get();
    Article a = Article.fromSnapshot(articleSnap);
    QuerySnapshot allUsers = await Firestore.instance.collection('Users').getDocuments();
    allUsers.documents.forEach((userDoc) async {
      User u = User.fromSnapshot(userDoc);
      if (u.isAdmin) {
        if (u.university == author.university && u.id != author.id) {
          await deliverPayload(u.id);
        }
      } else {
        if (u.id != authorId) {
          bool userInterested = a.topics.any((at) => u.topics.contains(at));
          if (userInterested) {
            await deliverPayload(u.id);
          }
        }
      }
    });
    return true;
  }
}

class QuestionReportedNotification extends Notification {
  String questionId;
  String reportId;

  QuestionReportedNotification(
      {String id, @required String type, @required this.questionId, @required this.reportId})
      : super(id: id, type: type);

  QuestionReportedNotification.fromJson(DocumentSnapshot snapshot) {
    this.id = snapshot.documentID;
    this.type = snapshot.data['type'];
    this.questionId = snapshot.data['questionID'];
    this.reportId = snapshot.data['reportID'];
  }

  Future<bool> deliverPayload(String userId) async {
    await Firestore.instance.collection('Users').document(userId).collection('notifications').add({
      "type": this.type,
      "questionID": this.questionId,
      "reportID": this.reportId,
    });
    return true;
  }

  Future<bool> sendNotification() async {
    DocumentSnapshot questionSnap =
        await Firestore.instance.collection('Questions').document(questionId).get();
    Question q = Question.fromSnapshot(questionSnap);
    await deliverPayload(q.userId);
    return true;
  }
}

class AnswerReportedNotification extends Notification {
  String answerId;
  String reportId;

  AnswerReportedNotification(
      {String id, @required String type, @required this.answerId, @required this.reportId})
      : super(id: id, type: type);

  AnswerReportedNotification.fromJson(DocumentSnapshot snapshot) {
    this.id = snapshot.documentID;
    this.type = snapshot.data['type'];
    this.answerId = snapshot.data['answerID'];
    this.reportId = snapshot.data['reportID'];
  }

  Future<bool> deliverPayload(String userId) async {
    await Firestore.instance.collection('Users').document(userId).collection('notifications').add({
      "type": this.type,
      "answerID": this.answerId,
      "reportID": this.reportId,
    });
    return true;
  }

  Future<bool> sendNotification() async {
    DocumentSnapshot answerSnap =
        await Firestore.instance.collection('Answers').document(answerId).get();
    Answer a = Answer.fromSnapshot(answerSnap);
    await deliverPayload(a.userId);
    return true;
  }
}

class ArticleReportedNotification extends Notification {
  String articleId;
  String reportId;

  ArticleReportedNotification(
      {String id, @required String type, @required this.articleId, @required this.reportId})
      : super(id: id, type: type);

  ArticleReportedNotification.fromJson(DocumentSnapshot snapshot) {
    this.id = snapshot.documentID;
    this.type = snapshot.data['type'];
    this.articleId = snapshot.data['articleID'];
    this.reportId = snapshot.data['reportID'];
  }

  Future<bool> deliverPayload(String userId) async {
    await Firestore.instance.collection('Users').document(userId).collection('notifications').add({
      "type": this.type,
      "articleID": this.articleId,
      "reportID": this.reportId,
    });
    return true;
  }

  Future<bool> sendNotification() async {
    DocumentSnapshot articleSnap =
        await Firestore.instance.collection('Articles').document(articleId).get();
    Article a = Article.fromSnapshot(articleSnap);
    await deliverPayload(a.userId);
    return true;
  }
}

class AnswerRemovedNotification extends Notification {
  String adminId;
  String content;
  String questionId;

  AnswerRemovedNotification(
      {String id,
      @required String type,
      @required this.adminId,
      @required this.content,
      @required this.questionId})
      : super(id: id, type: type);

  AnswerRemovedNotification.fromJson(DocumentSnapshot snapshot) {
    this.id = snapshot.documentID;
    this.type = snapshot.data['type'];
    this.adminId = snapshot.data['adminID'];
    this.content = snapshot.data['content'];
    this.questionId = snapshot.data['questionID'];
  }

  Future<bool> deliverPayload(String userId) async {
    await Firestore.instance.collection('Users').document(userId).collection('notifications').add({
      "type": this.type,
      "adminID": this.adminId,
      "content": this.content,
      "questionID": this.questionId,
    });
    return true;
  }

  Future<bool> sendNotification(String authorId) async {
    await deliverPayload(authorId);
    return true;
  }
}

class QuestionRemovedNotification extends Notification {
  String content;
  String adminId;

  QuestionRemovedNotification(
      {String id, @required String type, @required this.content, @required this.adminId})
      : super(id: id, type: type);

  QuestionRemovedNotification.fromJson(DocumentSnapshot snapshot) {
    this.id = snapshot.documentID;
    this.type = snapshot.data['type'];
    this.adminId = snapshot.data['adminID'];
    this.content = snapshot.data['content'];
  }

  Future<bool> deliverPayload(String userId) async {
    await Firestore.instance.collection('Users').document(userId).collection('notifications').add({
      "type": this.type,
      "adminID": this.adminId,
      "content": this.content,
    });
    return true;
  }

  Future<bool> sendNotification(String authorId) async {
    await deliverPayload(authorId);
    return true;
  }
}

class ArticleRemovedNotification extends Notification {
  String content;
  String adminId;

  ArticleRemovedNotification(
      {String id, @required String type, @required this.content, @required this.adminId})
      : super(id: id, type: type);

  ArticleRemovedNotification.fromJson(DocumentSnapshot snapshot) {
    this.id = snapshot.documentID;
    this.type = snapshot.data['type'];
    this.adminId = snapshot.data['adminID'];
    this.content = snapshot.data['content'];
  }

  Future<bool> deliverPayload(String userId) async {
    await Firestore.instance.collection('Users').document(userId).collection('notifications').add({
      "type": this.type,
      "adminID": this.adminId,
      "content": this.content,
    });
    return true;
  }

  Future<bool> sendNotification(String authorId) async {
    await deliverPayload(authorId);
    return true;
  }
}

enum NotificationType {
  QuestionPosted,
  AnswerPosted,
  ArticlePosted,
  QuestionReported,
  AnswerReported,
  ArticleReported,
  AnswerRemoved,
  QuestionRemoved,
  ArticleRemoved,
}
