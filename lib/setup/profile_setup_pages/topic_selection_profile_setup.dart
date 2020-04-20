import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/shimmer_widgets.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/material.dart';

class TopicSelection extends StatefulWidget {
  final DocumentSnapshot userSnap;
  final DocumentSnapshot universitySnap;
  final bool isStudent;

  final Function onSuccess;

  const TopicSelection(
      {Key key,
      @required this.userSnap,
      this.universitySnap,
      @required this.onSuccess,
      @required this.isStudent})
      : super(key: key);

  @override
  _TopicSelectionState createState() => _TopicSelectionState();
}

class _TopicSelectionState extends State<TopicSelection> with AutomaticKeepAliveClientMixin {
  GlobalKey _topicFormKey = GlobalKey<FormState>();
  FocusNode _topicFieldFocus = FocusNode();
  FocusNode _topicCreateButtonFocus = FocusNode();
  TextEditingController _topicFieldController = TextEditingController();
  String _topicValidatorResponse;
  List<String> _selectedTopicList = new List();
  String _inputTopicName;

  Future<void> _uploadTopicDetails(List<String> updatedTopicList) async {
    try {
      if (widget.isStudent) {
        await Firestore.instance
            .collection('Users')
            .document(widget.userSnap.documentID)
            .updateData({
          'topics': updatedTopicList,
        });
      } else {
        await Firestore.instance
            .collection('University')
            .document(widget.universitySnap.documentID)
            .updateData({
          'topics': updatedTopicList,
        });
      }
    } catch (e) {
      print("_uploadTopicDetails");
      print(e);
    }
  }

  Future<void> _submitTopicSelectionForm() async {
    if (_selectedTopicList.length >= 1) {
      await _uploadTopicDetails(_selectedTopicList);
      await updateUserProfileStatus();
      if (widget.isStudent) {
        widget.onSuccess(2);
      } else {
        widget.onSuccess(3);
      }
      Constant.showToastSuccess("Profile set up successfully!");
    } else {
      Constant.showToastInstruction("Please select atleast one topic.");
    }
  }

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
                height: 16.0,
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
                      style: Theme
                                 .of(context)
                                 .brightness == Brightness.dark
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

  Future<void> updateUserProfileStatus() async {
    try {
      widget.userSnap.reference.updateData({'isProfileSet': true});
    } catch (e) {
      print("updateUserProfileStatus");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          padding: Constant.edgePadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Topics",
                style: Theme.of(context).brightness == Brightness.dark
                    ? DarkTheme.headingStyle
                    : LightTheme.headingStyle,
              ),
              SizedBox(
                height: 12.0,
              ),
              Text(
                widget.isStudent
                    ? "Select all the topics that interests you."
                    : "Select or add topics taught at your university",
                style: Theme.of(context).brightness == Brightness.dark
                    ? DarkTheme.headingDescriptionStyle
                    : LightTheme.headingDescriptionStyle,
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder(
            stream: Firestore.instance.collection('Topics').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  if (snapshot.data.documents.length == 0) {
                    return Center(
                      child: Container(
                        child: Text(widget.isStudent
                            ? "No Topics created by any university admin yet.\n\nPlease try again after some time."
                            : "No topics created yet"),
                      ),
                    );
                  } else {
                    List<String> topicList = List.generate(
                        snapshot.data.documents.length, (i) => snapshot.data.documents[i]['title']);
                    topicList.sort();
                    return Scrollbar(
                      child: ListView.builder(
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
                          "Sorry, seems like something went wrong while fetching list of topics."),
                    ),
                  );
                }
              } else {
                return ListView(
                  shrinkWrap: true,
                  children: List.generate(7, (i) => ShimmerTopicTile()),
                );
              }
            },
          ),
        ),
          widget.isStudent
          ? SizedBox(
              width: double.maxFinite,
              height: 64.0,
              child: PrimaryBlueCTA(
                  callback: () async {
                      _submitTopicSelectionForm();
                  },
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                          Text(
                              "Finish",
                              style: Theme
                                         .of(context)
                                         .brightness == Brightness.dark
                                     ? DarkTheme.primaryCTATextStyle
                                     : LightTheme.primaryCTATextStyle,
                          ),
                          SizedBox(
                              width: 8.0,
                          ),
                          Icon(
                              Icons.check,
                              color: Theme
                                         .of(context)
                                         .brightness == Brightness.dark
                                     ? DarkTheme.primaryCTATextColor
                                     : LightTheme.primaryCTATextColor,
                              size: 20.0,
                          ),
                      ],
                  ),
              ),
          )
          : SizedBox(
              width: double.maxFinite,
              height: 64.0,
              child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                      Expanded(
                          child: LeftSecondaryCTAButton(
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
                                          color: Theme
                                                     .of(context)
                                                     .brightness == Brightness.dark
                                                 ? DarkTheme.outlineButtonTextColor
                                                 : LightTheme.outlineButtonTextColor,
                                      ),
                                      SizedBox(
                                          width: 4.0,
                                      ),
                                      Text(
                                          "Add Topic",
                                          style: Theme
                                                     .of(context)
                                                     .brightness == Brightness.dark
                                                 ? DarkTheme.outlineButtonTextStyle
                                                 : LightTheme.outlineButtonTextStyle,
                                      )
                                  ],
                              ),
                          ),
                      ),
                      Expanded(
                          child: RightPrimaryBlueCTAButton(
                              callback: () async {
                                  _submitTopicSelectionForm();
                              },
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                      Text(
                                          "Finish",
                                          style: Theme
                                                     .of(context)
                                                     .brightness == Brightness.dark
                                                 ? DarkTheme.primaryCTATextStyle
                                                 : LightTheme.primaryCTATextStyle,
                                      ),
                                      SizedBox(
                                          width: 8.0,
                                      ),
                                      Icon(
                                          Icons.check,
                                          color: Theme
                                                     .of(context)
                                                     .brightness == Brightness.dark
                                                 ? DarkTheme.primaryCTATextColor
                                                 : LightTheme.primaryCTATextColor,
                                          size: 20.0,
                                      ),
                                  ],
                              ),
                          ),
                      ),
                  ],
              ),
          ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
