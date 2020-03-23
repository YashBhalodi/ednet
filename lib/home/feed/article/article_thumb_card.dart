import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ArticleThumbCard extends StatelessWidget {
    final Article article;

  const ArticleThumbCard({Key key, this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (){
            //TODO Navigate to article screen
            print(article.toString());
        },
      child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
              ),
          ),
          elevation: 5.0,
          margin: Constant.cardMargin,
          clipBehavior: Clip.antiAlias,
          child: Padding(
              padding: Constant.cardPadding,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                      SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                              children: List.generate(article.topics.length, (i) {
                                  return Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: Chip(
                                          label: Text(
                                              article.topics[i],
                                          ),
                                          backgroundColor: Colors.grey[100],
                                      ),
                                  );
                              }),
                          ),
                      ),
                      SizedBox(
                          height: 8.0,
                      ),
                      Text(
                          article.title,
                          style: Constant.articleTitleStyle,
                          textAlign: TextAlign.justify,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                          height: 16.0,
                      ),
                      Text(
                          article.subtitle,
                          style: Constant.articleSubtitleStyle,
                          textAlign: TextAlign.justify,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                          height: 24.0,
                      ),
                      Text(
                          article.content,
                          style: Constant.articleContentStyle,
                          textAlign: TextAlign.justify,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                          height: 16.0,
                      ),
                      Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                              Expanded(
                                  flex: 4,
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                          Icon(
                                              Icons.person,
                                              size: 16.0,
                                          ),
                                          article.byProf
                                          ? Icon(
                                              Icons.star,
                                              color: Colors.orangeAccent,
                                              size: 16.0,
                                          )
                                          : Container(),
                                          Text(
                                              article.username,
                                              style: Constant.usernameStyle,
                                          ),
                                      ],
                                  ),
                              ),
                              Spacer(),
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                      Constant.formatDateTime(article.createdOn),
                                      style: Constant.dateTimeStyle,
                                      textAlign: TextAlign.end,
                                  ),
                              )
                          ],
                      ),
                      SizedBox(height: 12.0,),
                      SizedBox(
                          height: 32.0,
                          child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                  Expanded(
                                      flex: 2,
                                      child: UpvoteBox(upvoteCount: article.upvoteCount,),
                                  ),
                                  Expanded(
                                      flex: 5,
                                      //TODO answercountbox is not applicable
                                      child: AnswerCountBox(answerCount: 0,),
                                  ),
                                  Expanded(
                                      flex: 2,
                                      child: DownvoteBox(downvoteCount: article.downvoteCount,),
                                  ),
                              ],
                          ),
                      )
                  ],
              ),
          ),
      ),
    );
  }
}
