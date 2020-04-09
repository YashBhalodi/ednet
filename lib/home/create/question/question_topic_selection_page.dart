import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/shimmer_widgets.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/material.dart';

class QuestionTopicSelection extends StatefulWidget {
  final Question question;
  final PageController parentPageController;
  final List<String> topicsList;

  const QuestionTopicSelection({
    Key key,
    @required this.question,
    @required this.parentPageController,
    @required this.topicsList,
  }) : super(key: key);

  @override
  _QuestionTopicSelectionState createState() => _QuestionTopicSelectionState();
}

class _QuestionTopicSelectionState extends State<QuestionTopicSelection>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scrollbar(
      child: ListView(
        padding: Constant.edgePadding,
        shrinkWrap: true,
        children: <Widget>[
          Text(
            "Topics",
            style: Theme.of(context).brightness == Brightness.dark
                   ? DarkTheme.headingStyle
                   : LightTheme.headingStyle,
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            "To reach out to maximum interested users,\nselect at most 3 topics related to your question.",
            style: Theme
                       .of(context)
                       .brightness == Brightness.dark
                   ? DarkTheme.headingDescriptionStyle
                   : LightTheme.headingDescriptionStyle,
          ),
          SizedBox(
            height: 16.0,
          ),
          StreamBuilder(
            stream: Firestore.instance.collection('Topics').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  if (snapshot.data.documents.length == 0) {
                    return Center(
                      child: Container(
                        child: Text(
                          "No topics created yet.\n\nPlease save your progress as Draft \nand try again at your leisure.",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  } else {
                    List<String> topicList = List.generate(
                        snapshot.data.documents.length, (i) => snapshot.data.documents[i]['title']);
                    topicList.sort();
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: topicList.length,
                      itemBuilder: (context, i) {
                        return MyCheckBoxTile(
                          title: topicList[i],
                          outputList: widget.topicsList,
                          maxElement: 3,
                        );
                      },
                    );
                  }
                } else {
                  return Center(
                    child: Container(
                      child: Text(
                          "Oops! Something went wrong.\nPlease save your progress as Draft if needed."),
                    ),
                  );
                }
              } else {
                return ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: List.generate(7, (i) => ShimmerTopicTile()),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
