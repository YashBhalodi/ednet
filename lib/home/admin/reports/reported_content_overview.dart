import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:flutter/material.dart';

class ReportedContents extends StatelessWidget {
  final User admin;

  const ReportedContents({Key key, this.admin}) : super(key: key);

  Widget build(BuildContext context) {
      return Scrollbar(
          child: ListView(
              children: <Widget>[
                  ReportedQuestions(
                      admin: admin,
                  ),
                  ReportedAnswers(
                      admin: admin,
                  ),
                  ReportedArticles(
                      admin: admin,
                  ),
              ],
      ),
    );
  }
}

//TODO using a streamBuilder to fetch reported content of a single user and then making a list out of these.

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
                          maxLines: 1,
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

class ReportedAnswers extends StatefulWidget {
    final User admin;

    const ReportedAnswers({Key key, this.admin}) : super(key: key);

    @override
    _ReportedAnswersState createState() => _ReportedAnswersState();
}

class _ReportedAnswersState extends State<ReportedAnswers> with AutomaticKeepAliveClientMixin {
    Future<List<Answer>> loadAnswers() async {
        print("loadAnswers");
        List<String> _userList = [];
        List<Answer> _reportedAnswerList = [];
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
                .collection('Answers')
                .where('userid', isEqualTo: userID)
                .getDocuments()
                .then((answerQueryDoc) {
                answerQueryDoc.documents.forEach((ansDoc) {
                    if (ansDoc.data['reportCount'] > 0) {
                        _reportedAnswerList.add(Answer.fromSnapshot(ansDoc));
                    }
                });
            }).catchError((e) {
                print(e);
            });
        });
        //Sorting the questions in descending order of reportCount
        _reportedAnswerList.sort((a, b) {
            return a.reportCount.compareTo(b.reportCount);
        });
        return _reportedAnswerList;
    }

    @override
    Widget build(BuildContext context) {
        super.build(context);
        return ExpansionTile(
            title: Text(
                "Reported Answers",
                style: Theme
                           .of(context)
                           .brightness == Brightness.dark
                       ? DarkTheme.dropDownMenuTitleStyle
                       : LightTheme.dropDownMenuTitleStyle,
            ),
            children: <Widget>[
                FutureBuilder(
                    future: loadAnswers(),
                    builder: (context, snapshot) {
                        if (snapshot.hasData) {
                            return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, i) {
                                    Answer a = snapshot.data[i];
                                    return ListTile(
                                        title: Text(
                                            a.content,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                        ),
                                        trailing: Text(a.reportCount.toString()),
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

class ReportedArticles extends StatefulWidget {
    final User admin;

    const ReportedArticles({Key key, this.admin}) : super(key: key);

    @override
    _ReportedArticlesState createState() => _ReportedArticlesState();
}

class _ReportedArticlesState extends State<ReportedArticles> {
    Future<List<Article>> loadArticles() async {
        print("loadArticles");
        List<String> _userList = [];
        List<Article> _reportedArticleList = [];
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
                .collection('Articles')
                .where('userid', isEqualTo: userID)
                .getDocuments()
                .then((articleQueryDoc) {
                articleQueryDoc.documents.forEach((articleDoc) {
                    if (articleDoc.data['reportCount'] > 0) {
                        _reportedArticleList.add(Article.fromSnapshot(articleDoc));
                    }
                });
            }).catchError((e) {
                print(e);
            });
        });
        //Sorting the questions in descending order of reportCount
        _reportedArticleList.sort((a, b) {
            return a.reportCount.compareTo(b.reportCount);
        });
        return _reportedArticleList;
    }

    @override
    Widget build(BuildContext context) {
        return ExpansionTile(
            title: Text(
                "Reported Articles",
                style: Theme
                           .of(context)
                           .brightness == Brightness.dark
                       ? DarkTheme.dropDownMenuTitleStyle
                       : LightTheme.dropDownMenuTitleStyle,
            ),
            children: <Widget>[
                FutureBuilder(
                    future: loadArticles(),
                    builder: (context, snapshot) {
                        if (snapshot.hasData) {
                            //TODO messages if no content has been found
                            return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, i) {
                                    Article a = snapshot.data[i];
                                    return ListTile(
                                        title: Text(
                                            a.title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                        ),
                                        trailing: Text(a.reportCount.toString()),
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
}
