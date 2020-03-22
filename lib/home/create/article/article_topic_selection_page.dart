import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/material.dart';

class ArticleTopicSelection extends StatefulWidget {
    final Article article;
    final PageController parentPageController;
    final List<String> topicsList;

  const ArticleTopicSelection({Key key,@required this.article,@required this.parentPageController,@required this.topicsList}) : super(key: key);
  @override
  _ArticleTopicSelectionState createState() => _ArticleTopicSelectionState();
}

class _ArticleTopicSelectionState extends State<ArticleTopicSelection> with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    super.build(context);
      return ListView(
          padding: Constant.edgePadding,
          shrinkWrap: true,
          children: <Widget>[
              Text(
                  "Topics",
                  style: Constant.sectionSubHeadingStyle,
              ),
              SizedBox(
                  height: 8.0,
              ),
              Text(
                  "To reach out to maximum interested users,\nselect at most 3 topics related to your article.",
                  style: Constant.sectionSubHeadingDescriptionStyle,
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
                                          child: Text("No topics created yet.\n\nPlease save your progress as Draft \nand try again at your leisure.",textAlign: TextAlign.center,),
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
                          return Center(
                              child: SizedBox(
                                  height: 28.0,
                                  width: 28.0,
                                  child: Constant.greenCircularProgressIndicator,
                              ),
                          );
                      }
                  },
              ),
          ],
      );
  }

  @override
  bool get wantKeepAlive => true;
}
