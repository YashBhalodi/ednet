import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/app_drawer.dart';
import 'package:ednet/home/create/create_content.dart';
import 'package:ednet/home/feed/feed_page.dart';
import 'package:ednet/home/profile/my_profile/profile_page.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final DocumentSnapshot userSnap;

  const Home({Key key, @required this.userSnap}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    Widget _body = IndexedStack(
      index: _selectedIndex,
      children: <Widget>[
        CreateContent(),
        FeedPage(),
        ProfilePage(userSnap: widget.userSnap),
      ],
    );

    return SafeArea(
      child: Scaffold(
        body: _body,
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              title: Text(
                "Create",
                style: Constant.bottomNavigationTitleStyle,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.rss_feed),
              title: Text(
                "Learn",
                style: Constant.bottomNavigationTitleStyle,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text(
                "Manage",
                style: Constant.bottomNavigationTitleStyle,
              ),
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (i) {
            setState(() {
              _selectedIndex = i;
            });
          },
        ),
        drawer: AppDrawer(),
      ),
    );
  }
}
