import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/admin/reports/answer_report_review.dart';
import 'package:ednet/home/admin/reports/article_report_review.dart';
import 'package:ednet/home/admin/reports/question_report_review.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:flutter/material.dart';

class ReportedContents extends StatefulWidget {
  final User admin;

  const ReportedContents({Key key, this.admin}) : super(key: key);

  @override
  _ReportedContentsState createState() => _ReportedContentsState();
}

class _ReportedContentsState extends State<ReportedContents> with AutomaticKeepAliveClientMixin {
  List<String> _userList = [];
  bool _isLoading = false;

  Future<void> loadUserList() async {
    _userList = [];
    setState(() {
      _isLoading = true;
    });
    await Firestore.instance
        .collection('Users')
        .where('university', isEqualTo: widget.admin.university)
        .getDocuments()
        .then((queryDoc) {
      queryDoc.documents.forEach((userDoc) {
        _userList.add(userDoc.documentID);
      });
    }).catchError((e) {
      print(e);
    });
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> reload() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadUserList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _isLoading
           ? Center(
      child: CircularProgressIndicator(),
    )
           : Scrollbar(
      child: ListView(
        children: <Widget>[
                ReportedQuestions(
                  userList: _userList,
                  parentRebuildCallback: reload,
                ),
                ReportedAnswers(
                  userList: _userList,
                  parentRebuildCallback: reload,
                ),
                ReportedArticles(
                  userList: _userList,
                  parentRebuildCallback: reload,
                ),
          const SizedBox(height: 60,),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

//TODO FIX snapshots aren't updated realtime
//TODO no reports messages

class ReportedQuestions extends StatelessWidget {
  final List<String> userList;
  final Function parentRebuildCallback;

  const ReportedQuestions({Key key, this.userList, this.parentRebuildCallback}) : super(key: key);

  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: true,
      title: Text(
        "Reported Questions",
        style: Theme
                   .of(context)
                   .brightness == Brightness.dark
               ? DarkTheme.dropDownMenuTitleStyle
               : LightTheme.dropDownMenuTitleStyle,
      ),
      children: userList.map((userId) {
        return StreamBuilder(
          stream: Firestore.instance
              .collection('Questions')
              .where('userid', isEqualTo: userId)
              .where('reportCount', isGreaterThan: 0)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (_, i) {
                    Question q = Question.fromSnapshot(snapshot.data.documents[i]);
                    //TODO improve UI
                    return ListTile(
                      title: Text(
                        q.heading,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                        q.reportCount.toString(),
                        style: Theme
                                   .of(context)
                                   .brightness == Brightness.dark
                               ? DarkTheme.secondaryNegativeTextStyle
                               : LightTheme.secondaryNegativeTextStyle,
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return QuestionReportsReviewPage(
                                question: q,
                                parentRebuildCallback: parentRebuildCallback,
                              );
                            },
                          ),
                        );
                      },
                    );
                  });
            } else {
              return Container();
            }
          },
        );
      }).toList(),
    );
  }
}

class ReportedAnswers extends StatelessWidget {
  final List<String> userList;
  final Function parentRebuildCallback;

  const ReportedAnswers({Key key, this.userList, this.parentRebuildCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: true,
      title: Text(
        "Reported Answers",
        style: Theme
                   .of(context)
                   .brightness == Brightness.dark
               ? DarkTheme.dropDownMenuTitleStyle
               : LightTheme.dropDownMenuTitleStyle,
      ),
      children: userList.map((userId) {
        return StreamBuilder(
          stream: Firestore.instance
              .collection('Answers')
              .where('userid', isEqualTo: userId)
              .where('reportCount', isGreaterThan: 0)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (_, i) {
                    Answer a = Answer.fromSnapshot(snapshot.data.documents[i]);
                    //TODO improve UI
                    return ListTile(
                      title: Text(
                        a.content,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                        a.reportCount.toString(),
                        style: Theme
                                   .of(context)
                                   .brightness == Brightness.dark
                               ? DarkTheme.secondaryNegativeTextStyle
                               : LightTheme.secondaryNegativeTextStyle,
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return AnswerReportsReviewPage(
                                answer: a,
                                parentRebuildCallback: parentRebuildCallback,
                              );
                            },
                          ),
                        );
                      },
                    );
                  });
            } else {
              return Container();
            }
          },
        );
      }).toList(),
    );
  }
}

class ReportedArticles extends StatelessWidget {
  final List<String> userList;
  final Function parentRebuildCallback;

  const ReportedArticles({Key key, this.userList, this.parentRebuildCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: true,
      title: Text(
        "Reported Articles",
        style: Theme
                   .of(context)
                   .brightness == Brightness.dark
               ? DarkTheme.dropDownMenuTitleStyle
               : LightTheme.dropDownMenuTitleStyle,
      ),
      children: userList.map((userId) {
        return StreamBuilder(
          stream: Firestore.instance
              .collection('Articles')
              .where('userid', isEqualTo: userId)
              .where('reportCount', isGreaterThan: 0)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (_, i) {
                    Article a = Article.fromSnapshot(snapshot.data.documents[i]);
                    //TODO improve UI
                    return ListTile(
                      title: Text(
                        a.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                        a.reportCount.toString(),
                        style: Theme
                                   .of(context)
                                   .brightness == Brightness.dark
                               ? DarkTheme.secondaryNegativeTextStyle
                               : LightTheme.secondaryNegativeTextStyle,
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return ArticleReportsReviewPage(
                                article: a,
                                parentRebuildCallback: parentRebuildCallback,
                              );
                            },
                          ),
                        );
                      },
                    );
                  });
            } else {
              return Container();
            }
          },
        );
      }).toList(),
    );
  }
}
