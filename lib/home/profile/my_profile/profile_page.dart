import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/feed/answer/answer_thumb_card.dart';
import 'package:ednet/home/feed/article/article_thumb_card.dart';
import 'package:ednet/home/feed/question/question_thumb_card.dart';
import 'package:ednet/home/profile/my_profile/answer_draft_card.dart';
import 'package:ednet/home/profile/my_profile/article_draft_card.dart';
import 'package:ednet/home/profile/my_profile/question_draft_card.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final DocumentSnapshot userSnap;

  const ProfilePage({Key key, this.userSnap}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = User.fromSnapshot(widget.userSnap);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 5,
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              TabBar(
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                isScrollable: true,
                indicator: BoxDecoration(
                  color: Colors.blue,
                ),
                unselectedLabelColor: Colors.blue,
                tabs: <Widget>[
                  Tab(
                    text: "Profile",
                  ),
                  Tab(
                    text: "Questions",
                  ),
                  Tab(
                    text: "Articles",
                  ),
                  Tab(
                    text: "Answers",
                  ),
                  Tab(
                    text: "Drafts",
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    MyProfile(
                      user: currentUser,
                    ),
                    MyQuestions(
                      user: currentUser,
                    ),
                    MyArticles(
                      user: currentUser,
                    ),
                    MyAnswers(
                      user: currentUser,
                    ),
                    MyDrafts(
                      user: currentUser,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyProfile extends StatefulWidget {
  final User user;

  MyProfile({Key key, @required this.user}) : super(key: key);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  String _inputFname;
  String _inputLname;
  String _inputMobileNumber;
  TextEditingController _userNameController;
  String _userNameValidator;
  String _inputUsername;
  String _inputBio;
  bool _loading = false;
  GlobalKey<FormState> _userProfileFormKey = GlobalKey<FormState>();

  Future<bool> updateUserDetails() async {
    setState(() {
      _loading = true;
    });
    final FormState form = _userProfileFormKey.currentState;
    String response = await Constant.userNameAvailableValidator(_userNameController.text);
    setState(() {
      _userNameValidator = response;
    });
    if (form.validate()) {
      form.save();
      widget.user.bio = _inputBio;
      widget.user.fname = _inputFname;
      widget.user.lname = _inputLname;
      widget.user.userName = _inputUsername;
      widget.user.mobile = _inputMobileNumber;
      bool uploadSuccess = await widget.user.updateUser();
      if (uploadSuccess) {
        setState(() {
          _loading = false;
        });
        return true;
      } else {
        setState(() {
          _loading = false;
        });
        return false;
      }
    } else {
      setState(() {
        _loading = false;
      });
      return false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _userNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _userNameController = TextEditingController(text: widget.user.userName);
    //A special buttons for admin to take them to admin panel
    return Form(
      key: _userProfileFormKey,
      child: ListView(
        padding: Constant.edgePadding,
        shrinkWrap: true,
        children: <Widget>[
          Text(
            "Edit Details",
            style: Constant.sectionSubHeadingStyle,
          ),
          SizedBox(
            height: 32.0,
          ),
          TextFormField(
            onSaved: (value) {
              _inputFname = value;
            },
            initialValue: widget.user.fname,
            validator: (value) => Constant.nameValidator(value),
            keyboardType: TextInputType.text,
            style: Constant.formFieldTextStyle,
            enabled: false,
            decoration: InputDecoration(
              counterStyle: Constant.counterStyle,
              contentPadding: Constant.formFieldContentPadding,
              hintText: "John",
              hintStyle: Constant.formFieldHintStyle,
              border: Constant.formFieldBorder,
              focusedBorder: Constant.formFieldFocusedBorder,
              labelText: "First Name",
              labelStyle: Constant.formFieldLabelStyle,
            ),
          ),
          SizedBox(
            height: 32.0,
          ),
          TextFormField(
            onSaved: (value) {
              _inputLname = value;
            },
            initialValue: widget.user.lname,
            validator: (value) => Constant.nameValidator(value),
            keyboardType: TextInputType.text,
            style: Constant.formFieldTextStyle,
            decoration: InputDecoration(
              counterStyle: Constant.counterStyle,
              contentPadding: Constant.formFieldContentPadding,
              hintText: "Doe",
              hintStyle: Constant.formFieldHintStyle,
              border: Constant.formFieldBorder,
              focusedBorder: Constant.formFieldFocusedBorder,
              labelText: "Last Name",
              labelStyle: Constant.formFieldLabelStyle,
            ),
          ),
          SizedBox(
            height: 32.0,
          ),
          TextFormField(
            validator: (value) => Constant.mobileNumberValidator(value),
            onSaved: (value) {
              _inputMobileNumber = value;
            },
            initialValue: widget.user.mobile,
            maxLength: 10,
            style: Constant.formFieldTextStyle,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              counterStyle: Constant.counterStyle,
              contentPadding: Constant.formFieldContentPadding,
              hintText: "94578xxxx5",
              hintStyle: Constant.formFieldHintStyle,
              border: Constant.formFieldBorder,
              focusedBorder: Constant.formFieldFocusedBorder,
              labelText: "Mobile Number",
              labelStyle: Constant.formFieldLabelStyle,
            ),
          ),
          SizedBox(
            height: 32.0,
          ),
          TextFormField(
            controller: _userNameController,
            maxLength: 15,
            validator: (value) {
              return _userNameValidator;
            },
            onSaved: (value) {
              _inputUsername = value;
            },
            style: Constant.formFieldTextStyle,
            decoration: InputDecoration(
              counterStyle: Constant.counterStyle,
              contentPadding: Constant.formFieldContentPadding,
              hintText: "johnDoe12",
              hintStyle: Constant.formFieldHintStyle,
              border: Constant.formFieldBorder,
              focusedBorder: Constant.formFieldFocusedBorder,
              labelText: "Username",
              labelStyle: Constant.formFieldLabelStyle,
            ),
          ),
          SizedBox(
            height: 32.0,
          ),
          TextFormField(
            maxLength: 100,
            onSaved: (value) {
              _inputBio = value;
            },
            initialValue: widget.user.bio,
            minLines: 3,
            maxLines: 7,
            style: Constant.formFieldTextStyle,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              alignLabelWithHint: true,
              counterStyle: Constant.counterStyle,
              contentPadding: Constant.formFieldContentPadding,
              hintText: "Brief description about yourself...",
              hintStyle: Constant.formFieldHintStyle,
              border: Constant.formFieldBorder,
              focusedBorder: Constant.formFieldFocusedBorder,
              labelText: "Bio",
              labelStyle: Constant.formFieldLabelStyle,
            ),
          ),
          SizedBox(
            height: 32.0,
          ),
          PrimaryBlueCTA(
            callback: () async {
              FocusScope.of(context).unfocus();
              if (!_loading) {
                bool stat = await updateUserDetails();
                if (stat) {
                  Constant.showToastSuccess("Profile updated successfully");
                } else {
                  Constant.showToastError("Profile failed to update");
                }
              }
            },
            child: _loading
                ? SizedBox(
                    height: 24.0,
                    width: 24.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                      backgroundColor: Colors.blue[200],
                    ),
                  )
                : Text(
                    "Update Details",
                    style: Constant.primaryCTATextStyle,
                  ),
          ),
        ],
      ),
    );
  }
}

class MyQuestions extends StatelessWidget {
  final User user;

  const MyQuestions({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('Questions')
          .where('isDraft', isEqualTo: false)
          .where('userid', isEqualTo: user.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data.documents.length > 0) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, i) {
                Question q = Question.fromSnapshot(snapshot.data.documents[i]);
                return QuestionThumbCard(
                  question: q,
                );
              },
            );
          } else {
            return Padding(
              padding: Constant.sidePadding,
              child: Center(
                child: Text(
                  "You haven't asked any questions yet.\n\nStart feeding your curiosity.",
                  textAlign: TextAlign.center,
                  style: Constant.secondaryBlueTextStyle,
                ),
              ),
            );
          }
        } else {
          return Center(
            child: SizedBox(
              height: 32.0,
              width: 32.0,
              child: Constant.greenCircularProgressIndicator,
            ),
          );
        }
      },
    );
  }
}

class MyArticles extends StatelessWidget {
  final User user;

  const MyArticles({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('Articles')
          .where('isDraft', isEqualTo: false)
          .where('userid', isEqualTo: user.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data.documents.length > 0) {
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              shrinkWrap: true,
              itemBuilder: (context, i) {
                Article a = Article.fromSnapshot(snapshot.data.documents[i]);
                return ArticleThumbCard(
                  article: a,
                );
              },
            );
          } else {
            return Padding(
              padding: Constant.sidePadding,
              child: Center(
                child: Text(
                  "Strengthen your knowledge by sharing.",
                  textAlign: TextAlign.center,
                  style: Constant.secondaryBlueTextStyle,
                ),
              ),
            );
          }
        } else {
          return Center(
            child: SizedBox(
              height: 32.0,
              width: 32.0,
              child: Constant.greenCircularProgressIndicator,
            ),
          );
        }
      },
    );
  }
}

class MyAnswers extends StatelessWidget {
  final User user;

  const MyAnswers({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('Answers')
          .where('isDraft', isEqualTo: false)
          .where('userid', isEqualTo: user.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data.documents.length > 0) {
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              shrinkWrap: true,
              itemBuilder: (context, i) {
                Answer a = Answer.fromSnapshot(snapshot.data.documents[i]);
                return AnswerThumbCard(
                  answer: a,
                );
              },
            );
          } else {
            return Padding(
              padding: Constant.sidePadding,
              child: Center(
                child: Text(
                  "You haven't answered any questions yet.\n\nSomeone might be looking forward to your contribution.",
                  textAlign: TextAlign.center,
                  style: Constant.secondaryBlueTextStyle,
                ),
              ),
            );
          }
        } else {
          return Center(
            child: SizedBox(
              height: 32.0,
              width: 32.0,
              child: Constant.greenCircularProgressIndicator,
            ),
          );
        }
      },
    );
  }
}

class MyDrafts extends StatelessWidget {
  final User user;

  const MyDrafts({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(vertical: 16.0),
      children: <Widget>[
        Padding(
          padding: Constant.sidePadding,
          child: Text(
            "Questions",
            style: Constant.sectionSubHeadingStyle,
          ),
        ),
        StreamBuilder(
          stream: Firestore.instance
              .collection('Questions')
              .where('isDraft', isEqualTo: true)
              .where('userid', isEqualTo: user.id)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data.documents.length > 0) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, i) {
                    Question q = Question.fromSnapshot(snapshot.data.documents[i]);
                    return QuestionDraftCard(
                      question: q,
                    );
                  },
                );
              } else {
                return Padding(
                  padding: Constant.edgePadding,
                  child: Center(
                    child: Text(
                      "You don't have any draft questions so far.\n\nCongratulations.",
                      textAlign: TextAlign.center,
                      style: Constant.secondaryBlueTextStyle,
                    ),
                  ),
                );
              }
            } else {
              return Center(
                child: SizedBox(
                  height: 32.0,
                  width: 32.0,
                  child: Constant.greenCircularProgressIndicator,
                ),
              );
            }
          },
        ),
        Divider(
          endIndent: 24.0,
          indent: 24.0,
        ),
        SizedBox(
          height: 16.0,
        ),
        Padding(
          padding: Constant.sidePadding,
          child: Text(
            "Articles",
            style: Constant.sectionSubHeadingStyle,
          ),
        ),
        StreamBuilder(
          stream: Firestore.instance
              .collection('Articles')
              .where('isDraft', isEqualTo: true)
              .where('userid', isEqualTo: user.id)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data.documents.length > 0) {
                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, i) {
                    Article a = Article.fromSnapshot(snapshot.data.documents[i]);
                    return ArticleDraftCard(
                      article: a,
                    );
                  },
                );
              } else {
                return Padding(
                  padding: Constant.edgePadding,
                  child: Center(
                    child: Text(
                      "Wow!\nNo draft article pending to publish!\n\nWhen are you planning for next?",
                      textAlign: TextAlign.center,
                      style: Constant.secondaryBlueTextStyle,
                    ),
                  ),
                );
              }
            } else {
              return Center(
                child: SizedBox(
                  height: 32.0,
                  width: 32.0,
                  child: Constant.greenCircularProgressIndicator,
                ),
              );
            }
          },
        ),
        Divider(
          endIndent: 24.0,
          indent: 24.0,
        ),
        SizedBox(
          height: 16.0,
        ),
        Padding(
          padding: Constant.sidePadding,
          child: Text(
            "Answers",
            style: Constant.sectionSubHeadingStyle,
          ),
        ),
        StreamBuilder(
          stream: Firestore.instance
              .collection('Answers')
              .where('isDraft', isEqualTo: true)
              .where('userid', isEqualTo: user.id)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data.documents.length > 0) {
                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, i) {
                    Answer a = Answer.fromSnapshot(snapshot.data.documents[i]);
                    return AnswerDraftCard(
                      answer: a,
                    );
                  },
                );
              } else {
                return Padding(
                  padding: Constant.edgePadding,
                  child: Center(
                    child: Text(
                      "WhooHoo!\n\nNo draft answer to write up.",
                      textAlign: TextAlign.center,
                      style: Constant.secondaryBlueTextStyle,
                    ),
                  ),
                );
              }
            } else {
              return Center(
                child: SizedBox(
                  height: 32.0,
                  width: 32.0,
                  child: Constant.greenCircularProgressIndicator,
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
