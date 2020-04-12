import 'package:ednet/utilities_files/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyCheckBoxTile extends StatefulWidget {
  final List<String> outputList;
  final String title;
  final int maxElement;
  final String subtitle;

  const MyCheckBoxTile({Key key, @required this.outputList, @required this.title, this.maxElement, this.subtitle})
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
        style: Theme
                   .of(context)
                   .brightness == Brightness.dark
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
        /*side: BorderSide(
          color: Colors.red[300],
          width: 1.0,
        ),*/
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
        /*side: BorderSide(
          color: Theme.of(context).brightness == Brightness.dark
              ? DarkTheme.secondaryCTABorderColor
              : LightTheme.secondaryCTABorderColor,
          width: 2.0,
        ),*/
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
