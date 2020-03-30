import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/material.dart';

class MyProfile extends StatefulWidget {
  final User user;

  MyProfile({Key key, @required this.user}) : super(key: key);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  String _inputFname;
  String _inputLname;
  String _inputMobileNumber;
  TextEditingController _userNameController;
  String _userNameValidator;
  String _inputUsername;
  String _inputBio;
  bool _isUserDetailLoading = false;
  List<String> _selectedTopicList;
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
  void dispose() {
    super.dispose();
    _userNameController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController(text: widget.user.userName);
    _selectedTopicList = widget.user.topics;
  }

  @override
  Widget build(BuildContext context) {
    //TODO A special buttons for admin to take them to admin panel
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        ExpansionTile(
          title: Text(
            "Preview Profile",
            style: Constant.secondaryBlueTextStyle,
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
                  style: Constant.sectionSubHeadingDescriptionStyle,
                ),
                SizedBox(
                  height: 16.0,
                ),
                SecondaryCTA(
                  child: Text(
                    "My Profile",
                    style: Constant.secondaryBlueTextStyle,
                  ),
                  callback: () {
                    Constant.userProfileView(context, userId: widget.user.id);
                  },
                )
              ],
            )
          ],
        ),
        ExpansionTile(
          title: Text(
            "Edit Details",
            style: Constant.secondaryBlueTextStyle,
          ),
          initiallyExpanded: false,
          backgroundColor: Colors.grey[50],
          children: <Widget>[
            Form(
              key: _userProfileFormKey,
              child: Padding(
                padding: Constant.edgePadding,
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
                        _inputMobileNumber = value;
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
                    PrimaryBlueCTA(
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
                              height: 24.0,
                              width: 24.0,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(Colors.white),
                                backgroundColor: Colors.blue[200],
                              ),
                            )
                          : Text(
                              "Update Details",
                              style: Constant.primaryCTATextStyle,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text(
            "Interested topics",
            style: Constant.secondaryBlueTextStyle,
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
                    style: Constant.sectionSubHeadingDescriptionStyle,
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
                          return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
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
                Padding(
                  padding: Constant.edgePadding,
                  child: PrimaryBlueCTA(
                    child: Text(
                      "Update topic preference",
                      style: Constant.primaryCTATextStyle,
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
        )
      ],
    );
  }
}
