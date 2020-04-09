import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:flutter/material.dart';

class HeadingPage extends StatefulWidget {
  final Question question;
  final PageController parentPageController;

  const HeadingPage({Key key, @required this.question, @required this.parentPageController})
      : super(key: key);

  @override
  _HeadingPageState createState() => _HeadingPageState();
}

class _HeadingPageState extends State<HeadingPage> with AutomaticKeepAliveClientMixin {
  TextEditingController _headingController;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _headingController = TextEditingController(text: widget.question.heading);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _headingController.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scrollbar(
      child: ListView(
        shrinkWrap: true,
        padding: Constant.edgePadding,
        controller: _scrollController,
        children: <Widget>[
          Text("Heading",
              style: Theme.of(context).brightness == Brightness.dark
                  ? DarkTheme.headingStyle
                  : LightTheme.headingStyle),
          SizedBox(
            height: 8.0,
          ),
          Text(
            "Briefly describe what your question is about.\n\nUsually, the name of relevant domain, concepts, theorms etc.",
            style: Theme.of(context).brightness == Brightness.dark
                ? DarkTheme.headingDescriptionStyle
                : LightTheme.headingDescriptionStyle,
          ),
          SizedBox(
            height: 64.0,
          ),
          TextFormField(
            onEditingComplete: () {
              widget.parentPageController
                  .nextPage(duration: Constant.pageAnimationDuration, curve: Curves.easeInOut);
            },
            onSaved: (h) {
              setState(() {
                widget.question.heading = h.trim();
              });
            },
            controller: _headingController,
            style: Theme.of(context).brightness == Brightness.dark
                   ? DarkTheme.formFieldTextStyle
                   : LightTheme.formFieldTextStyle,
            minLines: 12,
            maxLines: 12,
            validator: (value) => Constant.questionHeadingValidator(value),
            maxLength: 100,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              filled: true,
              fillColor: Theme.of(context).brightness == Brightness.dark
                  ? DarkTheme.textFieldFillColor
                  : LightTheme.textFieldFillColor,
              border: null,
              focusedBorder: null,
              contentPadding: Constant.formFieldContentPadding,
              hintText: "What is the question about?",
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
