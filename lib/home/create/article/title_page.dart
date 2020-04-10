import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:flutter/material.dart';

class TitlePage extends StatefulWidget {
  final Article article;
  final PageController parentPageController;

  const TitlePage({Key key, @required this.article, @required this.parentPageController})
      : super(key: key);

  @override
  _TitlePageState createState() => _TitlePageState();
}

class _TitlePageState extends State<TitlePage> with AutomaticKeepAliveClientMixin {
  TextEditingController _titleController;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.article.title);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
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
          Text(
            "Title",
            style: Theme.of(context).brightness == Brightness.dark
                   ? DarkTheme.headingStyle
                   : LightTheme.headingStyle,
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            "Catchy title of your article.\n\nUsually, the name of relevant domain, concepts, theorms etc.",
            style: Theme
                       .of(context)
                       .brightness == Brightness.dark
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
                widget.article.title = h.trim();
              });
            },
            controller: _titleController,
            style: Theme.of(context).brightness == Brightness.dark
                   ? DarkTheme.formFieldTextStyle
                   : LightTheme.formFieldTextStyle,
            minLines: 12,
            maxLines: 12,
            validator: (value) => Constant.articleTitleValidator(value),
            maxLength: 100,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              filled: true,
              fillColor: Theme
                             .of(context)
                             .brightness == Brightness.dark
                         ? DarkTheme.textFieldFillColor
                         : LightTheme.textFieldFillColor,
              border: null,
              focusedBorder: null,
              contentPadding: Constant.formFieldContentPadding,
              hintText: "Attract readers with catchy, crispy and clear title...",
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
