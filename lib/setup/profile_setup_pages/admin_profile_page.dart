import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ednet/utilities_files/contants.dart';

class AdminProfileSetup extends StatefulWidget {
  final DocumentSnapshot userSnap;

  const AdminProfileSetup({Key key, this.userSnap}) : super(key: key);

  @override
  _AdminProfileSetupState createState() => _AdminProfileSetupState();
}

class _AdminProfileSetupState extends State<AdminProfileSetup> {
  GlobalKey _userFormKey = GlobalKey<FormState>();
  FocusNode _emailFocus = FocusNode();
  FocusNode _bioFocus = FocusNode();
  FocusNode _mobileNumberFocus = FocusNode();
  FocusNode _userNameFocus = FocusNode();
  FocusNode _universityFocus = FocusNode();
  FocusNode _fNameFocus = FocusNode();
  FocusNode _lNameFocus = FocusNode();
  FocusNode _submitPartOneFocus = FocusNode();
  PageController _pageController = PageController();
  ScrollController _userDetailsScrollController = ScrollController();
  TextEditingController _userNameController;

  String _inputMobileNumber;
  String _inputBio;
  String _inputUsername;
  String _inputFname;
  String _inputLname;
  double _progressValue;

  bool _isLoading;

  String _userNameValidator;

  Future<void> uploadUserDetails() async {
    try {
      var docId = widget.userSnap.documentID;
      Firestore.instance.collection('Users').document(docId).updateData({
        'bio': _inputBio,
        'mobile_number': _inputMobileNumber,
        'username': _inputUsername,
        'fname': _inputFname,
        'lname': _inputLname,
      });
    } catch (e) {
      print("update document:-");
      print(e);
    }
  }

  Future<void> _submitUserDetailForm() async {
    final FormState form = _userFormKey.currentState;
    setState(() {
      _isLoading = true;
    });
    String userNameErrorResponse = await Constant.userNameAvailableValidator(_userNameController.text);
    setState(() {
        _userNameValidator = userNameErrorResponse;
    });
    if (form.validate()) {
      form.save();
      try {
        await uploadUserDetails();
        setState(() {
          _isLoading = false;
          _pageController.animateToPage(1,
              duration: Constant.scrollAnimationDuration, curve: Curves.easeInOut);
          _progressValue = 2 / 3;
        });
      } catch (e) {
        print("uploadUserDetails:-");
        print(e);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> updateUserProfileStatus() async {
    try {
      widget.userSnap.reference.updateData({'isProfileSet': true});
    } catch (e) {
      print("updateUserProfileStatus");
      print(e);
    }
  }

  Future<void> finalSubmission() async {
    await updateUserProfileStatus();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) {
          return Home(
            userSnap: widget.userSnap,
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _progressValue = 1 / 3;
    _isLoading = false;
    _userNameController = TextEditingController(text: widget.userSnap.data['username'] ?? null);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _userDetailsScrollController.dispose();
    _submitPartOneFocus.dispose();
    _bioFocus.dispose();
    _emailFocus.dispose();
    _universityFocus.dispose();
    _mobileNumberFocus.dispose();
    _userNameFocus.dispose();
    _fNameFocus.dispose();
    _lNameFocus.dispose();
    _userNameController.dispose();
  }

  //TODO implement Admin profile setup UI
  @override
  Widget build(BuildContext context) {
    final userForm = Form(
      key: _userFormKey,
      child: ListView(
        controller: _userDetailsScrollController,
        shrinkWrap: true,
        padding: Constant.edgePadding,
        children: <Widget>[
          Text(
            "User Details",
            style: Constant.sectionSubHeadingStyle,
          ),
          SizedBox(
            height: 32.0,
          ),
          TextFormField(
            onSaved: (value) {
              print("inputfname:-"+value);
              _inputFname = value.trim();
            },
            onEditingComplete: () {
              FocusScope.of(context).requestFocus(_lNameFocus);
              _userDetailsScrollController.animateTo(100.0,
                  duration: Constant.scrollAnimationDuration, curve: Curves.easeInOut);
            },
            initialValue: widget.userSnap.data['fname'] ?? null,
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
            focusNode: _fNameFocus,
          ),
          SizedBox(
            height: 32.0,
          ),
          TextFormField(
            onSaved: (value) {
              _inputLname = value;
            },
            onEditingComplete: () {
              FocusScope.of(context).requestFocus(_mobileNumberFocus);
              _userDetailsScrollController.animateTo(200.0,
                  duration: Constant.scrollAnimationDuration, curve: Curves.easeInOut);
            },
            initialValue: widget.userSnap.data['lname'] ?? null,
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
            focusNode: _lNameFocus,
          ),
          SizedBox(
            height: 32.0,
          ),
          TextFormField(
            validator: (value) => Constant.mobileNumberValidator(value),
            onSaved: (value) {
              _inputMobileNumber = value;
            },
            onEditingComplete: () {
              FocusScope.of(context).requestFocus(_userNameFocus);
              _userDetailsScrollController.animateTo(300.0,
                  duration: Constant.scrollAnimationDuration, curve: Curves.easeInOut);
            },
            initialValue: widget.userSnap.data['mobile_number'] ?? null,
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
            focusNode: _mobileNumberFocus,
          ),
          SizedBox(
            height: 32.0,
          ),
          TextFormField(
            controller: _userNameController,
            maxLength: 10,
            validator: (value) {
              return _userNameValidator;
            },
            onSaved: (value) {
              _inputUsername = value;
            },
            onEditingComplete: () {
              FocusScope.of(context).requestFocus(_bioFocus);
              _userDetailsScrollController.animateTo(400.0,
                  duration: Constant.scrollAnimationDuration, curve: Curves.easeInOut);
            },
            autovalidate: true,
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
            focusNode: _userNameFocus,
          ),
          SizedBox(
            height: 32.0,
          ),
          TextFormField(
            maxLength: 100,
            onEditingComplete: () {
              FocusScope.of(context).requestFocus(_submitPartOneFocus);
              _userDetailsScrollController.animateTo(500.0,
                  duration: Constant.scrollAnimationDuration, curve: Curves.easeInOut);
            },
            onSaved: (value) {
              _inputBio = value;
            },
            initialValue: widget.userSnap.data['bio'] ?? null,
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
            focusNode: _bioFocus,
          ),
          SizedBox(
            height: 32.0,
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: RaisedButton(
                focusNode: _submitPartOneFocus,
                onPressed: () async {
                  await _submitUserDetailForm();
                },
                padding: Constant.raisedButtonPaddingHigh,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  side: BorderSide(color: Colors.green[800], width: 2.0),
                ),
                color: Colors.green[50],
                child: _isLoading
                    ? Constant.greenCircularProgressIndicator
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(
                            "Next",
                            style: TextStyle(
                              fontSize: 22.0,
                              color: Colors.green[800],
                            ),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Icon(
                            Icons.arrow_forward,
                            size: 20.0,
                            color: Colors.green[800],
                          )
                        ],
                      ),
              ),
            ),
          )
        ],
      ),
    );

    final universityForm = Padding(
      padding: Constant.edgePadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "University Details",
            style: Constant.sectionSubHeadingStyle,
          ),
        ],
      ),
    );

    final topicSelection = Padding(
      padding: Constant.edgePadding,
      child: Container(
        child: Text(
          "Topic selection",
          style: Constant.sectionSubHeadingStyle,
        ),
      ),
    );

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        resizeToAvoidBottomPadding: true,
        body: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: Constant.edgePadding,
              color: Colors.green[50],
              child: Text(
                "Let's set up your profile...",
                style: TextStyle(
                  color: Colors.green[900],
                  fontSize: 20.0,
                ),
              ),
            ),
            LinearProgressIndicator(
              value: _progressValue,
              backgroundColor: Colors.green[50],
              valueColor: AlwaysStoppedAnimation(Colors.green),
            ),
            Expanded(
              child: PageView(
//                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                controller: _pageController,
                children: <Widget>[
                  userForm,
                  universityForm,
                  topicSelection,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
