import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/create/article/article_topic_selection_page.dart';
import 'package:ednet/home/create/article/content_page.dart';
import 'package:ednet/home/create/article/preview_article_page.dart';
import 'package:ednet/home/create/article/subtitle_page.dart';
import 'package:ednet/home/create/article/title_page.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/notification_classes.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';

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
  bool _draftLoading = false;
  bool _postLoading = false;
  ZefyrController _zefyrController;

  Future<void> _publishArticle() async {
    setState(() {
      _postLoading = true;
    });
    bool validForm = await _validateSaveArticleForm();
    if (validForm) {
      DocumentReference articleDoc = await _article.uploadArticle();
      if (widget.article != null) {
        //Draft article finally published. Need to delete the Draft instance of the article
        await widget.article.delete();
      }
      if (articleDoc != null) {
        Constant.showToastSuccess("Article published successfully");
        ArticlePostedNotification articleNotification = ArticlePostedNotification(type: "ArticlePosted",articleId: articleDoc.documentID,authorId: _article.userId);
        articleNotification.sendNotification(articleDoc);
      } else {
        Constant.showToastError("Failed to publish article.");
      }
      Navigator.of(context).pop();
    }
    setState(() {
      _postLoading = false;
    });
  }

  Future<void> _saveAsDraft() async {
    setState(() {
      _draftLoading = true;
    });
    await _saveArticleForm();
    bool success = widget.article == null
        ? (await _article.uploadArticle() == null ? false : true)
        : await _article.updateArticle();
    if (success) {
      widget.article == null
          ? Constant.showToastSuccess("Draft saved successfully")
          : Constant.showToastSuccess("Draft updated successfully");
    } else {
      Constant.showToastError("Failed to save draft");
    }
    setState(() {
      _draftLoading = false;
    });
  }

  Future<void> _saveArticleForm() async {
    _article.createdOn = _article.createdOn ?? DateTime.now();
    _article.upvoteCount = 0;
    _article.downvoteCount = 0;
    _article.editedOn = DateTime.now();
    //Following will result in same output every time, but it will reduce one computation.
    _article.userId = _article?.userId ?? await Constant.getCurrentUserDocId();
    _article.topics = _selectedTopics;
    _article.byProf = _article?.byProf ?? await Constant.isUserProfById(userId: _article.userId);
    _article.upvoters = [];
    _article.downvoters = [];
    _article.isDraft = true;
    _article.profUpvoteCount = 0;
    _article.reportCount = 0;
    _article.contentJson = jsonEncode(_zefyrController.document.toJson());
    _article.content = _zefyrController.document.toPlainText();
    final FormState form = _articleFormKey.currentState;
    form.save();
  }

  Future<bool> _validateSaveArticleForm() async {
    _article.createdOn = DateTime.now();
    _article.upvoteCount = 0;
    _article.downvoteCount = 0;
    _article.editedOn = DateTime.now();
    _article.topics = _selectedTopics;
    _article.userId = _article?.userId ?? await Constant.getCurrentUserDocId();
    _article.byProf = _article?.byProf ?? await Constant.isUserProfById(userId: _article.userId);
    _article.upvoters = [];
    _article.downvoters = [];
    _article.isDraft = false;
    _article.profUpvoteCount = 0;
    _article.reportCount = 0;
    _article.contentJson = jsonEncode(_zefyrController.document.toJson());
    _article.content = _zefyrController.document.toPlainText().trim();
    String contentResponse = Constant.articleContentValidator(_article.content);
    if (contentResponse == null) {
      final FormState form = _articleFormKey.currentState;
      if (_selectedTopics.length == 0) {
        Constant.showToastInstruction("Atleast one topic should be selected.");
        return false;
      }
      if (form.validate()) {
        form.save();
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _article = widget.article == null ? Article() : widget.article;
    _selectedTopics = widget.article == null ? List() : widget.article.topics;
    _zefyrController = widget.article == null
        ? ZefyrController(
            NotusDocument.fromDelta(
              Delta()..insert("\n"),
            ),
          )
        : ZefyrController(
            NotusDocument.fromJson(
              json.decode(
                _article?.contentJson ?? null,
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Write an article...",
            style: Theme.of(context).brightness == Brightness.dark
                ? DarkTheme.appBarTextStyle
                : LightTheme.appBarTextStyle,
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
                  physics: ScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  controller: _pageController,
                  onPageChanged: (p) async {
                    if (p == 4) {
                      FocusScope.of(context).unfocus();
                      await _saveArticleForm();
                    }
                    if (p == 2 || p == 3) {
                      FocusScope.of(context).unfocus();
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
                      contentZefyrController: _zefyrController,
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
                        child: StepButton(
                          callback: _progressValue == 1 / 5
                                    ? null
                                    : () {
                            _pageController.previousPage(
                                duration: Constant.pageAnimationDuration,
                                curve: Curves.easeInOut);
                          },
                          direction: 'prev',
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
                            child: _draftLoading
                                ? Center(
                                    child: SizedBox(
                                      height: 24.0,
                                      width: 24.0,
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : Text(
                                    "Save Draft",
                                    style: Theme.of(context).brightness == Brightness.dark
                                        ? DarkTheme.secondaryCTATextStyle
                                        : LightTheme.secondaryCTATextStyle,
                                  ),
                            callback: () async {
                              if (_draftLoading == false) {
                                await _saveAsDraft();
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                        ),
                        secondChild: SizedBox(
                          height: double.maxFinite,
                          width: double.maxFinite,
                          child: PrimaryBlueCTA(
                            child: _postLoading
                                ? Center(
                                    child: SizedBox(
                                      height: 24.0,
                                      width: 24.0,
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : Text(
                                    "Publish",
                                    style: Theme.of(context).brightness == Brightness.dark
                                        ? DarkTheme.primaryCTATextStyle
                                        : LightTheme.primaryCTATextStyle,
                                  ),
                            callback: () async {
                              if (_postLoading == false) {
                                await _publishArticle();
                              }
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
                        child: StepButton(
                          callback: _progressValue == 1
                                    ? null
                                    : () {
                            _pageController.nextPage(
                                duration: Constant.pageAnimationDuration,
                                curve: Curves.easeInOut);
                          },
                          direction: 'next',
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
