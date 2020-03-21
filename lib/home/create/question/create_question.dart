import 'package:ednet/home/create/question/description_page.dart';
import 'package:ednet/home/create/question/heading_page.dart';
import 'package:ednet/home/create/question/preview_question_page.dart';
import 'package:ednet/home/create/question/topic_selection_page.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/contants.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/material.dart';

class CreateQuestion extends StatefulWidget {
  @override
  _CreateQuestionState createState() => _CreateQuestionState();
}

class _CreateQuestionState extends State<CreateQuestion> {
  GlobalKey _questionFormKey = GlobalKey<FormState>();
  Question _question = Question();
  double _progressValue = 1 / 4;
  PageController _pageController = PageController(
    initialPage: 0,
  );
  List<String> _selectedTopics = List();

  Future<void> _publishQuestion() async {
    await _saveQuestionForm();
    print(_question.toString());
    bool success = await _question.uploadQuestion();
    if (success) {
      Constant.showToastSuccess("Question posted successfully");
    } else {
      Constant.showToastError("Failed to post question");
    }
  }

  Future<void> _saveQuestionForm() async {
    _question.createdOn = DateTime.now();
    _question.upvoteCount = 0;
    _question.downvoteCount = 0;
    _question.username = await Constant.getCurrentUsername();
    _question.editedOn = null;
    _question.topics = _selectedTopics;
    final FormState form = _questionFormKey.currentState;
    if (form.validate()) {
      form.save();
    }
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
                          callback: () {
                            print("In CreateQuestion page:-" + _question.toString());
                            //TODO when saving/publish embed user name in _question object
                            //TODO similarly embed created time, edited time,upvotecount,downvotecount,upvoters,downvoters
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
