import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/shimmer_widgets.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/material.dart';

class UserTopicListTile extends StatefulWidget {
  final User user;

  const UserTopicListTile({Key key, @required this.user}) : super(key: key);

  @override
  _UserTopicListTileState createState() => _UserTopicListTileState();
}

class _UserTopicListTileState extends State<UserTopicListTile> {
  List<String> _selectedTopicList;

  Future<bool> updateTopics() async {
    widget.user.topics = _selectedTopicList;
    bool success = await widget.user.updateTopicList();
    if (success) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedTopicList = widget.user.topics;
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        "Interested topics",
        style: Theme.of(context).brightness == Brightness.dark
            ? DarkTheme.dropDownMenuTitleStyle
            : LightTheme.dropDownMenuTitleStyle,
      ),
      initiallyExpanded: false,
      children: <Widget>[
        ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Padding(
              padding: Constant.edgePadding,
              child: Text(
                "Select all the topics that interest you...",
                style: Theme.of(context).brightness == Brightness.dark
                    ? DarkTheme.headingDescriptionStyle
                    : LightTheme.headingDescriptionStyle,
              ),
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
                            "No topics created yet.\n\nPlease try again at your leisure.",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    } else {
                      List<String> topicList = List.generate(snapshot.data.documents.length,
                          (i) => snapshot.data.documents[i]['title']);
                      topicList.sort();
                      return Scrollbar(
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: topicList.length,
                          itemBuilder: (context, i) {
                            return MyCheckBoxTile(
                              title: topicList[i],
                              outputList: _selectedTopicList,
                            );
                          },
                        ),
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
                  return Scrollbar(
                    child: ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: List.generate(7, (i) => ShimmerTopicTile()),
                    ),
                  );
                }
              },
            ),
            Padding(
              padding: Constant.edgePadding,
              child: BlueOutlineButton(
                child: Text(
                  "Update topic preferences",
                  style: Theme.of(context).brightness == Brightness.dark
                      ? DarkTheme.outlineButtonTextStyle
                      : LightTheme.outlineButtonTextStyle,
                ),
                callback: () async {
                  bool stat = await updateTopics();
                  if (stat) {
                    Constant.showToastSuccess("Topics list updated successfully");
                  } else {
                    Constant.showToastError("Topics list update failed");
                  }
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
