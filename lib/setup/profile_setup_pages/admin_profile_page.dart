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
  GlobalKey _universityKey = GlobalKey<FormState>();
  FocusNode _emailFocus = FocusNode();
  FocusNode _bioFocus = FocusNode();
  FocusNode _mobileNumberFocus = FocusNode();
  FocusNode _userNameFocus = FocusNode();
  FocusNode _fNameFocus = FocusNode();
  FocusNode _lNameFocus = FocusNode();
  FocusNode _universityNameFocus = FocusNode();
  FocusNode _universityCountryFocus = FocusNode();
  FocusNode _universityStateFocus = FocusNode();
  FocusNode _universityCityFocus = FocusNode();
  FocusNode _submitPartOneFocus = FocusNode();
  FocusNode _submitPartTwoFocus = FocusNode();
  FocusNode _finalSubmitFocus = FocusNode();
  PageController _pageController = PageController();
  ScrollController _userDetailsScrollController = ScrollController();
  ScrollController _universityScrollController = ScrollController();
  TextEditingController _userNameController;

  DocumentSnapshot universitySnap;

  String _inputMobileNumber;
  String _inputBio;
  String _inputUsername;
  String _inputFname;
  String _inputLname;
  double _progressValue;
  String _inputUniversityCountry;
  String _inputUniversityState;
  String _inputUniversityCity;

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
    String userNameErrorResponse =
        await Constant.userNameAvailableValidator(_userNameController.text);
    setState(() {
      _userNameValidator = userNameErrorResponse;
    });
    if (form.validate()) {
      form.save();
      try {
        FocusScope.of(context).unfocus();
        await uploadUserDetails();
        //Loading data for the next page
        setState(() {
          FocusScope.of(context).unfocus();
          _isLoading = false;
          _pageController.animateToPage(1,
              duration: Constant.pageAnimationDuration, curve: Curves.easeInOut);
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

  Future<void> uploadUniversityDetails() async {
    try {
      Firestore.instance.collection('University').document(universitySnap.documentID).updateData({
        'city': _inputUniversityCity,
        'state': _inputUniversityState,
        'country': _inputUniversityCountry,
      });
    } catch (e) {
      print("updateUniversitydata:-");
      print(e);
    }
  }

  Future<void> _submitUniversityDetailForm() async {
    final FormState form = _universityKey.currentState;
    setState(() {
      _isLoading = true;
    });
    if (form.validate()) {
      form.save();
      try {
        FocusScope.of(context).unfocus();
        await uploadUniversityDetails();
        setState(() {
          _isLoading = false;
          _pageController.animateToPage(2,
              duration: Constant.pageAnimationDuration, curve: Curves.easeInOut);
          _progressValue = 1;
        });
      } catch (e) {
        print("uploadUniversityDetails:-");
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

  Future<DocumentSnapshot> loadUniversityDocument() async {
    String universityName = widget.userSnap.data['university'] as String;
    final universityQuerySnap = await Firestore.instance
        .collection('University')
        .where('name', isEqualTo: universityName)
        .getDocuments();
    universitySnap = universityQuerySnap.documents[0];
    return universitySnap;
  }

  @override
  void initState() {
    super.initState();
    _progressValue = 1 / 3;
    _isLoading = false;
    _userNameController = TextEditingController(text: widget.userSnap.data['username'] ?? null);
    loadUniversityDocument();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _userDetailsScrollController.dispose();
    _submitPartOneFocus.dispose();
    _bioFocus.dispose();
    _emailFocus.dispose();
    _universityNameFocus.dispose();
    _mobileNumberFocus.dispose();
    _userNameFocus.dispose();
    _fNameFocus.dispose();
    _lNameFocus.dispose();
    _userNameController.dispose();
    _universityCountryFocus.dispose();
    _universityStateFocus.dispose();
    _universityCityFocus.dispose();
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
              _inputFname = value;
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

    final universityForm = Form(
      key: _universityKey,
      child: ListView(
        padding: Constant.edgePadding,
        controller: _universityScrollController,
        shrinkWrap: true,
        children: <Widget>[
          Text(
            "University Details",
            style: Constant.sectionSubHeadingStyle,
          ),
          SizedBox(
            height: 32.0,
          ),
          TextFormField(
            onSaved: (value) {
              _inputUniversityCountry = value;
            },
            onEditingComplete: () {
              FocusScope.of(context).requestFocus(_universityStateFocus);
              _universityScrollController.animateTo(100.0,
                  duration: Constant.scrollAnimationDuration, curve: Curves.easeInOut);
            },
            validator: (value) => Constant.nameValidator(value),
            keyboardType: TextInputType.text,
            style: Constant.formFieldTextStyle,
            decoration: InputDecoration(
              counterStyle: Constant.counterStyle,
              contentPadding: Constant.formFieldContentPadding,
              hintText: "India",
              hintStyle: Constant.formFieldHintStyle,
              border: Constant.formFieldBorder,
              focusedBorder: Constant.formFieldFocusedBorder,
              labelText: "Country",
              labelStyle: Constant.formFieldLabelStyle,
            ),
            focusNode: _universityCountryFocus,
          ),
          SizedBox(
            height: 32.0,
          ),
          TextFormField(
            onSaved: (value) {
              _inputUniversityState = value;
            },
            onEditingComplete: () {
              FocusScope.of(context).requestFocus(_universityCityFocus);
              _universityScrollController.animateTo(200.0,
                  duration: Constant.scrollAnimationDuration, curve: Curves.easeInOut);
            },
            validator: (value) => Constant.nameValidator(value),
            keyboardType: TextInputType.text,
            style: Constant.formFieldTextStyle,
            decoration: InputDecoration(
              counterStyle: Constant.counterStyle,
              contentPadding: Constant.formFieldContentPadding,
              hintText: "Gujarat",
              hintStyle: Constant.formFieldHintStyle,
              border: Constant.formFieldBorder,
              focusedBorder: Constant.formFieldFocusedBorder,
              labelText: "Region/State",
              labelStyle: Constant.formFieldLabelStyle,
            ),
            focusNode: _universityStateFocus,
          ),
          SizedBox(
            height: 32.0,
          ),
          TextFormField(
            onSaved: (value) {
              _inputUniversityCity = value;
            },
            onEditingComplete: () {
              FocusScope.of(context).requestFocus(_submitPartTwoFocus);
              _universityScrollController.animateTo(300.0,
                  duration: Constant.scrollAnimationDuration, curve: Curves.easeInOut);
            },
            validator: (value) => Constant.nameValidator(value),
            keyboardType: TextInputType.text,
            style: Constant.formFieldTextStyle,
            decoration: InputDecoration(
              counterStyle: Constant.counterStyle,
              contentPadding: Constant.formFieldContentPadding,
              hintText: "Gandhinagar",
              hintStyle: Constant.formFieldHintStyle,
              border: Constant.formFieldBorder,
              focusedBorder: Constant.formFieldFocusedBorder,
              labelText: "City",
              labelStyle: Constant.formFieldLabelStyle,
            ),
            focusNode: _universityCityFocus,
          ),
          SizedBox(
            height: 32.0,
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: RaisedButton(
                focusNode: _submitPartTwoFocus,
                onPressed: () async {
                  await _submitUniversityDetailForm();
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
                _progressValue==1?"Almost Done...":"Let's set up your profile...",
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
