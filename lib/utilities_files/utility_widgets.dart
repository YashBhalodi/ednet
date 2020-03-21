import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/contants.dart';
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
      padding: Constant.raisedButtonPaddingLow,
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

  const PrimaryBlueCTA({Key key, this.callback, this.child}) : super(key: key);
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
        side: BorderSide(color: Colors.blue[500], width: 2.0),
      ),
      color: Colors.blue[800],
    );
  }
}

class QuestionCard extends StatelessWidget {
  final Question question;

  const QuestionCard({Key key,@required this.question}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0),),),
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
            Text(question.heading,style: Constant.questionHeadingStyle,maxLines: 6,overflow: TextOverflow.ellipsis,),
            SizedBox(height: 8.0,),
            Text(question.description,style: Constant.questionDescriptionStyle,maxLines: 3,overflow: TextOverflow.ellipsis,)
          ],
        ),
      ),
    );
  }
}


class SecondaryCTA extends StatelessWidget {
  final Widget child;
  final Function callback;

  const SecondaryCTA({Key key, this.callback, this.child}) : super(key: key);

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

//TODO Negative CTA RaisedButton
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
