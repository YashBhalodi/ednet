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
            await Firestore.instance
                .collection('Users')
                .document(doc.documentID)
                .collection('notifications')
                .add({
              "type": this.type,
              "questionID": this.questionId,
              "quesAuthorID": this.quesAuthorId,
            });
          }
        } else {
          //check if the user is interested in this topic
          bool userInterested = q.topics.any((qt) => u.topics.contains(qt));
          if (doc.documentID != q.userId && userInterested) {
            await Firestore.instance
                .collection('Users')
                .document(doc.documentID)
                .collection('notifications')
                .add({
              "type": this.type,
              "questionID": this.questionId,
              "quesAuthorID": this.quesAuthorId,
            });
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

  /// send notification to the question author, admin concerned with answer author and users who has shown interest in the question by up-voting it.
  Future<bool> sendNotification(DocumentReference ansDoc) async {
    try {
      DocumentSnapshot authorDoc =
              await Firestore.instance.collection('Users').document(ansAuthorId).get();
      User author = User.fromSnapshot(authorDoc);
      //this notification will be sent to question author and university admins and question upvoters
      //sending notification to question author
      DocumentSnapshot queDoc = await Firestore.instance.collection('Questions').document(this.questionId).get();
      Question q = Question.fromSnapshot(queDoc);
      await Firestore.instance
              .collection('Users')
              .document(q.userId)
              .collection('notifications')
              .add({
            "type": this.type,
            "questionID": this.questionId,
            "answerID": this.answerId,
            "ansAuthorID": this.ansAuthorId,
          });
      //sending notification to question upvoters
      q.upvoters.forEach((upVoter) async {
            if(upVoter != ansAuthorId) {
              await Firestore.instance
                  .collection('Users')
                  .document(upVoter)
                  .collection('notifications')
                  .add({
                "type": this.type,
                "questionID": this.questionId,
                "answerID": this.answerId,
                "ansAuthorID": this.ansAuthorId,
              });
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
              await Firestore.instance
                        .collection('Users')
                        .document(doc.documentID)
                        .collection('notifications')
                        .add({
                      "type": this.type,
                      "questionID": this.questionId,
                      "answerID": this.answerId,
                      "ansAuthorID": this.ansAuthorId,
                    });
            }
          });
      return true;
    } catch (e) {
      print('168__AnswerPostedNotification__AnswerPostedNotification.sendNotification__notification_classes.dart');
      print(e);
      return false;
    }
  }
}

enum NotificationType {
  QuestionPosted,
  AnswerPosted,
  ArticlePosted,
  ContentUpvoted,
  ContentDownvoted,
  ContentReported,
  ContentRemoved,
}
