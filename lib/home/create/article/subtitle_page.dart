import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:flutter/material.dart';

class SubtitlePage extends StatefulWidget {
  final Article article;
  final PageController parentPageController;

  const SubtitlePage({Key key, @required this.article, @required this.parentPageController})
      : super(key: key);

  @override
  _SubtitlePageState createState() => _SubtitlePageState();
}

class _SubtitlePageState extends State<SubtitlePage> with AutomaticKeepAliveClientMixin {
  TextEditingController _subtitleController;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _subtitleController = TextEditingController(text: widget.article.subtitle);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _subtitleController.dispose();
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
          "Subtitle",
          style: Constant.sectionSubHeadingStyle,
        ),
        SizedBox(
          height: 8.0,
        ),
        Text(
          "Provide brief overview of what you are covering in the article.",
          style: Constant.sectionSubHeadingDescriptionStyle,
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
              widget.article.subtitle = h;
            });
          },
          controller: _subtitleController,
          style: Constant.formFieldTextStyle,
          minLines: 12,
          maxLines: 12,
          validator: (value) => Constant.articleSubtitleValidator(value),
          maxLength: 200,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            border: null,
            focusedBorder: null,
            contentPadding: Constant.formFieldContentPadding,
            hintText: "Provide readers with value so that they might get curious...",
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
