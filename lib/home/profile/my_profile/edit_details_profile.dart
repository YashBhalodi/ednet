import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/material.dart';

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
        style: Theme.of(context).brightness == Brightness.dark
            ? DarkTheme.dropDownMenuTitleStyle
            : LightTheme.dropDownMenuTitleStyle,
      ),
      initiallyExpanded: false,
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
                    style: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.formFieldTextStyle
                        : LightTheme.formFieldTextStyle,
                    decoration: InputDecoration(
                      counterStyle: Theme.of(context).brightness == Brightness.dark
                          ? DarkTheme.counterStyle
                          : LightTheme.counterStyle,
                      contentPadding: Constant.formFieldContentPadding,
                      hintText: "John",
                      hintStyle: Theme.of(context).brightness == Brightness.dark
                          ? DarkTheme.formFieldHintStyle
                          : LightTheme.formFieldHintStyle,
                      border: Theme.of(context).brightness == Brightness.dark
                          ? DarkTheme.formFieldBorder
                          : LightTheme.formFieldBorder,
                      focusedBorder: Theme.of(context).brightness == Brightness.dark
                          ? DarkTheme.formFieldFocusedBorder
                          : LightTheme.formFieldFocusedBorder,
                      labelText: "First Name",
                      labelStyle: Theme.of(context).brightness == Brightness.dark
                          ? DarkTheme.formFieldLabelStyle
                          : LightTheme.formFieldLabelStyle,
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
                    style: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.formFieldTextStyle
                        : LightTheme.formFieldTextStyle,
                    decoration: InputDecoration(
                      counterStyle: Theme.of(context).brightness == Brightness.dark
                          ? DarkTheme.counterStyle
                          : LightTheme.counterStyle,
                      contentPadding: Constant.formFieldContentPadding,
                      hintText: "Doe",
                      hintStyle: Theme.of(context).brightness == Brightness.dark
                          ? DarkTheme.formFieldHintStyle
                          : LightTheme.formFieldHintStyle,
                      border: Theme.of(context).brightness == Brightness.dark
                          ? DarkTheme.formFieldBorder
                          : LightTheme.formFieldBorder,
                      focusedBorder: Theme.of(context).brightness == Brightness.dark
                          ? DarkTheme.formFieldFocusedBorder
                          : LightTheme.formFieldFocusedBorder,
                      labelText: "Last Name",
                      labelStyle: Theme.of(context).brightness == Brightness.dark
                          ? DarkTheme.formFieldLabelStyle
                          : LightTheme.formFieldLabelStyle,
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
                    style: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.formFieldTextStyle
                        : LightTheme.formFieldTextStyle,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      counterStyle: Theme.of(context).brightness == Brightness.dark
                          ? DarkTheme.counterStyle
                          : LightTheme.counterStyle,
                      contentPadding: Constant.formFieldContentPadding,
                      hintText: "94578xxxx5",
                      hintStyle: Theme.of(context).brightness == Brightness.dark
                          ? DarkTheme.formFieldHintStyle
                          : LightTheme.formFieldHintStyle,
                      border: Theme.of(context).brightness == Brightness.dark
                          ? DarkTheme.formFieldBorder
                          : LightTheme.formFieldBorder,
                      focusedBorder: Theme.of(context).brightness == Brightness.dark
                          ? DarkTheme.formFieldFocusedBorder
                          : LightTheme.formFieldFocusedBorder,
                      labelText: "Mobile Number",
                      labelStyle: Theme.of(context).brightness == Brightness.dark
                          ? DarkTheme.formFieldLabelStyle
                          : LightTheme.formFieldLabelStyle,
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
                    style: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.formFieldTextStyle
                        : LightTheme.formFieldTextStyle,
                    decoration: InputDecoration(
                      counterStyle: Theme.of(context).brightness == Brightness.dark
                          ? DarkTheme.counterStyle
                          : LightTheme.counterStyle,
                      contentPadding: Constant.formFieldContentPadding,
                      hintText: "johnDoe12",
                      hintStyle: Theme.of(context).brightness == Brightness.dark
                          ? DarkTheme.formFieldHintStyle
                          : LightTheme.formFieldHintStyle,
                      border: Theme.of(context).brightness == Brightness.dark
                          ? DarkTheme.formFieldBorder
                          : LightTheme.formFieldBorder,
                      focusedBorder: Theme.of(context).brightness == Brightness.dark
                          ? DarkTheme.formFieldFocusedBorder
                          : LightTheme.formFieldFocusedBorder,
                      labelText: "Username",
                      labelStyle: Theme.of(context).brightness == Brightness.dark
                          ? DarkTheme.formFieldLabelStyle
                          : LightTheme.formFieldLabelStyle,
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
                    style: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.formFieldTextStyle
                        : LightTheme.formFieldTextStyle,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      counterStyle: Theme.of(context).brightness == Brightness.dark
                          ? DarkTheme.counterStyle
                          : LightTheme.counterStyle,
                      contentPadding: Constant.formFieldContentPadding,
                      hintText: "Brief description about yourself...",
                      hintStyle: Theme.of(context).brightness == Brightness.dark
                          ? DarkTheme.formFieldHintStyle
                          : LightTheme.formFieldHintStyle,
                      border: Theme.of(context).brightness == Brightness.dark
                          ? DarkTheme.formFieldBorder
                          : LightTheme.formFieldBorder,
                      focusedBorder: Theme.of(context).brightness == Brightness.dark
                          ? DarkTheme.formFieldFocusedBorder
                          : LightTheme.formFieldFocusedBorder,
                      labelText: "Bio",
                      labelStyle: Theme.of(context).brightness == Brightness.dark
                          ? DarkTheme.formFieldLabelStyle
                          : LightTheme.formFieldLabelStyle,
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
                            child: CircularProgressIndicator(),
                          )
                        : Text(
                            "Update Details",
                            style: Theme.of(context).brightness == Brightness.dark
                                ? DarkTheme.outlineButtonTextStyle
                                : LightTheme.outlineButtonTextStyle,
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
