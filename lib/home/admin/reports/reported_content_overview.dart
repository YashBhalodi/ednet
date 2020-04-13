import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:flutter/material.dart';

class ReportedContents extends StatefulWidget {
  final User admin;

  const ReportedContents({Key key, this.admin}) : super(key: key);

  @override
  _ReportedContentsState createState() => _ReportedContentsState();
}

class _ReportedContentsState extends State<ReportedContents> {
  GlobalKey _questionKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _questionKey.currentState.build(context);
      },
      child: Scrollbar(
        child: ListView(
          children: <Widget>[
            ReportedQuestions(key: _questionKey, admin: widget.admin),
          ],
        ),
      ),
    );
  }
}

class ReportedQuestions extends StatefulWidget {
  final User admin;

  const ReportedQuestions({Key key, this.admin}) : super(key: key);

  @override
  _ReportedQuestionsState createState() => _ReportedQuestionsState();
}

class _ReportedQuestionsState extends State<ReportedQuestions> with AutomaticKeepAliveClientMixin {
  Future<List<Question>> loadQuestion() async {
    print("loadQuestion");
    List<String> _userList = [];
    List<Question> _reportedQuestionList = [];
    await Firestore.instance
        .collection('Users')
        .where('university', isEqualTo: widget.admin.university)
        .getDocuments()
        .then((userQueryDoc) {
      userQueryDoc.documents.forEach((doc) {
        _userList.add(doc.documentID);
      });
    });
    _userList.forEach((userID) async {
      await Firestore.instance
          .collection('Questions')
          .where('userid', isEqualTo: userID)
          .getDocuments()
          .then((questionQueryDoc) {
        questionQueryDoc.documents.forEach((queDoc) {
          if (queDoc.data['reportCount'] > 0) {
            _reportedQuestionList.add(Question.fromSnapshot(queDoc));
          }
        });
      }).catchError((e) {
        print(e);
      });
    });
    //Sorting the questions in descending order of reportCount
    _reportedQuestionList.sort((a, b) {
      return a.reportCount.compareTo(b.reportCount);
    });
    return _reportedQuestionList;
  }

  @override
  void initState() {
//    loadQuestion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ExpansionTile(
      title: Text(
        "Reported Questions",
        style: Theme.of(context).brightness == Brightness.dark
            ? DarkTheme.dropDownMenuTitleStyle
            : LightTheme.dropDownMenuTitleStyle,
      ),
      children: <Widget>[
        FutureBuilder(
          future: loadQuestion(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, i) {
                    Question q = snapshot.data[i];
                    return ListTile(
                      title: Text(
                        q.heading,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(q.reportCount.toString()),
                    );
                  });
            } else {
              //TODO Shimmer widget
              return Container(
                height: 40.0,
                child: Center(
                  child: SizedBox(
                    height: 18.0,
                    width: 18.0,
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
