import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/profile/other_user_profile/explore_content.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  final String userId;

  const UserProfile({Key key, @required this.userId}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool isExpanded = false;

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
                            style: Constant.sectionSubHeadingStyle,
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
                        style: Constant.sectionSubHeadingDescriptionStyle,
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
                      SingleChildScrollView(
                        padding: EdgeInsets.all(0.0),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(user.topics.length, (i) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: Chip(
                                label: Text(
                                  user.topics[i],
                                  style: Constant.topicStyle,
                                ),
                                backgroundColor: Colors.grey[300],
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
                        child: RaisedButton(
                          onPressed: () {
                            setState(() {
                              isExpanded = !isExpanded;
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            side: BorderSide(color: Colors.blue[500], width: 2.0),
                          ),
                          color: Colors.white,
                          padding: Constant.raisedButtonPaddingMedium,
                          child: Text(
                            isExpanded ? "Hide Content" : "Explore Content",
                            style: Constant.secondaryBlueTextStyle,
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
        });
  }
}
