import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/shimmer_widgets.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/material.dart';

class MyProfile extends StatefulWidget {
  final User user;

  MyProfile({Key key, @required this.user}) : super(key: key);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Profile"),
        ),
        body: Scrollbar(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              ExpansionTile(
                title: Text(
                  "Preview Profile",
                  style: Constant.dropDownMenuTitleStyle,
                ),
                initiallyExpanded: true,
                backgroundColor: Colors.grey[50],
                children: <Widget>[
                  ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: Constant.edgePadding,
                    children: <Widget>[
                      Text(
                        "How other users will see your profile...",
                        style: Theme
                                   .of(context)
                                   .brightness == Brightness.dark
                               ? DarkTheme.headingDescriptionStyle
                               : LightTheme.headingDescriptionStyle,
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      BlueOutlineButton(
                        child: Text(
                          "My Profile",
                          style: Constant.outlineBlueButtonTextStyle,
                        ),
                        callback: () {
                          Constant.userProfileView(context, userId: widget.user.id);
                        },
                      ),
                    ],
                  )
                ],
              ),
              EditDetailsTile(
                user: widget.user,
              ),
              widget.user.isAdmin
                  ? UniversityTopicListTile(
                      user: widget.user,
                    )
                  : UserTopicListTile(
                      user: widget.user,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditDetailsTile extends StatefulWidget {
  final User user;

  const EditDetailsTile({Key key, @required this.user}) : super(key: key);

  @override
  _EditDetailsTileState createState() => _EditDetailsTileState();
}

class _EditDetailsTileState extends State<EditDetailsTile> {
  String _inputFname;
  String _inputLname;
  String _inputMobileNumber;
  TextEditingController _userNameController;
  String _userNameValidator;
  String _inputUsername;
  String _inputBio;
  bool _isUserDetailLoading = false;
  GlobalKey<FormState> _userProfileFormKey = GlobalKey<FormState>();

  Future<bool> updateUserDetails() async {
    setState(() {
      _isUserDetailLoading = true;
    });
    final FormState form = _userProfileFormKey.currentState;
    String response = await Constant.userNameAvailableValidator(_userNameController.text);
    setState(() {
      _userNameValidator = response;
    });
    if (form.validate()) {
      form.save();
      widget.user.bio = _inputBio;
      widget.user.fname = _inputFname;
      widget.user.lname = _inputLname;
      widget.user.userName = _inputUsername;
      widget.user.mobile = _inputMobileNumber;
      print(widget.user.toString());
      bool uploadSuccess = await widget.user.updateUser();
      if (uploadSuccess) {
        setState(() {
          _isUserDetailLoading = false;
        });
        return true;
      } else {
        setState(() {
          _isUserDetailLoading = false;
        });
        return false;
      }
    } else {
      setState(() {
        _isUserDetailLoading = false;
      });
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController(text: widget.user.userName);
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        "Edit Details",
        style: Constant.dropDownMenuTitleStyle,
      ),
      initiallyExpanded: false,
      backgroundColor: Colors.grey[50],
      children: <Widget>[
        Form(
          key: _userProfileFormKey,
          child: Padding(
            padding: Constant.edgePadding,
            child: Scrollbar(
              child: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  TextFormField(
                    onSaved: (value) {
                      _inputFname = value;
                    },
                    initialValue: widget.user.fname,
                    validator: (value) => Constant.nameValidator(value),
                    keyboardType: TextInputType.text,
                    style: Constant.formFieldTextStyle,
                    decoration: InputDecoration(
                      counterStyle: Constant.counterStyle,
                      contentPadding: Constant.formFieldContentPadding,
                      hintText: "John",
                      hintStyle: Constant.formFieldHintStyle,
                      border: Constant.formFieldBorder,
                      focusedBorder: Constant.formFieldFocusedBorder,
                      labelText: "First Name",
                      labelStyle: Constant.formFieldLabelStyle,
                    ),
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                  TextFormField(
                    onSaved: (value) {
                      _inputLname = value;
                    },
                    initialValue: widget.user.lname,
                    validator: (value) => Constant.nameValidator(value),
                    keyboardType: TextInputType.text,
                    style: Constant.formFieldTextStyle,
                    decoration: InputDecoration(
                      counterStyle: Constant.counterStyle,
                      contentPadding: Constant.formFieldContentPadding,
                      hintText: "Doe",
                      hintStyle: Constant.formFieldHintStyle,
                      border: Constant.formFieldBorder,
                      focusedBorder: Constant.formFieldFocusedBorder,
                      labelText: "Last Name",
                      labelStyle: Constant.formFieldLabelStyle,
                    ),
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                  TextFormField(
                    validator: (value) => Constant.mobileNumberValidator(value),
                    onSaved: (value) {
                      _inputMobileNumber = value.trim();
                    },
                    initialValue: widget.user.mobile,
                    maxLength: 10,
                    style: Constant.formFieldTextStyle,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      counterStyle: Constant.counterStyle,
                      contentPadding: Constant.formFieldContentPadding,
                      hintText: "94578xxxx5",
                      hintStyle: Constant.formFieldHintStyle,
                      border: Constant.formFieldBorder,
                      focusedBorder: Constant.formFieldFocusedBorder,
                      labelText: "Mobile Number",
                      labelStyle: Constant.formFieldLabelStyle,
                    ),
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                  TextFormField(
                    controller: _userNameController,
                    maxLength: 15,
                    validator: (value) {
                      return _userNameValidator;
                    },
                    onSaved: (value) {
                      _inputUsername = value;
                    },
                    style: Constant.formFieldTextStyle,
                    decoration: InputDecoration(
                      counterStyle: Constant.counterStyle,
                      contentPadding: Constant.formFieldContentPadding,
                      hintText: "johnDoe12",
                      hintStyle: Constant.formFieldHintStyle,
                      border: Constant.formFieldBorder,
                      focusedBorder: Constant.formFieldFocusedBorder,
                      labelText: "Username",
                      labelStyle: Constant.formFieldLabelStyle,
                    ),
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                  TextFormField(
                    maxLength: 100,
                    onSaved: (value) {
                      _inputBio = value;
                    },
                    initialValue: widget.user.bio,
                    minLines: 3,
                    maxLines: 7,
                    style: Constant.formFieldTextStyle,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      counterStyle: Constant.counterStyle,
                      contentPadding: Constant.formFieldContentPadding,
                      hintText: "Brief description about yourself...",
                      hintStyle: Constant.formFieldHintStyle,
                      border: Constant.formFieldBorder,
                      focusedBorder: Constant.formFieldFocusedBorder,
                      labelText: "Bio",
                      labelStyle: Constant.formFieldLabelStyle,
                    ),
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                  BlueOutlineButton(
                    callback: () async {
                      FocusScope.of(context).unfocus();
                      if (!_isUserDetailLoading) {
                        bool stat = await updateUserDetails();
                        if (stat) {
                          Constant.showToastSuccess("Profile updated successfully");
                        } else {
                          Constant.showToastError("Profile failed to update");
                        }
                      }
                    },
                    child: _isUserDetailLoading
                        ? SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.blue[600]),
                              backgroundColor: Colors.blue[50],
                            ),
                          )
                        : Text(
                            "Update Details",
                            style: Constant.outlineBlueButtonTextStyle,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

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
        style: Constant.dropDownMenuTitleStyle,
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
                style: Theme
                           .of(context)
                           .brightness == Brightness.dark
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
                  style: Constant.outlineBlueButtonTextStyle,
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
                  style: Constant.formFieldTextStyle,
                  decoration: InputDecoration(
                    counterStyle: Constant.counterStyle,
                    contentPadding: Constant.formFieldContentPadding,
                    hintText: "Kinematics",
                    hintStyle: Constant.formFieldHintStyle,
                    border: Constant.formFieldBorder,
                    focusedBorder: Constant.formFieldFocusedBorder,
                    labelText: "Topic Name",
                    labelStyle: Constant.formFieldLabelStyle,
                  ),
                  focusNode: _topicFieldFocus,
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              BlueOutlineButton(
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
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.blue[800],
                  ),
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
        style: Constant.dropDownMenuTitleStyle,
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
                style: Theme
                           .of(context)
                           .brightness == Brightness.dark
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
                          color: Colors.blue[600],
                        ),
                        SizedBox(
                          width: 4.0,
                        ),
                        Text(
                          "Add Topic",
                          style: Constant.outlineBlueButtonTextStyle,
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
                      style: Constant.outlineBlueButtonTextStyle,
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
