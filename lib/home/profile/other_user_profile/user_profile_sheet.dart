import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/profile/other_user_profile/explore_content.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/shimmer_widgets.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  final String userId;

  const UserProfile({Key key, @required this.userId}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool isExpanded = false;
  bool loadingDone = false;
  List<Question> questions = [];
  List<Article> articles = [];
  List<Answer> answers = [];

  Future<void> loadContent() async {
    QuerySnapshot quesDocs = await Firestore.instance
        .collection('Questions')
        .where('isDraft', isEqualTo: false)
        .where('userid', isEqualTo: widget.userId)
        .getDocuments();
    quesDocs.documents.forEach((doc) {
      questions.add(Question.fromSnapshot(doc));
    });
    QuerySnapshot articleDocs = await Firestore.instance
        .collection('Articles')
        .where('isDraft', isEqualTo: false)
        .where('userid', isEqualTo: widget.userId)
        .getDocuments();
    articleDocs.documents.forEach((doc) {
      articles.add(Article.fromSnapshot(doc));
    });
    QuerySnapshot answerDocs = await Firestore.instance
        .collection('Answers')
        .where('isDraft', isEqualTo: false)
        .where('userid', isEqualTo: widget.userId)
        .getDocuments();
    answerDocs.documents.forEach((doc) {
      answers.add(Answer.fromSnapshot(doc));
    });
    setState(() {
      loadingDone = true;
    });
  }

  @override
  void initState() {
    loadContent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('Users').document(widget.userId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          User user = User.fromSnapshot(snapshot.data);
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: Constant.edgePadding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          user.userName,
                          style: Theme.of(context).brightness == Brightness.dark
                              ? DarkTheme.headingStyle
                              : LightTheme.headingStyle,
                        ),
                        user.isProf
                            ? Icon(
                                Icons.star,
                                color: Colors.orangeAccent,
                                size: 24.0,
                              )
                            : Container(),
                      ],
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      user.fname + " " + user.lname,
                      style: Theme.of(context).brightness == Brightness.dark
                          ? DarkTheme.headingDescriptionStyle
                          : LightTheme.headingDescriptionStyle,
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(user.bio),
                    SizedBox(
                      height: 8.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        user.isProf
                            ? Text("Professor")
                            : (user.isAdmin ? Text("Admin") : Text("Student")),
                        Text(" @ " + user.university),
                      ],
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    user.isAdmin
                        ? Divider(
                            indent: 5.0,
                            endIndent: 5.0,
                          )
                        : Container(),
                    user.isAdmin
                        ? Padding(
                            padding: EdgeInsets.only(bottom: 4.0),
                            child: Text(
                              "Topics taught at ${user.university}",
                            ),
                          )
                        : Container(),
                    user.isAdmin
                        ? StreamBuilder(
                            stream: Firestore.instance
                                .collection('University')
                                .where('name', isEqualTo: user.university)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return ShimmerTopicTile();
                              } else {
                                University university =
                                    University.fromSnapshot(snapshot.data.documents[0]);
                                return SingleChildScrollView(
                                  padding: EdgeInsets.all(0.0),
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: List.generate(
                                      university.topics.length,
                                      (i) {
                                        return Padding(
                                          padding: const EdgeInsets.only(right: 4.0),
                                          child: Chip(
                                            label: Text(
                                              university.topics[i],
                                              style: Theme.of(context).brightness == Brightness.dark
                                                  ? DarkTheme.topicStyle
                                                  : LightTheme.topicStyle,
                                            ),
                                            backgroundColor:
                                                Theme.of(context).brightness == Brightness.dark
                                                    ? DarkTheme.chipBackgroundColor
                                                    : LightTheme.chipBackgroundColor,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              }
                            },
                          )
                        : SingleChildScrollView(
                            padding: EdgeInsets.all(0.0),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(user.topics.length, (i) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: Chip(
                                    label: Text(
                                      user.topics[i],
                                      style: Theme.of(context).brightness == Brightness.dark
                                          ? DarkTheme.topicStyle
                                          : LightTheme.topicStyle,
                                    ),
                                    backgroundColor: Theme.of(context).brightness == Brightness.dark
                                        ? DarkTheme.chipBackgroundColor
                                        : LightTheme.chipBackgroundColor,
                                  ),
                                );
                              }),
                            ),
                          ),
                    SizedBox(
                      height: 8.0,
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      child: BlueOutlineButton(
                        callback: () {
                          if (loadingDone) {
                            setState(() {
                              isExpanded = !isExpanded;
                            });
                          }
                        },
                        child: loadingDone
                            ? Text(
                                isExpanded ? "Hide Content" : "Explore Content",
                                style: Theme.of(context).brightness == Brightness.dark
                                    ? DarkTheme.secondaryHeadingTextStyle
                                    : LightTheme.secondaryHeadingTextStyle,
                              )
                            : SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              isExpanded
                  ? Expanded(
                      child: ExploreContent(
                        user: user,
                        answerList: answers,
                        articleList: articles,
                        questionList: questions,
                      ),
                    )
                  : Container(),
              //TODO implement AnimatedCrossFade properly
              /*Flexible(
                  fit: FlexFit.loose,
                  child: AnimatedCrossFade(
                    firstChild: ExploreContent(
                      user: user,
                    ),
                    secondChild: Container(
                      constraints: BoxConstraints.tight(
                        Size(
                          double.maxFinite,
                          0.0,
                        ),
                      ),
                    ),
                    sizeCurve: Curves.easeInOut,
                    duration: Duration(milliseconds: 700),
                    crossFadeState:
                        isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                  ),
                ),*/
            ],
          );
        } else {
          return SizedBox(
            height: 28.0,
            width: 28.0,
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
