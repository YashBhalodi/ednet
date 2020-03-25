import 'package:ednet/utilities_files/constant.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
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
          )
        ],
      ),
    );
  }
}
