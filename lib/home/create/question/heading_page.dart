import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/contants.dart';
import 'package:flutter/material.dart';

class HeadingPage extends StatefulWidget {
  final Question question;
  final PageController parentPageController;

  const HeadingPage({Key key, @required this.question, @required this.parentPageController})
      : super(key: key);

  @override
  _HeadingPageState createState() => _HeadingPageState();
}

class _HeadingPageState extends State<HeadingPage> with AutomaticKeepAliveClientMixin{
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
    return ListView(
      shrinkWrap: true,
      padding: Constant.edgePadding,
      controller: _scrollController,
      children: <Widget>[
        Text(
          "Heading",
          style: Constant.sectionSubHeadingStyle,
        ),
        SizedBox(
          height: 8.0,
        ),
        Text(
          "Briefly describe what your question is about.\n\nUsually, the name of relevant domain, concepts, theorms etc.",
          style: Constant.sectionSubHeadingDescriptionStyle,
        ),
        SizedBox(
          height: 64.0,
        ),
        TextFormField(
          onTap: () {
            _scrollController.animateTo(200.0,
                duration: Constant.scrollAnimationDuration, curve: Curves.easeInOut);
          },
          onEditingComplete: () {
              //For the first iteration onSaved of this textFormField is not being called for some reason. hence I put this hack. this actually compromises the validity criteria of heading parameter of question. so need to fix this. TODO FIX saving of heading of question
              /*setState(() {
                  widget.question.heading = _headingController.text;
              });*/
            widget.parentPageController
                .nextPage(duration: Constant.pageAnimationDuration, curve: Curves.easeInOut);
          },
          onSaved: (h) {
            setState(() {
              widget.question.heading = h;
            });
          },
          controller: _headingController,
          style: Constant.formFieldTextStyle,
          minLines: 12,
          maxLines: 12,
          validator: (value) => Constant.questionHeadingValidator(value),
          maxLength: 100,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            border: null,
            focusedBorder: null,
            contentPadding: Constant.formFieldContentPadding,
            hintText: "What is the question about?",
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
