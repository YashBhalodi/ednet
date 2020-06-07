import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zefyr/zefyr.dart';

class MyCheckBoxTile extends StatefulWidget {
  final List<String> outputList;
  final String title;
  final int maxElement;
  final String subtitle;

  const MyCheckBoxTile(
      {Key key, @required this.outputList, @required this.title, this.maxElement, this.subtitle})
      : super(key: key);

  @override
  _MyCheckBoxTileState createState() => _MyCheckBoxTileState();
}

class _MyCheckBoxTileState extends State<MyCheckBoxTile> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      checkColor: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
      controlAffinity: ListTileControlAffinity.leading,
      value: widget.outputList.contains(widget.title),
      title: Text(
        widget.title,
      ),
      subtitle: widget.subtitle == null
          ? null
          : Text(
              widget.subtitle,
              style: Theme.of(context).brightness == Brightness.dark
                  ? DarkTheme.dateTimeStyle
                  : LightTheme.dateTimeStyle,
            ),
      onChanged: (value) {
        if (value == true) {
          if (widget.maxElement == null) {
            setState(() {
              widget.outputList.add(widget.title);
            });
          } else {
            if (widget.outputList.length < widget.maxElement) {
              setState(() {
                widget.outputList.add(widget.title);
              });
            }
          }
        } else {
          setState(() {
            widget.outputList.remove(widget.title);
          });
        }
      },
    );
  }
}

class UpvoteBox extends StatelessWidget {
  final int upvoteCount;

  UpvoteBox({Key key, @required this.upvoteCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? DarkTheme.ratingBoxBackgroundColor
                : LightTheme.ratingBoxBackgroundColor,
            width: 1.0,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
          ),
        ),
        color: Theme.of(context).brightness == Brightness.dark
            ? DarkTheme.ratingBoxBackgroundColor
            : LightTheme.ratingBoxBackgroundColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.keyboard_arrow_up,
            color: Theme.of(context).brightness == Brightness.dark
                ? DarkTheme.upvoteCountColor
                : LightTheme.upvoteCountColor,
            size: 16.0,
          ),
          SizedBox(
            width: 8.0,
          ),
          Text(upvoteCount.toString(),
              style: Theme.of(context).brightness == Brightness.dark
                  ? DarkTheme.upvoteCountTextStyle
                  : LightTheme.upvoteCountTextStyle)
        ],
      ),
    );
  }
}

class DownvoteBox extends StatelessWidget {
  final int downvoteCount;

  DownvoteBox({Key key, @required this.downvoteCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? DarkTheme.ratingBoxBackgroundColor
                : LightTheme.ratingBoxBackgroundColor,
            width: 1.0,
          ),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10.0),
          ),
        ),
        color: Theme.of(context).brightness == Brightness.dark
            ? DarkTheme.ratingBoxBackgroundColor
            : LightTheme.ratingBoxBackgroundColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.keyboard_arrow_down,
            color: Theme.of(context).brightness == Brightness.dark
                ? DarkTheme.downvoteCountColor
                : LightTheme.downvoteCountColor,
            size: 16.0,
          ),
          SizedBox(
            width: 8.0,
          ),
          Text(downvoteCount.toString(),
              style: Theme.of(context).brightness == Brightness.dark
                  ? DarkTheme.downvoteCountTextStyle
                  : LightTheme.downvoteCountTextStyle)
        ],
      ),
    );
  }
}

class AnswerCountBox extends StatelessWidget {
  final int answerCount;

  AnswerCountBox({Key key, @required this.answerCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? DarkTheme.ratingBoxBackgroundColor
                : LightTheme.ratingBoxBackgroundColor,
            width: 1.0,
          ),
        ),
        color: Theme.of(context).brightness == Brightness.dark
            ? DarkTheme.ratingBoxBackgroundColor
            : LightTheme.ratingBoxBackgroundColor,
      ),
      child: Center(
        child: Text(
          answerCount.toString() + " Answers",
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }
}

class SecondaryNegativeCardButton extends StatelessWidget {
  final Function callback;
  final Widget child;

  const SecondaryNegativeCardButton({Key key, @required this.callback, @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: callback,
      color: Theme.of(context).brightness == Brightness.dark
          ? DarkTheme.secondaryNegativeCardButtonBackgroundColor
          : LightTheme.secondaryNegativeCardButtonBackgroundColor,
      padding: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          bottomLeft: Radius.circular(10.0),
        ),
      ),
      child: child,
    );
  }
}

class SecondaryPositiveCardButton extends StatelessWidget {
  final Function callback;
  final Widget child;

  const SecondaryPositiveCardButton({Key key, this.callback, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: callback,
      color: Theme.of(context).brightness == Brightness.dark
          ? DarkTheme.secondaryPositiveCardButtonBackgroundColor
          : LightTheme.secondaryPositiveCardButtonBackgroundColor,
      padding: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
        ),
      ),
      child: child,
    );
  }
}

class UpvoteButton extends StatelessWidget {
  final Function callback;
  final int count;

  const UpvoteButton({Key key, @required this.callback, @required this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: callback,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Icon(
            Icons.arrow_upward,
            color: Theme.of(context).brightness == Brightness.dark
                ? DarkTheme.upvoteButtonCountColor
                : LightTheme.upvoteButtonCountColor,
            size: 18.0,
          ),
          SizedBox(
            width: 8.0,
          ),
          Text(
            count.toString() + " Upvote",
            style: Theme.of(context).brightness == Brightness.dark
                ? DarkTheme.upvoteButtonTextStyle
                : LightTheme.upvoteButtonTextStyle,
          ),
        ],
      ),
      color: Theme.of(context).brightness == Brightness.dark
          ? DarkTheme.upvoteButtonBackgroundColor
          : LightTheme.upvoteButtonBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          bottomLeft: Radius.circular(10.0),
        ),
        side: BorderSide(
          color: Theme.of(context).brightness == Brightness.dark
              ? DarkTheme.upvoteButtonBackgroundColor
              : LightTheme.upvoteButtonBackgroundColor,
          width: 1.0,
        ),
      ),
      elevation: 2.0,
      padding: Constant.raisedButtonPaddingLow,
    );
  }
}

class DownvoteButton extends StatelessWidget {
  final Function callback;
  final int count;

  const DownvoteButton({Key key, this.callback, this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: callback,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Icon(
            Icons.arrow_downward,
            color: Theme.of(context).brightness == Brightness.dark
                ? DarkTheme.downvoteButtonCountColor
                : LightTheme.downvoteButtonCountColor,
            size: 18.0,
          ),
          SizedBox(
            width: 8.0,
          ),
          Text(
            count.toString() + " Downvote",
            style: Theme.of(context).brightness == Brightness.dark
                ? DarkTheme.downvoteButtonTextStyle
                : LightTheme.downvoteButtonTextStyle,
          ),
        ],
      ),
      color: Theme.of(context).brightness == Brightness.dark
          ? DarkTheme.downvoteButtonBackgroundColor
          : LightTheme.downvoteButtonBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
        ),
        side: BorderSide(
          color: Theme.of(context).brightness == Brightness.dark
              ? DarkTheme.downvoteButtonBackgroundColor
              : LightTheme.downvoteButtonBackgroundColor,
          width: 1.0,
        ),
      ),
      elevation: 2.0,
      padding: Constant.raisedButtonPaddingLow,
    );
  }
}

class PrimaryBlueCTA extends StatelessWidget {
  final Function callback;
  final Widget child;

  const PrimaryBlueCTA({Key key, @required this.callback, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: callback,
      child: child,
      autofocus: true,
      elevation: 15.0,
      padding: Constant.raisedButtonPaddingHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      color: Theme.of(context).brightness == Brightness.dark
          ? DarkTheme.primaryCTABackgroundColor
          : LightTheme.primaryCTABackgroundColor,
    );
  }
}

class SecondaryCTA extends StatelessWidget {
  final Widget child;
  final Function callback;

  const SecondaryCTA({Key key, @required this.callback, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: child,
      onPressed: callback,
      padding: Constant.raisedButtonPaddingHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(
          color: Theme.of(context).brightness == Brightness.dark
              ? DarkTheme.secondaryCTABorderColor
              : LightTheme.secondaryCTABorderColor,
          width: 2.0,
        ),
      ),
      color: Theme.of(context).brightness == Brightness.dark
          ? DarkTheme.secondaryCTABackgroundColor
          : LightTheme.secondaryCTABackgroundColor,
      disabledColor: Theme.of(context).brightness == Brightness.dark
          ? DarkTheme.secondaryCTADisabledColor
          : LightTheme.secondaryCTADisabledColor,
    );
  }
}

class BlueOutlineButton extends StatelessWidget {
  final Widget child;
  final Function callback;

  const BlueOutlineButton({Key key, @required this.callback, @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: callback,
      child: child,
      padding: Constant.raisedButtonPaddingMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? DarkTheme.outlineButtonTextColor
                : LightTheme.outlineButtonTextColor,
            width: 2.0),
      ),
      color: Theme.of(context).brightness == Brightness.dark
          ? DarkTheme.outlineButtonBackgroundColor
          : LightTheme.outlineButtonBackgroundColor,
      disabledColor:
          Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.grey[300],
      elevation: 4.0,
    );
  }
}

class StepButton extends StatelessWidget {
  final Function callback;

  ///direction=='next' or direction=='prev'
  final String direction;

  const StepButton({Key key, this.callback, @required this.direction})
      : assert(direction == 'next' || direction == 'prev'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: callback,
      padding: Constant.raisedButtonPaddingLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? DarkTheme.stepButtonBorderColor
                : LightTheme.stepButtonBorderColor,
            width: 2.0),
      ),
      color: Theme.of(context).brightness == Brightness.dark
          ? DarkTheme.stepButtonBackgroundColor
          : LightTheme.stepButtonBackgroundColor,
      child: direction == 'prev'
          ? Icon(
              Icons.navigate_before,
              size: 26.0,
              color: Theme.of(context).brightness == Brightness.dark
                  ? DarkTheme.stepButtonIconColor
                  : LightTheme.stepButtonIconColor,
            )
          : Icon(
              Icons.navigate_next,
              size: 26.0,
              color: Theme.of(context).brightness == Brightness.dark
                  ? DarkTheme.stepButtonIconColor
                  : LightTheme.stepButtonIconColor,
            ),
      disabledColor: Theme.of(context).brightness == Brightness.dark
          ? DarkTheme.stepButtonDisabledColor
          : LightTheme.stepButtonDisabledColor,
    );
  }
}

class LeftSecondaryCTAButton extends StatelessWidget {
  final Function callback;
  final Widget child;

  const LeftSecondaryCTAButton({Key key, this.callback, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: child,
      onPressed: callback,
      padding: Constant.raisedButtonPaddingHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          bottomLeft: Radius.circular(16.0),
        ),
      ),
      color: Theme.of(context).brightness == Brightness.dark
          ? DarkTheme.secondaryCTABackgroundColor
          : LightTheme.secondaryCTABackgroundColor,
      disabledColor: Theme.of(context).brightness == Brightness.dark
          ? DarkTheme.secondaryCTADisabledColor
          : LightTheme.secondaryCTADisabledColor,
    );
  }
}

class RightPrimaryBlueCTAButton extends StatelessWidget {
  final Function callback;
  final Widget child;

  const RightPrimaryBlueCTAButton({Key key, this.callback, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: callback,
      child: child,
      autofocus: true,
      elevation: 15.0,
      padding: Constant.raisedButtonPaddingHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      color: Theme.of(context).brightness == Brightness.dark
          ? DarkTheme.primaryCTABackgroundColor
          : LightTheme.primaryCTABackgroundColor,
    );
  }
}

class DeleteConfirmationAlert extends StatelessWidget {
  final String title;
  final String msg;
  final Function deleteCallback;
  final Function cancelCallback;

  const DeleteConfirmationAlert(
      {Key key, this.title, this.msg, this.deleteCallback, this.cancelCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16.0),
        ),
      ),
      title: Text(title),
      contentPadding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(msg),
          ),
          SizedBox(
            height: 32.0,
          ),
          SizedBox(
            height: 40.0,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: SecondaryNegativeCardButton(
                    callback: deleteCallback,
                    child: Text(
                      "Delete",
                      style: Theme.of(context).brightness == Brightness.dark
                          ? DarkTheme.secondaryNegativeTextStyle
                          : LightTheme.secondaryNegativeTextStyle,
                    ),
                  ),
                ),
                Expanded(
                  child: SecondaryPositiveCardButton(
                    callback: cancelCallback,
                    child: Text(
                      "Cancle",
                      style: Theme.of(context).brightness == Brightness.dark
                          ? DarkTheme.secondaryPositiveTextStyle
                          : LightTheme.secondaryPositiveTextStyle,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ReportDiscardButton extends StatelessWidget {
  final Function callback;

  const ReportDiscardButton({Key key, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Theme.of(context).brightness == Brightness.dark
          ? DarkTheme.secondaryNegativeCardButtonBackgroundColor
          : LightTheme.secondaryNegativeCardButtonBackgroundColor,
      onPressed: callback,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16.0),
        ),
      ),
      padding: Constant.raisedButtonPaddingMedium,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          /*Icon(
            Icons.delete,
            color:
                Theme.of(context).brightness == Brightness.dark ? Colors.red[50] : Colors.red[500],
            size: 20.0,
          ),
          SizedBox(
            width: 4.0,
          ),*/
          Text(
            "Discard",
            style: Theme.of(context).brightness == Brightness.dark
                ? DarkTheme.secondaryNegativeTextStyle
                : LightTheme.secondaryNegativeTextStyle,
          ),
        ],
      ),
    );
  }
}

class ReportDiscardConfirmationAlert extends StatelessWidget {
  final Function discardCallback;
  final Function cancelCallback;
  final bool allReports;

  const ReportDiscardConfirmationAlert(
      {Key key, @required this.discardCallback, @required this.cancelCallback, this.allReports})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16.0),
        ),
      ),
      title: Text(allReports == true ? "Discard All Reports?" : "Discard this report?"),
      contentPadding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            //TODO write better message
            child: Text(
              "To maintain the quality of contents in EDNET, users report the content according to their perspective.\n\nHowever, as per your judgement, if the content is falsely reported, you can delete the report.",
              style: Theme.of(context).brightness == Brightness.dark
                  ? DarkTheme.formFieldHintStyle
                  : LightTheme.formFieldHintStyle,
            ),
          ),
          SizedBox(
            height: 32.0,
          ),
          SizedBox(
            height: 40.0,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: SecondaryNegativeCardButton(
                    callback: discardCallback,
                    child: Text(
                      "Discard",
                      style: Theme.of(context).brightness == Brightness.dark
                          ? DarkTheme.secondaryNegativeTextStyle
                          : LightTheme.secondaryNegativeTextStyle,
                    ),
                  ),
                ),
                Expanded(
                  child: SecondaryPositiveCardButton(
                    callback: cancelCallback,
                    child: Text(
                      "Cancle",
                      style: Theme.of(context).brightness == Brightness.dark
                          ? DarkTheme.secondaryPositiveTextStyle
                          : LightTheme.secondaryPositiveTextStyle,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class NegativePrimaryButton extends StatelessWidget {
  final Function callback;
  final Widget child;

  const NegativePrimaryButton({Key key, @required this.callback, @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: callback,
      child: child,
      padding: Constant.raisedButtonPaddingHigh,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular((16.0)))),
      color: Theme.of(context).brightness == Brightness.dark
          ? DarkTheme.negativePrimaryButtonColor
          : LightTheme.negativePrimaryButtonColor,
    );
  }
}

class AnswerContentView extends StatelessWidget {
  final Answer answer;

  const AnswerContentView({Key key, this.answer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        ZefyrView(
          document: NotusDocument.fromJson(
            jsonDecode(answer.contentJson),
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: StreamBuilder(
                stream: Firestore.instance.collection('Users').document(answer.userId).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  } else {
                    if (snapshot.data.data != null) {
                      DocumentSnapshot userDoc = snapshot.data;
                      return GestureDetector(
                        onTap: () {
                          Constant.userProfileView(context, userId: answer.userId);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              "Answered by",
                              style: Theme.of(context).brightness == Brightness.dark
                                  ? DarkTheme.dateTimeStyle
                                  : LightTheme.dateTimeStyle,
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.person,
                                  size: 16.0,
                                ),
                                answer.byProf
                                    ? Icon(
                                        Icons.star,
                                        color: Colors.orangeAccent,
                                        size: 16.0,
                                      )
                                    : Container(),
                                Text(
                                  userDoc.data['username'],
                                  style: Theme.of(context).brightness == Brightness.dark
                                      ? DarkTheme.usernameStyle
                                      : LightTheme.usernameStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Container(); //TODO user account is removed. msg if we want
                    }
                  }
                },
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "On",
                    style: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.dateTimeStyle
                        : LightTheme.dateTimeStyle,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    Constant.formatDateTime(answer.createdOn),
                    style: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.dateTimeMediumStyle
                        : LightTheme.dateTimeMediumStyle,
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}

class ArticleContentView extends StatelessWidget {
  final Article article;

  const ArticleContentView({Key key, this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
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
                    style: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.topicStyle
                        : LightTheme.topicStyle,
                  ),
                  backgroundColor: Theme.of(context).brightness == Brightness.dark
                      ? DarkTheme.chipBackgroundColor
                      : LightTheme.chipBackgroundColor,
                ),
              );
            }),
          ),
        ),
        SizedBox(
          height: 12.0,
        ),
        Text(
          article.title,
          style: Theme.of(context).brightness == Brightness.dark
              ? DarkTheme.articleTitleStyle
              : LightTheme.articleTitleStyle,
        ),
        SizedBox(height: 18.0),
        Text(
          article.subtitle,
          style: Theme.of(context).brightness == Brightness.dark
              ? DarkTheme.articleSubtitleStyle
              : LightTheme.articleSubtitleStyle,
        ),
        SizedBox(
          height: 24.0,
        ),
        ZefyrView(
          document: NotusDocument.fromJson(
            jsonDecode(article.contentJson),
          ),
        ),
        SizedBox(
          height: 18.0,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: StreamBuilder(
                stream: Firestore.instance.collection('Users').document(article.userId).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  } else {
                    if (snapshot.data.data != null) {
                      DocumentSnapshot userDoc = snapshot.data;
                      return GestureDetector(
                        onTap: () {
                          Constant.userProfileView(context, userId: article.userId);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              "Written by",
                              style: Theme.of(context).brightness == Brightness.dark
                                  ? DarkTheme.dateTimeStyle
                                  : LightTheme.dateTimeStyle,
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Row(
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
                                  userDoc.data['username'],
                                  style: Theme.of(context).brightness == Brightness.dark
                                      ? DarkTheme.usernameStyle
                                      : LightTheme.usernameStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Container(); //TODO user account is removed. msg if we want
                    }
                  }
                },
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "On",
                    style: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.dateTimeStyle
                        : LightTheme.dateTimeStyle,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    Constant.formatDateTime(article.createdOn),
                    style: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.dateTimeMediumStyle
                        : LightTheme.dateTimeMediumStyle,
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}

class QuestionContentView extends StatelessWidget {
  final Question question;

  const QuestionContentView({Key key, this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(question.topics.length, (i) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Chip(
                  label: Text(
                    question.topics[i],
                    style: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.topicStyle
                        : LightTheme.topicStyle,
                  ),
                  backgroundColor: Theme.of(context).brightness == Brightness.dark
                      ? DarkTheme.chipBackgroundColor
                      : LightTheme.chipBackgroundColor,
                ),
              );
            }),
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        Text(
          question.heading,
          style: Theme.of(context).brightness == Brightness.dark
              ? DarkTheme.questionHeadingStyle
              : LightTheme.questionHeadingStyle,
        ),
        SizedBox(
          height: 8.0,
        ),
        ZefyrView(
          document: NotusDocument.fromJson(
            jsonDecode(question.descriptionJson),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        question.profUpvoteCount > 0
            ? Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    "${question.profUpvoteCount} professor upvoted",
                    style: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.professorUpvoteTextStyle
                        : LightTheme.professorUpvoteTextStyle,
                  ),
                ),
              )
            : Container(),
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 4,
              child: StreamBuilder(
                stream:
                    Firestore.instance.collection('Users').document(question.userId).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  } else {
                    if (snapshot.data.data != null) {
                      DocumentSnapshot userDoc = snapshot.data;
                      return GestureDetector(
                        onTap: () {
                          Constant.userProfileView(context, userId: question.userId);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              "Asked by",
                              style: Theme.of(context).brightness == Brightness.dark
                                  ? DarkTheme.dateTimeStyle
                                  : LightTheme.dateTimeStyle,
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.person,
                                  size: 16.0,
                                ),
                                question.byProf
                                    ? Icon(
                                        Icons.star,
                                        color: Colors.orangeAccent,
                                        size: 16.0,
                                      )
                                    : Container(),
                                Text(
                                  userDoc.data['username'],
                                  style: Theme.of(context).brightness == Brightness.dark
                                      ? DarkTheme.usernameStyle
                                      : LightTheme.usernameStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Container(); //TODO user account is removed. msg if we want
                    }
                  }
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "On",
                    style: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.dateTimeStyle
                        : LightTheme.dateTimeStyle,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    Constant.formatDateTime(question.createdOn),
                    style: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.dateTimeStyle
                        : LightTheme.dateTimeStyle,
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}

class UpVoterList extends StatelessWidget {
  final List<String> upvoters;

  const UpVoterList({Key key, @required this.upvoters}) : super(key: key);

  void showList(context) {
    showModalBottomSheet(
        context: context,
        elevation: 10.0,
        isDismissible: true,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16.0),
            topLeft: Radius.circular(16.0),
          ),
        ),
        builder: (context) {
          return VoterListSheet(
            userList: upvoters,
            isUpvoteList: true,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showList(context),
      child: Text(
        "Upvoters",
        style: Theme.of(context).brightness == Brightness.dark
            ? DarkTheme.voterTextStyle
            : LightTheme.voterTextStyle,
      ),
    );
  }
}

class DownVoterList extends StatelessWidget {
  final List<String> downvoters;

  const DownVoterList({Key key, this.downvoters}) : super(key: key);

  void showList(context) {
    showModalBottomSheet(
        context: context,
        elevation: 10.0,
        isDismissible: true,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16.0),
            topLeft: Radius.circular(16.0),
          ),
        ),
        builder: (context) {
          return VoterListSheet(
            userList: downvoters,
            isUpvoteList: false,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showList(context),
      child: Text(
        "Downvoters",
        style: Theme.of(context).brightness == Brightness.dark
            ? DarkTheme.voterTextStyle
            : LightTheme.voterTextStyle,
      ),
    );
  }
}

class VoterListSheet extends StatelessWidget {
  final List<String> userList;
  final bool isUpvoteList;

  const VoterListSheet({Key key, @required this.userList, this.isUpvoteList = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.loose(
        Size(
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height * 0.5,
        ),
      ),
      padding: const EdgeInsets.only(bottom:60),
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Padding(
            padding: Constant.edgePadding,
            child: Text(
              isUpvoteList ? "Upvoters" : "Downvoters",
              style: Theme.of(context).brightness == Brightness.dark
                  ? DarkTheme.headingStyle
                  : LightTheme.headingStyle,
            ),
          ),
          userList.length == 0
              ? Padding(
                  padding: Constant.edgePadding,
                  child: Text(
                    isUpvoteList ? "No Upvotes yet" : "No Downvotes yet",
                    style: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.secondaryHeadingTextStyle
                        : LightTheme.secondaryHeadingTextStyle,
                  ),
                )
              : ListView.builder(
                  itemCount: userList.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (_, i) {
                    return StreamBuilder(
                      stream:
                          Firestore.instance.collection('Users').document(userList[i]).snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          User u = User.fromSnapshot(snapshot.data);
                          return ListTile(
                            title: Text(u.userName),
                            trailing: u.isProf
                                ? Icon(
                                    Icons.star,
                                    color: Colors.orangeAccent,
                                    size: 18.0,
                                  )
                                : null,
                            onTap: () {
                              Constant.userProfileView(context, userId: u.id);
                            },
                          );
                        } else {
                          return Container();
                        }
                      },
                    );
                  },
                ),
        ],
      ),
    );
  }
}

class NotificationDismissIcon extends StatelessWidget {
  final bool leftToRight;

  const NotificationDismissIcon({Key key, this.leftToRight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Shimmer.fromColors(
        baseColor: Colors.red[100],
        highlightColor: Colors.red[300],
        period: Duration(milliseconds: 500),
        direction: leftToRight ? ShimmerDirection.ltr : ShimmerDirection.rtl,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              "Dismiss\nNotification",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
            Text(
              leftToRight ? ">>>" : "<<<",
              style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationDismissBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).brightness == Brightness.dark
          ? DarkTheme.secondaryNegativeCardButtonBackgroundColor
          : LightTheme.secondaryNegativeCardButtonBackgroundColor,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          NotificationDismissIcon(
            leftToRight: true,
          ),
          NotificationDismissIcon(
            leftToRight: false,
          ),
        ],
      ),
    );
  }
}

class NotificationCTA extends StatelessWidget {
  final Function callback;
  final Widget child;

  const NotificationCTA({Key key, this.callback, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: callback,
      child: child,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.zero,
          bottom: Radius.circular(10.0),
        ),
      ),
      color: Theme.of(context).brightness == Brightness.dark
          ? DarkTheme.notificationCTAColor
          : LightTheme.notificationCTAColor,
      elevation: 5.0,
      padding: Constant.raisedButtonPaddingLow,
    );
  }
}
