import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ReportCard extends StatelessWidget {
  final Report report;
  final String contentCollection;
  final String contentDocId;

  const ReportCard(
      {Key key,
      @required this.report,
      @required this.contentCollection,
      @required this.contentDocId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      margin: Constant.cardMargin,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //reporter username if he is prof a star in the same row
          Padding(
            padding: Constant.cardPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 12,
                ),
                StreamBuilder(
                  stream:
                      Firestore.instance.collection('Users').document(report.reporter).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      User reporter = User.fromSnapshot(snapshot.data);
                      return GestureDetector(
                        onTap: () {
                          Constant.userProfileView(context, userId: reporter.id);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.person),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              reporter.userName,
                              style: Theme.of(context).brightness == Brightness.dark
                                  ? DarkTheme.usernameStyle
                                  : LightTheme.usernameStyle,
                            ),
                            Spacer(),
                            reporter.isProf
                                ? Icon(
                                    Icons.star,
                                    color: Colors.orangeAccent,
                                    size: 20.0,
                                  )
                                : Container(),
                          ],
                        ),
                      );
                    } else {
                      return Container(
                        height: 18.0,
                      );
                    }
                  },
                ),
                SizedBox(
                  height: 16.0,
                ),
                //markdown bullet list of violations list
                MarkdownBody(
                  shrinkWrap: true,
                  data: ReportReviewFlow.violationsMarkdown(report.violations),
                ),
                //comment
                SizedBox(
                  height: 8,
                ),
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 8.0,
                  ),
                  decoration: BoxDecoration(
                      border: Border(
                    left: BorderSide(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? DarkTheme.chipBackgroundColor
                          : LightTheme.chipBackgroundColor,
                      width: 4.0,
                    ),
                  )),
                  child: Text(report.comment),
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
          //discard button with delete icon
          SizedBox(
            width: double.maxFinite,
            height: 40.0,
            child: ReportDiscardButton(
              callback: () async {
                showDialog(
                  context: context,
                  builder: (context) {
                    return ReportDiscardConfirmationAlert(
                      cancelCallback: () {
                        Navigator.of(context).pop();
                      },
                      discardCallback: () async {
                        Navigator.of(context).pop();
                        bool stat = await report.delete(contentCollection, contentDocId);
                        stat
                            ? Constant.showToastSuccess("Report discarded")
                            : Constant.showToastError("Discarding Failed");
                      },
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class ReportReviewFlow {
  static String violationsMarkdown(List<String> violationsList) {
    return "- " + violationsList.reduce((value, element) => value + "\n- " + element);
  }
}
