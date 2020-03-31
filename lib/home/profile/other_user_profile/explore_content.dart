import 'package:ednet/home/profile/other_user_profile/user_answers_page.dart';
import 'package:ednet/home/profile/other_user_profile/user_articles_page.dart';
import 'package:ednet/home/profile/other_user_profile/user_questions_page.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:flutter/material.dart';

class ExploreContent extends StatelessWidget {
  final User user;

  const ExploreContent({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            indicator: BoxDecoration(
              color: Colors.blue,
            ),
            unselectedLabelColor: Colors.blue,
            tabs: <Widget>[
              Tab(
                text: "Questions",
              ),
              Tab(
                text: "Answers",
              ),
              Tab(
                text: "Articles",
              )
            ],
          ),
          Expanded(
            child: TabBarView(
              children: <Widget>[
                UserQuestions(
                  user: user,
                ),
                UserAnswers(
                  user: user,
                ),
                UserArticles(
                  user: user,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}