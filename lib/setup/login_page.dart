import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/setup/signup_instruction_page.dart';
import 'package:ednet/utilities_files/contants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  String _email;
  String _link;
  final _formKey = GlobalKey<FormState>();
  QuerySnapshot docRef;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initDynamicLinks();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      initDynamicLinks();
    }
  }

  void initDynamicLinks() async {
    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      _link = deepLink.toString();
      //TODO in case we use multiple dynamic link, verify that the link is login link.
      _signInWithEmailAndLink();
    }

    FirebaseDynamicLinks.instance.onLink(onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;

      if (deepLink != null) {
        _link = deepLink.toString();
        print("204 _link:-" + _link);
        _signInWithEmailAndLink();
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
  }

  Future<bool> _validateAndSave() async {
    bool sent;
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      try {
        //Checking the sign in method to determine whether user already exists or not.
        List<String> signInMethod = await FirebaseAuth.instance.fetchSignInMethodsForEmail(
          email: _email,
        );
        print("signInMethod:-" + signInMethod.toString());
        if (signInMethod.length == 0) {
          //User doesn't exists
          QuerySnapshot searchResult = await Firestore.instance
              .collection('SignUpApplications')
              .where('email', isEqualTo: _email)
              .getDocuments();
          print("searchResult:- " + searchResult.toString());
          if (searchResult.documents.length > 0) {
            //searchResult is not zero, hence email is a valid sign up email.
            sent = await _sendSignInWithEmailLink();
            return sent;
          } else {
            //searchResult is zero, hence email is not a valid sign up email.
            sent = false;
            showDialog(
                context: context,
                builder: (context) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Your university hasn't applied for ednet yet."),
                      RaisedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(builder: (context) {
                            return SignUpInstruction();
                          }));
                        },
                        child: Text("Show me how to apply"),
                      ),
                    ],
                  );
                });
            return sent;
          }
        } else {
          //user already exists, sending email log in link
          sent = await _sendSignInWithEmailLink();
        }
      } catch (error) {
        print("134 " + error.toString());
      }
      return sent;
    }
    return false;
  }

  Future<bool> _sendSignInWithEmailLink() async {
    try {
      FirebaseAuth.instance.sendSignInWithEmailLink(
          email: _email,
          androidInstallIfNotAvailable: true,
          iOSBundleID: "com.ednet.ednet",
          androidMinimumVersion: "21",
          androidPackageName: "com.ednet.ednet",
          url: "https://ednet.page.link/secureSignIn",
          handleCodeInApp: true);
    } catch (e) {
      _showDialog(e.toString());
      return false;
    }
    print(_email + "<< sent");
    return true;
  }

  Future<void> _updateSignUpStatus() async {
    try {
      docRef = await Firestore.instance
          .collection('SignUpApplications')
          .where('email', isEqualTo: _email)
          .getDocuments();
      await Firestore.instance
          .collection('SignUpApplications')
          .document(docRef.documents[0].documentID)
          .updateData({'signup_status': true});
    } catch (e) {
      print("_updateSignUpStatus");
      print(e);
    }
  }

  Future<void> _createRelevantDocument() async {
    bool isAdmin = docRef.documents[0]['type'] == "admin" ? true : false;
    String userUniversity = docRef.documents[0]['university'];
    //create user document
    try {
      await Firestore.instance.collection('Users').add({
        'email': _email,
        'isProfileSet': false,
        'isAdmin': isAdmin,
        'university': userUniversity,
      });
    } catch (e) {
      print("_createRelevantDocument_user");
      print(e);
    }
    //create university document if user is admin
    if(isAdmin){
      try {
        await Firestore.instance.collection('University').add({
                'name':userUniversity,
              });
      } catch (e) {
        print("_createRelevntDocument_university");
        print(e);
      }
    }
  }

  Future<void> _signInWithEmailAndLink() async {
    final FirebaseAuth user = FirebaseAuth.instance;
    bool validLink = await user.isSignInWithEmailLink(_link);
    if (validLink) {
      try {
        List<String> signInMethod =
            await FirebaseAuth.instance.fetchSignInMethodsForEmail(email: _email);
        if (signInMethod.length == 0) {
          //First time user sign up
          await _updateSignUpStatus();
          await _createRelevantDocument();
        }
        await FirebaseAuth.instance.signInWithEmailAndLink(email: _email, link: _link);
        print("After login:-" + FirebaseAuth.instance.currentUser().toString());
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setBool("welcome", true);
      } catch (e) {
        print("signInWithEmailLink function:- " + e.toString());
      }
    }
  }

  void _showDialog(String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Error"),
          content: new Text("Please Try Again.Error code: " + error),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      validator: (value) => Constant.emailValidator(value),
      onSaved: (value) => _email = value,
      style: Constant.formFieldTextStyle,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        counterStyle: Constant.counterStyle,
        contentPadding: Constant.formFieldContentPadding,
        hintText: "john.doe@abc.com",
        hintStyle: Constant.formFieldHintStyle,
        border: Constant.formFieldBorder,
        focusedBorder: Constant.formFieldFocusedBorder,
        labelText: "Email",
        labelStyle: Constant.formFieldLabelStyle,
      ),
    );

    final loginButton = RaisedButton(
      autofocus: true,
      elevation: 15.0,
      child: Text("Request Login Email",style: TextStyle(fontSize: 18.0,color: Colors.blue[800],),),
      onPressed: (() async => await _validateAndSave()
          ? Constant.showToastInstruction("Email sent to $_email.")
          : Constant.showToastError("Email not sent.")),
      padding: Constant.raisedButtonPaddingHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(color: Colors.blue[800], width: 2.0),
      ),
      color: Colors.blue[50],
    );

    final loginForm = Form(
      key: _formKey,
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          email,
          SizedBox(height: 24),
          loginButton,
        ],
      ),
    );
    return  loginForm;
  }
}
