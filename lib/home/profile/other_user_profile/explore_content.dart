import 'package:ednet/home/profile/other_user_profile/user_answers_page.dart';
import 'package:ednet/home/profile/other_user_profile/user_articles_page.dart';
import 'package:ednet/home/profile/other_user_profile/user_questions_page.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:flutter/material.dart';

class ExploreContent extends StatelessWidget {
  final User user;
  final List<Question> questionList;
  final List<Article> articleList;
  final List<Answer> answerList;

  const ExploreContent({Key key, @required this.user, this.questionList, this.articleList, this.answerList}) : super(key: key);

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
            labelColor: Theme.of(context).brightness == Brightness.dark
                ? DarkTheme.tabSelectedLabelColor
                : LightTheme.tabSelectedLabelColor,
            unselectedLabelColor: Theme.of(context).brightness == Brightness.dark
                ? DarkTheme.tabUnselectedLabelColor
                : LightTheme.tabUnselectedLabelColor,
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
                  questions: questionList,
                ),
                UserAnswers(
                  user: user,
                  answers: answerList,
                ),
                UserArticles(
                  user: user,
                  articles: articleList,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
