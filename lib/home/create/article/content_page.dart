import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:flutter/material.dart';
import 'package:zefyr/zefyr.dart';

class ContentPage extends StatefulWidget {
  final Article article;
  final PageController parentPageController;
  final ZefyrController contentZefyrController;

  const ContentPage({Key key, @required this.article, @required this.parentPageController,@required this.contentZefyrController})
      : super(key: key);

  @override
  _ContentPageState createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> with AutomaticKeepAliveClientMixin {
  ScrollController _scrollController = ScrollController();
  TextEditingController _contentController;
  FocusNode _contentFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.article.content);
    _contentFocus.addListener((){
      if(_contentFocus.hasFocus){
        _scrollController.animateTo(150.0, duration: Constant.scrollAnimationDuration, curve: Curves.easeInOut);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _contentController.dispose();
    _contentFocus.dispose();
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
              "Content",
              style: Theme.of(context).brightness == Brightness.dark
                     ? DarkTheme.headingStyle
                     : LightTheme.headingStyle,
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              "Feel free to write to your heart's content.",
              style: Theme
                         .of(context)
                         .brightness == Brightness.dark
                     ? DarkTheme.headingDescriptionStyle
                     : LightTheme.headingDescriptionStyle,
            ),
            SizedBox(
              height: 64.0,
            ),
            ZefyrField(
              imageDelegate: null,
              height: 350.0,
              controller: widget.contentZefyrController,
              focusNode: _contentFocus,
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.dark
                           ? DarkTheme.textFieldFillColor
                           : LightTheme.textFieldFillColor,
                border: null,
                focusedBorder: null,
                contentPadding: Constant.zefyrFieldContentPadding,
                hintText: "The main content of article...",
              ),
              autofocus: true,
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
