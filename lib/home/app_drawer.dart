import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:ednet/home/drafts/my_drafts_page.dart';
import 'package:ednet/home/profile/my_profile/my_profile_info_page.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatefulWidget {
  final DocumentSnapshot userSnap;

  const AppDrawer({Key key, this.userSnap}) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  void changeBrightness() {
    DynamicTheme.of(context).setBrightness(
        Theme.of(context).brightness == Brightness.dark ? Brightness.light : Brightness.dark);
  }

  @override
  Widget build(BuildContext context) {
    User currentUser = User.fromSnapshot(widget.userSnap);
    return Drawer(
      child: Scrollbar(
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
                style: Theme.of(context).brightness == Brightness.dark
                    ? DarkTheme.appDrawerMenuStyle
                    : LightTheme.appDrawerMenuStyle,
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return MyProfile(
                        user: currentUser,
                      );
                    },
                  ),
                );
              },
            ),
            ListTile(
              title: Text(
                "My Drafts",
                style: Theme.of(context).brightness == Brightness.dark
                    ? DarkTheme.appDrawerMenuStyle
                    : LightTheme.appDrawerMenuStyle,
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return MyDrafts(
                        user: currentUser,
                      );
                    },
                  ),
                );
              },
            ),
            currentUser.isAdmin
                ? ListTile(
                    title: Text(
                      "Admin Panel",
                      style: Theme.of(context).brightness == Brightness.dark
                    ? DarkTheme.appDrawerMenuStyle
                    : LightTheme.appDrawerMenuStyle,
                    ),
                    onTap: () {
                      print("yet to implement");
                    },
                  )
                : Container(),
            ListTile(
              title: Text(
                Theme.of(context).brightness == Brightness.dark ? "Light Mode" : "Dark Mode",
                style: Theme.of(context).brightness == Brightness.dark
                    ? DarkTheme.appDrawerMenuStyle
                    : LightTheme.appDrawerMenuStyle,
              ),
              onTap: () {
                Navigator.of(context).pop();
                changeBrightness();
              },
            ),
            ListTile(
              title: Text(
                "Log out",
                style: Theme.of(context).brightness == Brightness.dark
                    ? DarkTheme.appDrawerMenuStyle
                    : LightTheme.appDrawerMenuStyle,
              ),
              onTap: () {
                Navigator.of(context).pop();
                Constant.logOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
