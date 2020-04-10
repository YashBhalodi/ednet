import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/shimmer_widgets.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/material.dart';

class UniversityTopicListTile extends StatefulWidget {
  final User user;

  const UniversityTopicListTile({Key key, @required this.user}) : super(key: key);

  @override
  _UniversityTopicListTileState createState() => _UniversityTopicListTileState();
}

class _UniversityTopicListTileState extends State<UniversityTopicListTile> {
  GlobalKey _topicFormKey = GlobalKey<FormState>();
  FocusNode _topicFieldFocus = FocusNode();
  FocusNode _topicCreateButtonFocus = FocusNode();
  TextEditingController _topicFieldController = TextEditingController();
  String _topicValidatorResponse;
  List<String> _selectedTopicList = new List();
  String _inputTopicName;
  University _university;

  Future<void> createTopic(String title) async {
    try {
      Firestore.instance.collection('Topics').add({
        'title': title,
      });
    } catch (e) {
      print("createTopic");
      print(e);
    }
  }

  Future<void> _showTopicCreatingDialog() async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          elevation: 20.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Form(
                key: _topicFormKey,
                child: TextFormField(
                  controller: _topicFieldController,
                  onSaved: (value) {
                    _inputTopicName = value.capitalize().trim();
                  },
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(_topicCreateButtonFocus);
                  },
                  validator: (value) {
                    return _topicValidatorResponse;
                  },
                  keyboardType: TextInputType.text,
                  style: Theme.of(context).brightness == Brightness.dark
                      ? DarkTheme.formFieldTextStyle
                      : LightTheme.formFieldTextStyle,
                  decoration: InputDecoration(
                    counterStyle: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.counterStyle
                        : LightTheme.counterStyle,
                    contentPadding: Constant.formFieldContentPadding,
                    hintText: "Kinematics",
                    hintStyle: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.formFieldHintStyle
                        : LightTheme.formFieldHintStyle,
                    border: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.formFieldBorder
                        : LightTheme.formFieldBorder,
                    focusedBorder: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.formFieldFocusedBorder
                        : LightTheme.formFieldFocusedBorder,
                    labelText: "Topic Name",
                    labelStyle: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.formFieldLabelStyle
                        : LightTheme.formFieldLabelStyle,
                  ),
                  focusNode: _topicFieldFocus,
                ),
              ),
              SizedBox(
                height: 32.0,
              ),
              PrimaryBlueCTA(
                callback: () async {
                  var errorResponse = await Constant.topicNameValidator(_topicFieldController.text);
                  setState(() {
                    _topicValidatorResponse = errorResponse;
                  });
                  final FormState form = _topicFormKey.currentState;
                  if (form.validate()) {
                    form.save();
                    _topicFieldController.clear();
                    await createTopic(_inputTopicName);
                    Navigator.of(context).pop();
                  } else {
                    FocusScope.of(context).requestFocus(_topicFieldFocus);
                  }
                },
                child: Text(
                  "Create Topic",
                  style: Theme.of(context).brightness == Brightness.dark
                      ? DarkTheme.primaryCTATextStyle
                      : LightTheme.primaryCTATextStyle,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> _updateTopicList() async {
    _university.topics = _selectedTopicList;
    bool success = await _university.updateTopics();
    if (success) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _loadTopicList() async {
    QuerySnapshot universitySnap = await Firestore.instance
        .collection('University')
        .where('name', isEqualTo: widget.user.university)
        .getDocuments();
    _university = University.fromSnapshot(universitySnap.documents[0]);
    _selectedTopicList = _university.topics;
  }

  @override
  void initState() {
    super.initState();
    _loadTopicList();
  }

  @override
  void dispose() {
    super.dispose();
    _topicFieldFocus.dispose();
    _topicFieldController.dispose();
    _topicCreateButtonFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        "University topics",
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
                "Select or add all the topics taught by ${widget.user.university}...",
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
                          child: Text("No topics created yet"),
                        ),
                      );
                    } else {
                      List<String> topicList = List.generate(snapshot.data.documents.length,
                          (i) => snapshot.data.documents[i]['title']);
                      topicList.sort();
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: topicList.length,
                        itemBuilder: (context, i) {
                          return MyCheckBoxTile(
                            title: topicList[i],
                            outputList: _selectedTopicList,
                          );
                        },
                      );
                    }
                  } else {
                    return ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: List.generate(7, (i) => ShimmerTopicTile()),
                    );
                  }
                } else {
                  return Container();
                }
              },
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 16.0,
                ),
                Expanded(
                  child: BlueOutlineButton(
                    callback: () {
                      _showTopicCreatingDialog();
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Icon(
                          Icons.add,
                          size: 18.0,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? DarkTheme.outlineButtonTextColor
                              : LightTheme.outlineButtonTextColor,
                        ),
                        SizedBox(
                          width: 4.0,
                        ),
                        Text(
                          "Add Topic",
                          style: Theme.of(context).brightness == Brightness.dark
                              ? DarkTheme.outlineButtonTextStyle
                              : LightTheme.outlineButtonTextStyle,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 8.0,
                ),
                Expanded(
                  child: BlueOutlineButton(
                    callback: () async {
                      bool stat = await _updateTopicList();
                      if (stat) {
                        Constant.showToastSuccess("University topics successfully updated");
                      } else {
                        Constant.showToastError("Failed to save changes");
                      }
                    },
                    child: Text(
                      "Save",
                      style: Theme.of(context).brightness == Brightness.dark
                          ? DarkTheme.outlineButtonTextStyle
                          : LightTheme.outlineButtonTextStyle,
                    ),
                  ),
                ),
                SizedBox(
                  width: 16.0,
                ),
              ],
            ),
            SizedBox(
              height: 16.0,
            )
          ],
        )
      ],
    );
  }
}
