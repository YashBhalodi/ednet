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

  QuestionPostedNotification(
      {String id, @required String type, @required this.questionId})
      : super(id: id, type: type);

  QuestionPostedNotification.fromJson(DocumentSnapshot snapshot) {
    this.id = snapshot.documentID;
    this.type = snapshot.data['type'];
    this.questionId = snapshot.data['questionID'];
  }

  Future<bool> sendNotification(DocumentReference questionDoc) async {
    try {
      DocumentSnapshot queSnap = await questionDoc.get();
      Question q = Question.fromSnapshot(queSnap);
      DocumentSnapshot authorDoc = await Firestore.instance.collection('Users').document(q.userId).get();
      User author = User.fromSnapshot(authorDoc);
      QuerySnapshot allUsers = await Firestore.instance.collection('Users').getDocuments();
      allUsers.documents.forEach((doc) async {
        //admins don't have personal topic preference so, we will exclude admin from receiving notifications relating to preference.
        //instead, admins will receive notification about all the content from their university
        User u = User.fromSnapshot(doc);
        if(u.isAdmin){
          //check if the author of question is from same university, if yes, send the notification
          if ((author.id != u.id) && (u.university == author.university)) {
            await Firestore.instance
                          .collection('Users')
                          .document(doc.documentID)
                          .collection('notifications')
                          .add({
                        "type": this.type,
                        "questionID": this.questionId,
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
            });
          }
        }
      });
      return true;
    } catch (e) {
      print(e);
      print('60__QuestionPostedNotification__QuestionPostedNotification.sendNotification__notification_classes.dart');
      return false;
    }
  }
}

class AnswerPostedNotification extends Notification {
  String answerId;

  AnswerPostedNotification(
      {String id, @required String type, @required this.answerId})
      : super(id: id, type: type);

  AnswerPostedNotification.fromJson(DocumentSnapshot snapshot) {
    this.id = snapshot.documentID;
    this.type = snapshot.data['type'];
    this.answerId = snapshot.data['answerID'];
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
