import 'package:ednet/utilities_files/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyCheckBoxTile extends StatefulWidget {
  final List<String> outputList;
  final String title;
  final int maxElement;

  const MyCheckBoxTile({Key key, @required this.outputList, @required this.title, this.maxElement})
      : super(key: key);

  @override
  _MyCheckBoxTileState createState() => _MyCheckBoxTileState();
}

class _MyCheckBoxTileState extends State<MyCheckBoxTile> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      checkColor: Colors.green[600],
      activeColor: Colors.green[50],
      controlAffinity: ListTileControlAffinity.leading,
      value: widget.outputList.contains(widget.title),
      title: Text(
        widget.title,
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

class PrimaryCTA extends StatelessWidget {
  final Function callback;
  final Widget child;

  const PrimaryCTA({Key key, this.callback, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: callback,
      textColor: Colors.white,
      child: child,
      padding: Constant.raisedButtonPaddingHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(color: Colors.green[400], width: 2.0),
      ),
      color: Colors.green[700],
      disabledColor: Colors.grey[300],
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
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: Colors.blue[700], width: 2.0),
      ),
      color: Colors.blue[600],
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
        side: BorderSide(color: Colors.grey[300], width: 2.0),
      ),
      color: Colors.white,
      disabledColor: Colors.grey[300],
    );
  }
}

class NegativeCTA extends StatelessWidget {
  final Function callback;
  final Widget child;

  const NegativeCTA({Key key, this.callback, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: callback,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16.0),
        ),
        side: BorderSide(
          color: Colors.red[500],
          width: 2.0,
        ),
      ),
      color: Colors.white,
    );
  }
}

class UpvoteBox extends StatelessWidget {
  final int upvoteCount;

  UpvoteBox({Key key, @required this.upvoteCount}) : super(key: key);

  Color backgroundColor = Colors.grey[50];
  Color borderColor = Colors.grey[200];
  Color textColor = Colors.green[500];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: borderColor,
            width: 1.0,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
          ),
        ),
        color: backgroundColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.keyboard_arrow_up,
            color: textColor,
            size: 16.0,
          ),
          SizedBox(
            width: 8.0,
          ),
          Text(
            upvoteCount.toString(),
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: textColor,
              fontSize: 14.0,
            ),
          )
        ],
      ),
    );
  }
}

class DownvoteBox extends StatelessWidget {
  final int downvoteCount;

  DownvoteBox({Key key, @required this.downvoteCount}) : super(key: key);

  Color backgroundColor = Colors.grey[50];
  Color borderColor = Colors.grey[200];
  Color textColor = Colors.red[500];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: borderColor,
            width: 1.0,
          ),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10.0),
          ),
        ),
        color: backgroundColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.keyboard_arrow_down,
            color: textColor,
            size: 16.0,
          ),
          SizedBox(
            width: 8.0,
          ),
          Text(
            downvoteCount.toString(),
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: textColor,
              fontSize: 14.0,
            ),
          )
        ],
      ),
    );
  }
}

class AnswerCountBox extends StatelessWidget {
  final int answerCount;

  AnswerCountBox({Key key, @required this.answerCount}) : super(key: key);

  Color backgroundColor = Colors.grey[50];
  Color borderColor = Colors.grey[100];
  Color textColor = Colors.grey[700];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: borderColor,
            width: 1.0,
          ),
        ),
        color: backgroundColor,
      ),
      child: Center(
        child: Text(
          answerCount.toString() + " Answers",
          style: TextStyle(
            fontWeight: FontWeight.w300,
            color: textColor,
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
        color: Colors.red[50],
        padding: EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0),
          ),
          side: BorderSide(
            color: Colors.red[300],
            width: 1.0,
          ),
        ),
        child: child);
  }
}

class SecondaryBlueCardButton extends StatelessWidget {
  final Function callback;
  final Widget child;

  const SecondaryBlueCardButton({Key key, this.callback, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: callback,
      color: Colors.blue[50],
      padding: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
        ),
        side: BorderSide(
          color: Colors.blue[300],
          width: 1.0,
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
            color: Colors.green[800],
            size: 18.0,
          ),
          SizedBox(
            width: 8.0,
          ),
          Text(
            count.toString() + " Upvote",
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400, color: Colors.green[800]),
          ),
        ],
      ),
      color: Colors.green[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          bottomLeft: Radius.circular(10.0),
        ),
        side: BorderSide(
          color: Colors.green[100],
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
            color: Colors.red[800],
            size: 18.0,
          ),
          SizedBox(
            width: 8.0,
          ),
          Text(
            count.toString() + " Downvote",
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400, color: Colors.red[800]),
          ),
        ],
      ),
      color: Colors.red[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
        ),
        side: BorderSide(
          color: Colors.red[100],
          width: 1.0,
        ),
      ),
      elevation: 2.0,
      padding: Constant.raisedButtonPaddingLow,
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
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.red,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        bottomLeft: Radius.circular(16.0),
                      ),
                    ),
                    color: Colors.white,
                    child: Text(
                      "Delete",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    padding: Constant.raisedButtonPaddingLow,
                    onPressed: deleteCallback,
                  ),
                ),
                Expanded(
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                      ),
                      side: BorderSide(
                        color: Colors.blue[700],
                        width: 1.0,
                      ),
                    ),
                    color: Colors.blue[800],
                    padding: Constant.raisedButtonPaddingLow,
                    onPressed: cancelCallback,
                    child: Text(
                      "Cancle",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
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
        side: BorderSide(color: Colors.blue[600], width: 2.0),
      ),
      color: Colors.grey[100],
      disabledColor: Colors.grey[300],
      elevation: 4.0,
    );
  }
}

/*
class TextWithCounter extends StatefulWidget {
  final Widget child;
  final int count;

  const TextWithCounter({Key key,@required this.count,@required this.child}) : super(key: key);

  @override
  _TextWithCounterState createState() => _TextWithCounterState();
}

class _TextWithCounterState extends State<TextWithCounter> {
  Color _badgeColor;

  load() {
    switch (widget.count) {
      case (0):
        {
          _badgeColor = Color(0xffFFFF33);
          break;
        }
      case (1):
        {
          _badgeColor = Color(0xffFFFF33);
          break;
        }
      case (2):
        {
          _badgeColor = Color(0xffCCFF4D);
          break;
        }
      case (3):
        {
          _badgeColor = Color(0xff99FF66);
          break;
        }
      case (4):
        {
          _badgeColor = Color(0xff66FF80);
          break;
        }
      case (5):
        {
          _badgeColor = Color(0xff33FF99);
          break;
        }
      default:
        {
          _badgeColor = Color(0xff33FF99);
          break;
        }
    }
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Badge(
      child: Padding(
        padding: const EdgeInsets.only(right:12.0),
        child: widget.child,
      ),
      badgeContent: Text(
        widget.count >= 100 ? "99+" : widget.count.toString(),
        style: TextStyle(fontSize: 8.0),
      ),
      badgeColor: _badgeColor,
      elevation: 1,

    );
  }
}
*/
