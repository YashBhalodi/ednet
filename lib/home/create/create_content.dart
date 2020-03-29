import 'package:ednet/home/create/article/create_article.dart';
import 'package:ednet/home/create/question/create_question.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:flutter/material.dart';

class CreateContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Spacer(flex: 1),
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
                        color: Colors.blue[700],
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Text(
                        "Ask a Question",
                        style: Constant.menuButtonTextStyle,
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                  elevation: 15.0,
                  color: Colors.grey[100],
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey[300], width: 2.0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                      return CreateQuestion();
                    }));
                  },
                ),
              ),
              Spacer(
                flex: 1,
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
                        color: Colors.blue[700],
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Text(
                        "Write an Article",
                        style: Constant.menuButtonTextStyle,
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                  elevation: 15.0,
                  color: Colors.grey[100],
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey[300], width: 2.0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                      return CreateArticle();
                    }));
                  },
                ),
              ),
              Spacer(
                flex: 1,
              )
            ],
          ),
        ),
      ),
    );
  }
}
