import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:flutter/material.dart';
import 'package:zefyr/zefyr.dart';

class DescriptionPage extends StatefulWidget {
  final Question question;
  final PageController parentPageController;
  final ZefyrController zefyrDescriptionController;

  const DescriptionPage(
      {Key key,
      @required this.question,
      @required this.parentPageController,
      @required this.zefyrDescriptionController})
      : super(key: key);

  @override
  _DescriptionPageState createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> with AutomaticKeepAliveClientMixin {
  ScrollController _scrollController = ScrollController();
  FocusNode _descriptionFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _descriptionFocus.addListener(() {
      if (_descriptionFocus.hasFocus) {
        _scrollController.animateTo(150,
            duration: Constant.scrollAnimationDuration, curve: Curves.easeInOut);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _descriptionFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ZefyrScaffold(
      child: Scrollbar(
        child: ListView(
          shrinkWrap: true,
          padding: Constant.edgePadding,
          controller: _scrollController,
          children: <Widget>[
            Text(
              "Description",
              style: Theme.of(context).brightness == Brightness.dark
                  ? DarkTheme.headingStyle
                  : LightTheme.headingStyle,
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              "Explain your question in details\n\nIt's best to be clear, concise and to the point.",
              style: Theme.of(context).brightness == Brightness.dark
                  ? DarkTheme.headingDescriptionStyle
                  : LightTheme.headingDescriptionStyle,
            ),
            SizedBox(
              height: 64.0,
            ),
            ZefyrField(
              imageDelegate: null,
              height: 350.0,
              controller: widget.zefyrDescriptionController,
              focusNode: _descriptionFocus,
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.dark
                    ? DarkTheme.textFieldFillColor
                    : LightTheme.textFieldFillColor,
                border: null,
                focusedBorder: null,
                contentPadding: Constant.zefyrFieldContentPadding,
                hintText: "Describe the question in details...",
              ),
              autofocus: true,
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
