import 'package:ednet/home/create/question/description_page.dart';
import 'package:ednet/home/create/question/heading_page.dart';
import 'package:ednet/home/create/question/preview_question_page.dart';
import 'package:ednet/home/create/question/topic_selection_page.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/material.dart';

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

  Future<void> _publishQuestion() async {
    await _validateSaveQuestionForm();
    bool success = await _question.uploadQuestion();
    if(widget.question!=null) {
      //Draft question finally published. Need to delete the Draft instance of the question
      await widget.question.delete();
    }
    if (success) {
      Constant.showToastSuccess("Question posted successfully");
    } else {
      Constant.showToastError("Failed to post question");
    }
  }

  Future<void> _saveAsDraft() async {
    await _saveQuestionForm();
    bool success =
        widget.question == null ? await _question.uploadQuestion() : await _question.updateQuestion();
    if (success) {
      widget.question == null
          ? Constant.showToastSuccess("Draft saved successfully")
          : Constant.showToastSuccess("Draft updated successfully");
    } else {
      Constant.showToastError("Failed to save draft");
    }
  }

  Future<void> _saveQuestionForm() async {
    _question.createdOn = _question.createdOn??DateTime.now();
    _question.upvoteCount = 0;
    _question.downvoteCount = 0;
    _question.username = await Constant.getCurrentUsername();
    _question.editedOn = DateTime.now();
    _question.topics = _selectedTopics;
    _question.byProf = await Constant.isUserProf(_question.username);
    _question.upvoters = [];
    _question.downvoters = [];
    _question.isDraft = true;
    final FormState form = _questionFormKey.currentState;
    form.save();
  }

  Future<void> _validateSaveQuestionForm() async {
    _question.createdOn = DateTime.now();
    _question.upvoteCount = 0;
    _question.downvoteCount = 0;
    _question.username = await Constant.getCurrentUsername();
    _question.editedOn = DateTime.now();
    _question.topics = _selectedTopics;
    _question.byProf = await Constant.isUserProf(_question.username);
    _question.upvoters = [];
    _question.downvoters = [];
    _question.isDraft = false;
    final FormState form = _questionFormKey.currentState;
    if (form.validate()) {
      form.save();
    } else {}
  }

  @override
  void initState() {
    super.initState();
    _question = widget.question == null ? Question() : widget.question;
    _selectedTopics = widget.question == null ? List() : widget.question.topics;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //TODO will pop scope for save draft confirmation before exiting
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
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                controller: _pageController,
                onPageChanged: (p) async {
                  if (p == 3) {
                    await _saveQuestionForm();
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
                  ),
                  TopicSelection(
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
                            await _publishQuestion();
                            Navigator.of(context).pop();
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
    );
  }
}
