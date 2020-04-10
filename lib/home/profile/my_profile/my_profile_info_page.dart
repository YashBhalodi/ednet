import 'package:ednet/home/profile/my_profile/edit_details_profile.dart';
import 'package:ednet/home/profile/my_profile/university_topic_list.dart';
import 'package:ednet/home/profile/my_profile/user_topic_list.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/material.dart';

class MyProfile extends StatefulWidget {
  final User user;

  MyProfile({Key key, @required this.user}) : super(key: key);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "My Profile",
            style: Theme.of(context).brightness == Brightness.dark
                ? DarkTheme.appBarTextStyle
                : LightTheme.appBarTextStyle,
          ),
        ),
        body: Scrollbar(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              ExpansionTile(
                title: Text(
                  "Preview Profile",
                  style: Theme.of(context).brightness == Brightness.dark
                      ? DarkTheme.dropDownMenuTitleStyle
                      : LightTheme.dropDownMenuTitleStyle,
                ),
                initiallyExpanded: true,
                children: <Widget>[
                  ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: Constant.edgePadding,
                    children: <Widget>[
                      Text(
                        "How other users will see your profile...",
                        style: Theme.of(context).brightness == Brightness.dark
                            ? DarkTheme.headingDescriptionStyle
                            : LightTheme.headingDescriptionStyle,
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      BlueOutlineButton(
                        child: Text(
                          "My Profile",
                          style: Theme.of(context).brightness == Brightness.dark
                              ? DarkTheme.outlineButtonTextStyle
                              : LightTheme.outlineButtonTextStyle,
                        ),
                        callback: () {
                          Constant.userProfileView(context, userId: widget.user.id);
                        },
                      ),
                    ],
                  )
                ],
              ),
              EditDetailsTile(
                user: widget.user,
              ),
              widget.user.isAdmin
                  ? UniversityTopicListTile(
                      user: widget.user,
                    )
                  : UserTopicListTile(
                      user: widget.user,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}