import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:flutter/material.dart';

class AdminUsersList extends StatelessWidget {
  final User admin;

  const AdminUsersList({Key key, this.admin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView(
        //TODO radial stat summary of how many fractions of total students, profs have signed up.
        children: <Widget>[
          ProfileSetStudents(
            admin: admin,
          ),
          ProfileSetProfs(
            admin: admin,
          ),
        ],
      ),
    );
  }
}

class ProfileSetStudents extends StatelessWidget {
  final User admin;

  const ProfileSetStudents({Key key, this.admin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        "Signed Up Students",
        style: Theme.of(context).brightness == Brightness.dark
            ? DarkTheme.dropDownMenuTitleStyle
            : LightTheme.dropDownMenuTitleStyle,
      ),
      children: <Widget>[
        StreamBuilder(
          stream: Firestore.instance
              .collection('Users')
              .where('university', isEqualTo: admin.university)
              .where('isProfileSet', isEqualTo: true)
              .where('isProf', isEqualTo: false)
              .where('isAdmin', isEqualTo: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.documents.length == 0) {
                return Text(
                  "No students from ${admin.university} has finished sign up procedure yet.",
                  style: Theme.of(context).brightness == Brightness.dark
                      ? DarkTheme.headingDescriptionStyle
                      : LightTheme.headingDescriptionStyle,
                );
              } else {
                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (_, i) {
                    User u = User.fromSnapshot(snapshot.data.documents[i]);
                    return ListTile(
                      title: Text(u.userName),
                      onTap: () {
                        Constant.userProfileView(context, userId: u.id);
                      },
                    );
                  },
                );
              }
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }
}

class ProfileSetProfs extends StatelessWidget {
  final User admin;

  const ProfileSetProfs({Key key, this.admin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        "Signed Up Professors",
        style: Theme.of(context).brightness == Brightness.dark
            ? DarkTheme.dropDownMenuTitleStyle
            : LightTheme.dropDownMenuTitleStyle,
      ),
      children: <Widget>[
        StreamBuilder(
          stream: Firestore.instance
              .collection('Users')
              .where('university', isEqualTo: admin.university)
              .where('isProfileSet', isEqualTo: true)
              .where('isProf', isEqualTo: true)
              .where('isAdmin', isEqualTo: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.documents.length == 0) {
                return Text(
                  "No professors from ${admin.university} has finished sign up procedure yet.",
                  style: Theme.of(context).brightness == Brightness.dark
                      ? DarkTheme.headingDescriptionStyle
                      : LightTheme.headingDescriptionStyle,
                );
              } else {
                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (_, i) {
                    User u = User.fromSnapshot(snapshot.data.documents[i]);
                    return ListTile(
                      title: Text(u.userName),
                      onTap: () {
                        Constant.userProfileView(context, userId: u.id);
                      },
                    );
                  },
                );
              }
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }
}
