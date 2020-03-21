import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:flutter/material.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';

class TopicSelection extends StatefulWidget {
  final Question question;
  final PageController parentPageController;
  final List<String> topicsList;

  const TopicSelection({Key key, @required this.question, @required this.parentPageController,@required this.topicsList,})
      : super(key: key);

  @override
  _TopicSelectionState createState() => _TopicSelectionState();
}

class _TopicSelectionState extends State<TopicSelection> with AutomaticKeepAliveClientMixin{

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
          "To reach out to maximum interested users,\nselect at most 3 topics related to your question.",
          style: Constant.sectionSubHeadingDescriptionStyle,
        ),
        SizedBox(
          height: 16.0,
        ),
        StreamBuilder(
          stream: Firestore.instance.collection('Topics').getDocuments().asStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (!snapshot.hasError) {
                List<DocumentSnapshot> docList = snapshot.data.documents;
                if (docList.isEmpty) {
                  return Center(
                    child: Container(
                      child: Text(
                          "No Topics created by any university admin yet.\n\nPlease save your question as draft and tray again after some time."),
                    ),
                  );
                } else {
                  List<String> topicList = List.generate(docList.length, (i) => docList[i]['title']);
                  topicList.sort();
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: docList.length,
                    itemBuilder: (context, i) {
                      return MyCheckBoxTile(title: topicList[i],outputList: widget.topicsList,maxElement: 3,);
                    },
                  );
                }
              } else {
                return Center(
                  child: Container(
                    child: Text("Error"),
                  ),
                );
              }
            } else {
              return Center(
                child: Constant.greenCircularProgressIndicator,
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