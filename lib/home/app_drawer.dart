import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/profile/my_profile/my_drafts_page.dart';
import 'package:ednet/home/profile/my_profile/my_profile_info_page.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final DocumentSnapshot userSnap;

  const AppDrawer({Key key, this.userSnap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          DrawerHeader(
            child: Container(),
          ),
          ListTile(
            title: Text(
              "My Profile",
              style: Constant.appDrawerMenuStyle,
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return MyProfile(
                      user: User.fromSnapshot(userSnap),
                    );
                  },
                ),
              );
            },
          ),
          ListTile(
            title: Text(
              "My Drafts",
              style: Constant.appDrawerMenuStyle,
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return MyDrafts(
                      user: User.fromSnapshot(userSnap),
                    );
                  },
                ),
              );
            },
          ),
          ListTile(
            title: Text(
              "Log out",
              style: Constant.appDrawerMenuStyle,
            ),
            onTap: () {
              Navigator.of(context).pop();
              Constant.logOut();
            },
          ),
          ListTile(
            title: Text(
              "Admin Panel",
              style: Constant.appDrawerMenuStyle,
            ),
            onTap: () {
              print("yet to implement");
            },
          ),
        ],
      ),
    );
  }
}
