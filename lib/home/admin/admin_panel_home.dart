import 'package:ednet/home/admin/reports/reported_content_overview.dart';
import 'package:ednet/home/admin/users/users_overview.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:flutter/material.dart';

class AdminPanelHome extends StatelessWidget {
  final User admin;

  const AdminPanelHome({Key key, this.admin}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, //TODO Content Summary TAB
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Admin Panel",
            style: Theme.of(context).brightness == Brightness.dark
                ? DarkTheme.appBarTextStyle
                : LightTheme.appBarTextStyle,
          ),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: "Users",
              ),
              Tab(
                text: "Reports",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AdminUsersList(
              admin: admin,
            ),
            ReportedContents(
              admin: admin,
            ),
          ],
        ),
      ),
    );
  }
}
