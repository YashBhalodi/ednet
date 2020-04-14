//if no report present anymore. show message and move to next content report review page
//If possible, they should be able to review next reported content in the same sheet

import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/admin/reports/content_report_card.dart';
import 'package:ednet/home/feed/question/question_tile_header.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/shimmer_widgets.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnswerReportsReviewPage extends StatelessWidget {
    final Answer answer;

    AnswerReportsReviewPage({Key key, this.answer}) : super(key: key);

    int _reportCount;

    void _deleteAnswerDialog(BuildContext context) {
        showDialog(
            context: context,
            builder: (context) {
                return DeleteConfirmationAlert(
                    title: "Delete this Answer?",
                    msg: "Please note that it will be deleted forever from the server.",
                    cancelCallback: () {
                        Navigator.of(context).pop();
                    },
                    deleteCallback: () async {
                        bool stat = await answer.deletePublished();
                        stat
                        ? Constant.showToastSuccess("Answer Deleted Successfully")
                        : Constant.showToastError("Could not delete the Question");
                        Navigator.of(context).pop();
                        if (stat) {
                            Navigator.of(context).pop();
                        }
                    },
                );
            });
    }

    Widget _showPopUpMenu(context) {
        return PopupMenuButton<int>(
            offset: Offset.fromDirection(math.pi / 2, AppBar().preferredSize.height),
            itemBuilder: (context) {
                return [
                    PopupMenuItem(
                        value: 1,
                        child: Text("Discard all reports"),
                    ),
                ];
            },
            onSelected: (i) async {
                if (i == 1) {
                    showDialog(
                        context: context,
                        builder: (context) {
                            return ReportDiscardConfirmationAlert(
                                discardCallback: () async {
                                    Navigator.of(context).pop();
                                    bool stat = await answer.discardAllReports();
                                    stat
                                    ? Constant.showToastSuccess("All reports discarded")
                                    : Constant.showToastError("Operation failed");
                                    Navigator.of(context).pop();
                                },
                                cancelCallback: () {
                                    Navigator.of(context).pop();
                                },
                                allReports: true,
                            );
                        },
                    );
                }
            },
        );
    }

    @override
    Widget build(BuildContext context) {
        return SafeArea(
            child: Scaffold(
                appBar: AppBar(
                    title: Text(
                        "Answer Reports",
                        style: Theme
                                   .of(context)
                                   .brightness == Brightness.dark
                               ? DarkTheme.appBarTextStyle
                               : LightTheme.appBarTextStyle,
                    ),
                    actions: <Widget>[
                        _showPopUpMenu(context),
                    ],
                ),
                body: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                        Expanded(
                            child: Scrollbar(
                                child: ListView(
                                    children: <Widget>[
                                        ExpansionTile(
                                            initiallyExpanded: false,
                                            title: Text(
                                                "Question",
                                                style: Theme
                                                           .of(context)
                                                           .brightness == Brightness.dark
                                                       ? DarkTheme.dropDownMenuTitleStyle
                                                       : LightTheme.dropDownMenuTitleStyle,
                                            ),
                                            children: <Widget>[
                                                StreamBuilder(
                                                    stream: Firestore.instance
                                                        .collection('Questions')
                                                        .document(answer.queID)
                                                        .snapshots(),
                                                    builder: (context, snapshot) {
                                                        if (snapshot.hasData) {
                                                            return QuestionTile(
                                                                question: Question.fromSnapshot(
                                                                    snapshot.data));
                                                        } else {
                                                            return ShimmerQuestionTile();
                                                        }
                                                    },
                                                ),
                                            ],
                                        ),
                                        ExpansionTile(
                                            initiallyExpanded: true,
                                            title: Text(
                                                "Answer",
                                                style: Theme
                                                           .of(context)
                                                           .brightness == Brightness.dark
                                                       ? DarkTheme.dropDownMenuTitleStyle
                                                       : LightTheme.dropDownMenuTitleStyle,
                                            ),
                                            children: <Widget>[
                                                Padding(
                                                    padding: Constant.edgePadding,
                                                    child: AnswerContentView(
                                                        answer: answer,
                                                    ),
                                                ),
                                            ],
                                        ),
                                        ExpansionTile(
                                            title: Text(
                                                "Reports",
                                                style: Theme
                                                           .of(context)
                                                           .brightness == Brightness.dark
                                                       ? DarkTheme.dropDownMenuTitleStyle
                                                       : LightTheme.dropDownMenuTitleStyle,
                                            ),
                                            children: <Widget>[
                                                StreamBuilder(
                                                    stream: Firestore.instance
                                                        .collection('Answers')
                                                        .document(answer.id)
                                                        .collection('reports')
                                                        .snapshots(),
                                                    builder: (context, snapshot) {
                                                        if (snapshot.hasData) {
                                                            _reportCount =
                                                                snapshot.data.documents.length;
                                                            return ListView.builder(
                                                                shrinkWrap: true,
                                                                physics: NeverScrollableScrollPhysics(),
                                                                itemCount: snapshot.data.documents
                                                                    .length,
                                                                itemBuilder: (_, i) {
                                                                    Report r = Report.fromSnapshot(
                                                                        snapshot.data.documents[i]);
                                                                    return ReportCard(
                                                                        contentCollection: 'Answers',
                                                                        contentDocId: answer.id,
                                                                        report: r,
                                                                    );
                                                                });
                                                        } else {
                                                            //TODO shimmer loader
                                                            return Container();
                                                        }
                                                    },
                                                ),
                                            ],
                                        ),
                                    ],
                                ),
                            ),
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: SizedBox(
                                width: double.maxFinite,
                                height: 64,
                                child: NegativePrimaryButton(
                                    callback: () {
                                        if (_reportCount < 5) {
                                            Constant.showToastInstruction(
                                                "Atleast 5 reports needed to remove this answer");
                                        } else {
                                            _deleteAnswerDialog(context);
                                        }
                                    },
                                    child: Text(
                                        "Delete This Answer",
                                        style: Theme
                                                   .of(context)
                                                   .brightness == Brightness.dark
                                               ? DarkTheme.negativePrimaryButtonTextStyle
                                               : LightTheme.negativePrimaryButtonTextStyle,
                                    ),
                                ),
                            ),
                        )
                    ],
                ),
            ),
        );
    }
}
