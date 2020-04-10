import 'package:ednet/home/create/article/create_article.dart';
import 'package:ednet/home/create/question/create_question.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:flutter/material.dart';

class CreateContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.all(0.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.5,
            width: MediaQuery.of(context).size.width * 0.5,
            child: RaisedButton(
              padding: Constant.edgePadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Icon(
                    Icons.help,
                    size: 52.0,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.menuButtonIconColor
                        : LightTheme.menuButtonIconColor,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    "Ask a Question",
                    style: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.menuButtonTextStyle
                        : LightTheme.menuButtonTextStyle,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
              elevation: 15.0,
              color: Theme.of(context).brightness == Brightness.dark
                  ? DarkTheme.menuButtonBackgroundColor
                  : LightTheme.menuButtonBackgroundColor,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.menuButtonBackgroundColor
                        : LightTheme.menuButtonBackgroundColor,
                    width: 2.0),
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return CreateQuestion();
                    },
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 36,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.5,
            width: MediaQuery.of(context).size.width * 0.5,
            child: RaisedButton(
              padding: Constant.edgePadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Icon(
                    Icons.edit,
                    size: 52.0,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.menuButtonIconColor
                        : LightTheme.menuButtonIconColor,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    "Write an Article",
                    style: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.menuButtonTextStyle
                        : LightTheme.menuButtonTextStyle,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
              elevation: 15.0,
              color: Theme.of(context).brightness == Brightness.dark
                  ? DarkTheme.menuButtonBackgroundColor
                  : LightTheme.menuButtonBackgroundColor,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.menuButtonBackgroundColor
                        : LightTheme.menuButtonBackgroundColor,
                    width: 2.0),
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return CreateArticle();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
