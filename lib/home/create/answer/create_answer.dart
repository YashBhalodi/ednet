import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/feed/question/question_tile_header.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
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
      bool success = await _answer.uploadAnswer(true);
      if (success) {
        Constant.showToastSuccess("Answer posted successfully");
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
    _answer.content = _zefyrController.document.toPlainText();
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
        bool success = await _answer.uploadAnswer(false);
        if (success) {
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
                          return Center(
                            child: SizedBox(
                              height: 32.0,
                              width: 32.0,
                              child: Constant.greenCircularProgressIndicator,
                            ),
                          );
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
                    style: Constant.sectionSubHeadingStyle,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    "Write to your heart's content.\nClear and Concise answer encourages more upvotes.\nUse formatting to structure your answer.",
                    style: Constant.formFieldHintStyle,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    "Once answer is published it can't be edited or removed.\nSave your answer as draft and publish it once you are confident.",
                    style: Constant.formFieldHintStyle,
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
                      fillColor: Colors.grey[200],
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
                      child: RaisedButton(
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
                        onPressed: () async {
                          if (_draftLoading == false) {
                            await _saveAnswerDraft();
                          }
                        },
                        padding: Constant.raisedButtonPaddingHigh,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                          ),
                          side: BorderSide(color: Colors.grey[300], width: 2.0),
                        ),
                        color: Colors.white,
                        disabledColor: Colors.grey[300],
                      ),
                    ),
                    Expanded(
                      child: RaisedButton(
                        onPressed: () async {
                          if (_postLoading == false) {
                            await _publishAnswer();
                          }
                        },
                        textColor: Colors.white,
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
                                "Post Answer",
                                style: Constant.primaryCTATextStyle,
                              ),
                        padding: Constant.raisedButtonPaddingHigh,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                          ),
                          side: BorderSide(color: Colors.blue[400], width: 2.0),
                        ),
                        color: Colors.blue[700],
                        disabledColor: Colors.grey[300],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
