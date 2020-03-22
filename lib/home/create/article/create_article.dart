import 'package:ednet/home/create/article/article_topic_selection_page.dart';
import 'package:ednet/home/create/article/content_page.dart';
import 'package:ednet/home/create/article/preview_article_page.dart';
import 'package:ednet/home/create/article/subtitle_page.dart';
import 'package:ednet/home/create/article/title_page.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/material.dart';

class CreateArticle extends StatefulWidget {
  final Article article;

  const CreateArticle({Key key, this.article}) : super(key: key);

  @override
  _CreateArticleState createState() => _CreateArticleState();
}

class _CreateArticleState extends State<CreateArticle> {
  GlobalKey _articleFormKey = GlobalKey<FormState>();
  Article _article;
  double _progressValue = 1 / 5;
  PageController _pageController = PageController(
    initialPage: 0,
  );
  List<String> _selectedTopics;

  Future<void> _publishArticle() async {
    bool validForm = await _validateSaveArticleForm();
    if (validForm) {
      bool success = await _article.uploadArticle();
      if (widget.article != null) {
        //Draft article finally published. Need to delete the Draft instance of the article
        await widget.article.delete();
      }
      if (success) {
        Constant.showToastSuccess("Article published successfully");
      } else {
        Constant.showToastError("Failed to publish article.");
      }
      Navigator.of(context).pop();
    }
  }

  Future<void> _saveAsDraft() async {
    await _saveArticleForm();
    bool success =
        widget.article == null ? await _article.uploadArticle() : await _article.updateArticle();
    if (success) {
      widget.article == null
          ? Constant.showToastSuccess("Draft saved successfully")
          : Constant.showToastSuccess("Draft updated successfully");
    } else {
      Constant.showToastError("Failed to save draft");
    }
  }

  Future<void> _saveArticleForm() async {
    _article.createdOn = _article.createdOn ?? DateTime.now();
    _article.upvoteCount = 0;
    _article.downvoteCount = 0;
    _article.username = await Constant.getCurrentUsername();
    _article.editedOn = DateTime.now();
    _article.topics = _selectedTopics;
    _article.byProf = await Constant.isUserProf(_article.username);
    _article.upvoters = [];
    _article.downvoters = [];
    _article.isDraft = true;
    final FormState form = _articleFormKey.currentState;
    form.save();
  }

  Future<bool> _validateSaveArticleForm() async {
    _article.createdOn = DateTime.now();
    _article.upvoteCount = 0;
    _article.downvoteCount = 0;
    _article.username = await Constant.getCurrentUsername();
    _article.editedOn = DateTime.now();
    _article.topics = _selectedTopics;
    _article.byProf = await Constant.isUserProf(_article.username);
    _article.upvoters = [];
    _article.downvoters = [];
    _article.isDraft = false;
    final FormState form = _articleFormKey.currentState;
    if (form.validate() && _selectedTopics.length != 0) {
      form.save();
      return true;
    } else {
      Constant.showToastInstruction(
          "Title should be atleast 10 characters.\nContent should be atleast 100 character.\nAtleast one topic should be selected.");
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _article = widget.article == null ? Article() : widget.article;
    _selectedTopics = widget.article == null ? List() : widget.article.topics;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        //TODO implement dialog
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Write an article...",
            style: Constant.appBarTextStyle,
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Constant.myLinearProgressIndicator(_progressValue),
            Expanded(
              child: Form(
                key: _articleFormKey,
                child: PageView(
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  controller: _pageController,
                  onPageChanged: (p) async {
                    if (p == 4) {
                      await _saveArticleForm();
                    }
                    setState(() {
                      _progressValue = (p + 1) / 5;
                    });
                  },
                  children: <Widget>[
                    TitlePage(
                      article: _article,
                      parentPageController: _pageController,
                    ),
                    SubtitlePage(
                      article: _article,
                      parentPageController: _pageController,
                    ),
                    ContentPage(
                      article: _article,
                      parentPageController: _pageController,
                    ),
                    ArticleTopicSelection(
                      article: _article,
                      parentPageController: _pageController,
                      topicsList: _selectedTopics,
                    ),
                    ArticlePreview(
                      article: _article,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              child: SizedBox(
                height: 64.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: double.maxFinite,
                        child: RaisedButton(
                          onPressed: _progressValue == 1 / 5
                              ? null
                              : () {
                                  _pageController.previousPage(
                                      duration: Constant.pageAnimationDuration,
                                      curve: Curves.easeInOut);
                                },
                          padding: Constant.raisedButtonPaddingLow,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            side: BorderSide(color: Colors.grey[300], width: 2.0),
                          ),
                          color: Colors.white,
                          child: Icon(
                            Icons.navigate_before,
                            size: 24.0,
                            color: Colors.grey[800],
                          ),
                          disabledColor: Colors.grey[300],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Expanded(
                      flex: 4,
                      child: AnimatedCrossFade(
                        firstChild: SizedBox(
                          height: double.maxFinite,
                          width: double.maxFinite,
                          child: SecondaryCTA(
                            child: Text(
                              "Save Draft",
                              style: Constant.secondaryCTATextStyle,
                            ),
                            callback: () async {
                              await _saveAsDraft();
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        secondChild: SizedBox(
                          height: double.maxFinite,
                          width: double.maxFinite,
                          child: PrimaryCTA(
                            child: Text(
                              "Publish",
                              style: Constant.primaryCTATextStyle,
                            ),
                            callback: () async {
                              await _publishArticle();
                            },
                          ),
                        ),
                        crossFadeState: _progressValue == 1
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: Constant.scrollAnimationDuration,
                      ),
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: double.maxFinite,
                        child: RaisedButton(
                          onPressed: _progressValue == 1
                              ? null
                              : () {
                                  _pageController.nextPage(
                                      duration: Constant.pageAnimationDuration,
                                      curve: Curves.easeInOut);
                                },
                          padding: Constant.raisedButtonPaddingLow,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            side: BorderSide(color: Colors.grey[300], width: 2.0),
                          ),
                          color: Colors.white,
                          child: Icon(
                            Icons.navigate_next,
                            size: 24.0,
                            color: Colors.grey[800],
                          ),
                          disabledColor: Colors.grey[300],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
