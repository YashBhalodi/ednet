import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/profile/my_profile/my_drafts_page.dart';
import 'package:ednet/home/profile/my_profile/my_profile_info_page.dart';
import 'package:ednet/home/profile/other_user_profile/user_answers_page.dart';
import 'package:ednet/home/profile/other_user_profile/user_articles_page.dart';
import 'package:ednet/home/profile/other_user_profile/user_questions_page.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:flutter/foundation.dart';
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
        length: 2,
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              TabBar(
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                isScrollable: false,
                indicator: BoxDecoration(
                  color: Colors.blue,
                ),
                unselectedLabelColor: Colors.blue,
                tabs: <Widget>[
                  Tab(
                    text: "Profile",
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
