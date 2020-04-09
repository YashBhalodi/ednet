import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/profile/other_user_profile/explore_content.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UserProfile extends StatefulWidget {
  final String userId;

  const UserProfile({Key key, @required this.userId}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool isExpanded = false;

  //TODO FIX dragging bottomsheet rebuilds all its children, causing the streambuilder to fire again
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
                        style: Theme
                                   .of(context)
                                   .brightness == Brightness.dark
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
                                  return Shimmer.fromColors(
                                    child: Container(
                                      width: double.maxFinite,
                                      height: 32.0,
                                      color: Colors.white,
                                    ),
                                    baseColor: Colors.grey[100],
                                    highlightColor: Colors.grey[400],
                                    period: Duration(milliseconds: 400),
                                  );
                                } else {
                                  University university =
                                      University.fromSnapshot(snapshot.data.documents[0]);
                                  return SingleChildScrollView(
                                    padding: EdgeInsets.all(0.0),
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: List.generate(university.topics.length, (i) {
                                        return Padding(
                                          padding: const EdgeInsets.only(right: 4.0),
                                          child: Chip(
                                            label: Text(
                                              university.topics[i],
                                              style: Constant.topicStyle,
                                            ),
                                            backgroundColor: Theme.of(context).brightness == Brightness.dark
                                                             ? DarkTheme.chipBackgroundColor
                                                             : LightTheme.chipBackgroundColor,
                                          ),
                                        );
                                      }),
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
                                        style: Constant.topicStyle,
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
