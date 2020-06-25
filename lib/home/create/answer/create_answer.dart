import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/feed/question/question_tile_header.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/notification_classes.dart';
import 'package:ednet/utilities_files/shimmer_widgets.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';

class CreateAnswer extends StatefulWidget {
  final Question question;
  final Answer answer;

  const CreateAnswer({Key key, this.question, this.answer}) : super(key: key);

  @override
  _CreateAnswerState createState() => _CreateAnswerState();
}

class _CreateAnswerState extends State<CreateAnswer> {
  ScrollController _scrollController = ScrollController();
  Answer _answer;
  bool _draftLoading = false;
  bool _postLoading = false;
  ZefyrController _zefyrController;
  FocusNode _contentFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _answer = widget.answer ?? Answer();
    _contentFocus.addListener(() {
      _scrollController.animateTo(250.0,
          duration: Constant.scrollAnimationDuration, curve: Curves.easeInOut);
    });
    _zefyrController = widget.answer == null
        ? ZefyrController(
            NotusDocument.fromDelta(
              Delta()..insert("\n"),
            ),
          )
        : ZefyrController(
            NotusDocument.fromJson(
              jsonDecode(_answer.contentJson),
            ),
          );
  }

  Future<void> _publishAnswer() async {
    setState(() {
      _postLoading = true;
    });
    bool valid = await _validateAndSave();
    if (valid) {
      if (widget.answer != null) {
        await widget.answer.delete();
      }
      DocumentReference ansDoc = await _answer.uploadAnswer(true);
      if (ansDoc != null) {
        Constant.showToastSuccess("Answer posted successfully");
        AnswerPostedNotification ansNotification = AnswerPostedNotification(
          type: "AnswerPosted",
          answerId: ansDoc.documentID,
          questionId: widget.question.id,
          ansAuthorId: _answer.userId,
        );
        ansNotification.sendNotification();
        Navigator.of(context).pop();
      } else {
        Constant.showToastError("Failed to post answer.");
      }
    }
    setState(() {
      _postLoading = false;
    });
  }

  Future<bool> _validateAndSave() async {
    _answer.content = _zefyrController.document.toPlainText().trim();
    String contentResponse = Constant.answerValidator(_answer.content);
    if (contentResponse == null) {
      _answer.contentJson = jsonEncode(_zefyrController.document.toJson());
      //[widget?.question?.id] is for writing a new answer to a published question,
      //[_answer.queID] is for editing a draft answer.
      _answer.queID = widget?.question?.id ?? _answer.queID;
      _answer.userId = widget?.answer?.userId ?? await Constant.getCurrentUserDocId();
      _answer.createdOn = DateTime.now();
      _answer.byProf =
          widget?.answer?.byProf ?? await Constant.isUserProfById(userId: _answer.userId);
      _answer.upvoteCount = 0;
      _answer.downvoteCount = 0;
      _answer.upvoters = [];
      _answer.downvoters = [];
      _answer.profUpvoteCount = 0;
      _answer.isDraft = false;
      return true;
    } else {
      return false;
    }
  }

  Future<void> _saveAnswerDraft() async {
    setState(() {
      _draftLoading = true;
    });
    bool valid = await _saveAnswerForm();
    if (valid) {
      if (widget.answer == null) {
        //first time saving as draft
        DocumentReference ansDoc = await _answer.uploadAnswer(false);
        if (ansDoc != null) {
          Constant.showToastSuccess("Draft saved successfully");
          FocusScope.of(context).unfocus();
          Navigator.of(context).pop();
        } else {
          Constant.showToastError("Failed to save draft");
        }
      } else {
        bool success = await _answer.update();
        if (success) {
          Constant.showToastSuccess("Draft saved successfully");
          FocusScope.of(context).unfocus();
          Navigator.of(context).pop();
        } else {
          Constant.showToastError("Failed to update draft");
        }
      }
    } else {
      Constant.showToastError("Failed to save draft");
    }
    setState(() {
      _draftLoading = false;
    });
  }

  Future<bool> _saveAnswerForm() async {
    try {
      _answer.queID = widget?.question?.id ?? _answer.queID;
      //Following will result in same output every time, but it will reduce one computation.
      _answer.userId = widget?.answer?.userId ?? await Constant.getCurrentUserDocId();
      _answer.createdOn = DateTime.now();
      _answer.byProf =
          widget?.answer?.byProf ?? await Constant.isUserProfById(userId: _answer.userId);
      _answer.upvoteCount = 0;
      _answer.downvoteCount = 0;
      _answer.upvoters = [];
      _answer.downvoters = [];
      _answer.isDraft = true;
      _answer.profUpvoteCount = 0;
      _answer.content = _zefyrController.document.toPlainText();
      _answer.contentJson = jsonEncode(_zefyrController.document.toJson());
      return true;
    } catch (e) {
      print("_saveAnswerForm()");
      print(e);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ZefyrScaffold(
          child: Scrollbar(
            child: ListView(
              shrinkWrap: true,
              controller: _scrollController,
              children: <Widget>[
                widget.question == null
                    ? StreamBuilder(
                        stream: Firestore.instance
                            .collection('Questions')
                            .document(_answer.queID)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.active) {
                            Question q = Question.fromSnapshot(snapshot.data);
                            return QuestionTile(
                              question: q,
                            );
                          } else {
                            return ShimmerQuestionTile();
                          }
                        },
                      )
                    : QuestionTile(
                        question: widget.question,
                      ),
                ListView(
                  shrinkWrap: true,
                  padding: Constant.edgePadding,
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    Text(
                      "Your Answer...",
                      style: Theme.of(context).brightness == Brightness.dark
                          ? DarkTheme.headingStyle
                          : LightTheme.headingStyle,
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      "Write to your heart's content.\nClear and Concise answer encourages more upvotes.\nUse formatting to structure your answer.",
                      style: Theme.of(context).brightness == Brightness.dark
                          ? DarkTheme.formFieldHintStyle
                          : LightTheme.formFieldHintStyle,
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      "Once answer is published it can't be edited or removed.\nSave your answer as draft and publish it once you are confident.",
                      style: Theme.of(context).brightness == Brightness.dark
                          ? DarkTheme.formFieldHintStyle
                          : LightTheme.formFieldHintStyle,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    ZefyrField(
                      imageDelegate: null,
                      height: 350.0,
                      controller: _zefyrController,
                      focusNode: _contentFocus,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).brightness == Brightness.dark
                            ? DarkTheme.textFieldFillColor
                            : LightTheme.textFieldFillColor,
                        border: null,
                        focusedBorder: null,
                        contentPadding: Constant.zefyrFieldContentPadding,
                      ),
                      autofocus: false,
                    ),
                  ],
                ),
                SizedBox(
                  height: 54.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: LeftSecondaryCTAButton(
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
                              await _saveAnswerDraft();
                            }
                          },
                        ),
                      ),
                      Expanded(
                        child: RightPrimaryBlueCTAButton(
                          child: _postLoading
                              ? Center(
                                  child: SizedBox(
                                    height: 24.0,
                                    width: 24.0,
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : Text(
                                  "Post Answer",
                                  style: Theme.of(context).brightness == Brightness.dark
                                      ? DarkTheme.primaryCTATextStyle
                                      : LightTheme.primaryCTATextStyle,
                                ),
                          callback: () async {
                            if (_postLoading == false) {
                              await _publishAnswer();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50.0,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
