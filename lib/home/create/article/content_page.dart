import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:flutter/material.dart';

class ContentPage extends StatefulWidget {
  final Article article;
  final PageController parentPageController;

  const ContentPage({Key key,@required this.article,@required this.parentPageController}) : super(key: key);
  @override
  _ContentPageState createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> with AutomaticKeepAliveClientMixin{
  ScrollController _scrollController = ScrollController();
  TextEditingController _contentController;
  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.article.content);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _contentController.dispose();
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
          "Content",
          style: Constant.sectionSubHeadingStyle,
        ),
        SizedBox(
          height: 8.0,
        ),
        Text(
          "Feel free to distribute your knowledge with detailed description.",
          style: Constant.sectionSubHeadingDescriptionStyle,
        ),
        SizedBox(
          height: 64.0,
        ),
        TextFormField(
          /*onTap: () {
            _scrollController.animateTo(175.0,
                duration: Constant.scrollAnimationDuration, curve: Curves.easeInOut);
          },*/
          onEditingComplete: () {
            widget.parentPageController
                .nextPage(duration: Constant.pageAnimationDuration, curve: Curves.easeInOut);
            FocusScope.of(context).unfocus();
          },
          onSaved: (d) {
            setState(() {
              widget.article.content = d;
            });
          },
          controller: _contentController,
          style: Constant.formFieldTextStyle,
          minLines: 20,
          maxLines: 25,
          maxLength: 10000,
          validator: (value) => Constant.articleContentValidator(value),
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            border: null,
            focusedBorder: null,
            contentPadding: Constant.formFieldContentPadding,
            hintText: "The main content of article...",
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
