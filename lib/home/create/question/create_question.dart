import 'dart:convert';

import 'package:ednet/home/create/question/description_page.dart';
import 'package:ednet/home/create/question/heading_page.dart';
import 'package:ednet/home/create/question/preview_question_page.dart';
import 'package:ednet/home/create/question/question_topic_selection_page.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';

class CreateQuestion extends StatefulWidget {
  final Question question;

  const CreateQuestion({Key key, this.question}) : super(key: key);

  @override
  _CreateQuestionState createState() => _CreateQuestionState();
}

class _CreateQuestionState extends State<CreateQuestion> {
  GlobalKey _questionFormKey = GlobalKey<FormState>();
  Question _question;
  double _progressValue = 1 / 4;
  PageController _pageController = PageController(
    initialPage: 0,
  );
  List<String> _selectedTopics;
  bool _draftLoading = false;
  bool _postLoading = false;
  ZefyrController _zefyrController;

  Future<void> _publishQuestion() async {
    setState(() {
      _postLoading = true;
    });
    bool validForm = await _validateSaveQuestionForm();
    if (validForm) {
      bool success = await _question.uploadQuestion();
      if (widget.question != null) {
        //Draft question finally published. Need to delete the Draft instance of the question
        await widget.question.delete();
      }
      if (success) {
        Constant.showToastSuccess("Question published successfully");
      } else {
        Constant.showToastError("Failed to post question");
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
    await _saveQuestionForm();
    bool success = widget.question == null
        ? await _question.uploadQuestion()
        : await _question.updateQuestion();
    if (success) {
      widget.question == null
          ? Constant.showToastSuccess("Draft saved successfully")
          : Constant.showToastSuccess("Draft updated successfully");
    } else {
      Constant.showToastError("Failed to save draft");
    }
    setState(() {
      _draftLoading = false;
    });
  }

  Future<void> _saveQuestionForm() async {
    _question.createdOn = _question.createdOn ?? DateTime.now();
    _question.upvoteCount = 0;
    _question.downvoteCount = 0;
    _question.userId = await Constant.getCurrentUserDocId();
    _question.editedOn = DateTime.now();
    _question.topics = _selectedTopics;
    _question.byProf = await Constant.isUserProfById(userId: _question.userId);
    _question.upvoters = [];
    _question.downvoters = [];
    _question.isDraft = true;
    _question.description = _zefyrController.document.toPlainText();
    _question.descriptionJson = jsonEncode(_zefyrController.document.toJson());
    _question.answerCount = widget?.question?.answerCount ?? 0;
    final FormState form = _questionFormKey.currentState;
    form.save();
  }

  Future<bool> _validateSaveQuestionForm() async {
    _question.createdOn = DateTime.now();
    _question.upvoteCount = 0;
    _question.downvoteCount = 0;
    _question.userId = await Constant.getCurrentUserDocId();
    _question.editedOn = DateTime.now();
    _question.topics = _selectedTopics;
    _question.byProf = await Constant.isUserProfById(userId: _question.userId);
    _question.upvoters = [];
    _question.downvoters = [];
    _question.isDraft = false;
    _question.description = _zefyrController.document.toPlainText();
    _question.descriptionJson = jsonEncode(_zefyrController.document.toJson());
    _question.answerCount = widget?.question?.answerCount ?? 0;
    String descriptionResponse = Constant.questionDescriptionValidator(_question.description);
    if (descriptionResponse == null) {
      final FormState form = _questionFormKey.currentState;
      if (form.validate() && _selectedTopics.length != 0) {
        form.save();
        return true;
      } else {
        Constant.showToastInstruction("Atleast one topic should be selected.");
        return false;
      }
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _question = widget.question == null ? Question() : widget.question;
    _selectedTopics = widget.question == null ? List() : widget.question.topics;
    _zefyrController = widget.question == null
        ? ZefyrController(
            NotusDocument.fromDelta(
              Delta(),
            ),
          )
        : ZefyrController(
            NotusDocument.fromJson(
              json.decode(
                _question?.descriptionJson ?? null,
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
            "Ask Question...",
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
                key: _questionFormKey,
                child: PageView(
                  physics: ScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  controller: _pageController,
                  onPageChanged: (p) async {
                    if (p == 3) {
                      FocusScope.of(context).unfocus();
                      await _saveQuestionForm();
                    }
                    if (p == 2) {
                      FocusScope.of(context).unfocus();
                    }
                    setState(() {
                      _progressValue = (p + 1) / 4;
                    });
                  },
                  children: <Widget>[
                    HeadingPage(
                      question: _question,
                      parentPageController: _pageController,
                    ),
                    DescriptionPage(
                      question: _question,
                      parentPageController: _pageController,
                      zefyrDescriptionController: _zefyrController,
                    ),
                    QuestionTopicSelection(
                      question: _question,
                      parentPageController: _pageController,
                      topicsList: _selectedTopics,
                    ),
                    PreviewQuestion(
                      question: _question,
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
                          onPressed: _progressValue == 1 / 4
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
                                    style: Constant.secondaryCTATextStyle,
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
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation(Colors.white),
                                        backgroundColor: Colors.blue[50],
                                      ),
                                    ),
                                  )
                                : Text(
                                    "Publish",
                                    style: Constant.primaryCTATextStyle,
                                  ),
                            callback: () async {
                              if (_postLoading == false) {
                                await _publishQuestion();
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
