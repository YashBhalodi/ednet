//if no report present anymore. show message and move to next content report review page
//If possible, they should be able to review next reported content in the same sheet

import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/admin/reports/content_report_card.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/material.dart';

class ArticleReportsReviewPage extends StatelessWidget {
  final Article article;
  final Function parentRebuildCallback;

  ArticleReportsReviewPage({Key key, this.article, this.parentRebuildCallback}) : super(key: key);

  int _reportCount;

  void _deleteArticleDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return DeleteConfirmationAlert(
            title: "Delete this Article?",
            msg: "Please note that it will be deleted forever from the server.",
            cancelCallback: () {
              Navigator.of(context).pop();
            },
            deleteCallback: () async {
              bool stat = await article.deletePublished();
              stat
              ? Constant.showToastSuccess("Article Deleted Successfully")
              : Constant.showToastError("Could not delete the Article");
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
                  bool stat = await article.discardAllReports();
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
    return WillPopScope(
      onWillPop: () async {
        parentRebuildCallback();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Article Reports",
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
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Scrollbar(
                  child: ListView(
                    children: <Widget>[
                      ExpansionTile(
                        initiallyExpanded: true,
                        title: Text(
                          "Article",
                          style: Theme
                                     .of(context)
                                     .brightness == Brightness.dark
                                 ? DarkTheme.dropDownMenuTitleStyle
                                 : LightTheme.dropDownMenuTitleStyle,
                        ),
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: Theme
                                             .of(context)
                                             .brightness == Brightness.dark
                                         ? DarkTheme.questionTileShadow
                                         : LightTheme.questionTileShadow,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(16.0),
                                bottomRight: Radius.circular(16.0),
                              ),
                              color: Theme
                                         .of(context)
                                         .brightness == Brightness.dark
                                     ? DarkTheme.questionTileHeaderBackgroundColor
                                     : LightTheme.questionTileHeaderBackgroundColor,
                            ),
                            margin: EdgeInsets.only(bottom: 12.0),
                            padding: Constant.edgePadding,
                            child: ArticleContentView(
                              article: article,
                            ),
                          ),
                        ],
                      ),
                      ExpansionTile(
                        initiallyExpanded: true,
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
                                .collection('Articles')
                                .document(article.id)
                                .collection('reports')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                _reportCount = snapshot.data.documents.length;
                                if (snapshot.data.documents.length > 0) {
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: snapshot.data.documents.length,
                                      itemBuilder: (_, i) {
                                        Report r = Report.fromSnapshot(snapshot.data.documents[i]);
                                        return ReportCard(
                                          contentCollection: 'Articles',
                                          contentDocId: article.id,
                                          report: r,
                                        );
                                      });
                                } else {
                                  return SizedBox(
                                    height: 60,
                                    child: Center(
                                      child: Text(
                                        "Zero report for this article",
                                        style: Theme
                                                   .of(context)
                                                   .brightness == Brightness.dark
                                               ? DarkTheme.headingDescriptionStyle
                                               : LightTheme.headingDescriptionStyle,
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                //TODO shimmer loader
                                return Container();
                              }
                            },
                          ),
                        ],
                      )
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
                      if (_reportCount < Constant.reportThreshold) {
                        Constant.showToastInstruction(
                            "Atleast ${Constant.reportThreshold} reports needed to remove this answer");
                      } else {
                        _deleteArticleDialog(context);
                      }
                    },
                    child: Text(
                      "Delete This Article",
                      style: Theme
                                 .of(context)
                                 .brightness == Brightness.dark
                             ? DarkTheme.negativePrimaryButtonTextStyle
                             : LightTheme.negativePrimaryButtonTextStyle,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50,),
            ],
          ),
        ),
      ),
    );
  }
}
