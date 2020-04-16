import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  String _email;
  String _link;
  final _formKey = GlobalKey<FormState>();
  QuerySnapshot queryDocRef;
  bool _loginLoading = false;

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
      await _signInWithEmailAndLink();
    }

    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData dynamicLink) async {
        final Uri deepLink = dynamicLink?.link;

        if (deepLink != null) {
          _link = deepLink.toString();
          print("59 _link:-" + _link);
          await _signInWithEmailAndLink();
        }
      },
      onError: (OnLinkErrorException e) async {
        print('onLinkError');
        print(e.message);
      },
    );
  }

  Future<bool> _validateAndSave() async {
    setState(() {
      _loginLoading = true;
    });
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
          print("searchResult:- " + searchResult?.documents?.toString());
          if (searchResult.documents.length > 0) {
            //searchResult is not zero, hence email is a valid sign up email.
            sent = await _sendSignInWithEmailLink();
            setState(() {
              _loginLoading = false;
            });
            return sent;
          } else {
            //searchResult is zero, hence email is not a valid sign up email.
            sent = false;
            Constant.showNoSignUpDialog(context);
            setState(() {
              _loginLoading = false;
            });
            return sent;
          }
        } else {
          //user already exists, sending email log in link
          sent = await _sendSignInWithEmailLink();
        }
      } catch (error) {
        print("147 " + error.toString());
      }
      setState(() {
        _loginLoading = false;
      });
      return sent;
    }
    setState(() {
      _loginLoading = false;
    });
    return false;
  }

  Future<bool> _sendSignInWithEmailLink() async {
    try {
        await FirebaseAuth.instance.sendSignInWithEmailLink(
          email: _email,
          androidInstallIfNotAvailable: true,
          iOSBundleID: "com.ednet.ednet",
          androidMinimumVersion: "21",
          androidPackageName: "com.ednet.ednet",
          url: "https://ednet.page.link/secureSignIn",
          handleCodeInApp: true);
      return true;
    } catch (e) {
      PlatformException err = e;
      if (err.code == "ERROR_USER_DISABLED") {
        Constant.showAccountDisabledDialog(context);
      }
      return false;
    }
  }

  Future<void> _signInWithEmailAndLink() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Logging you in..."),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16.0),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 32.0,
                width: 32.0,
                child: CircularProgressIndicator(),
              ),
            ],
          ),
        );
      },
    );
    final FirebaseAuth auth = FirebaseAuth.instance;
    bool validLink = await auth.isSignInWithEmailLink(_link);
    print("email:- $_email");
    if (validLink) {
      try {
          await FirebaseAuth.instance
              .signInWithEmailAndLink(email: _email, link: _link)
              .then((user) {
              Crashlytics.instance.setUserEmail(user.email);
              print("After login:-" + user.email);
          });
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setBool("welcome", true);
      } catch (e, s) {
          await Future.delayed(const Duration(seconds: 4), () {});
        FirebaseUser user = await FirebaseAuth.instance.currentUser();
        if (user == null) {
          PlatformException err = e;
          if (err.code == "ERROR_INVALID_ACTION_CODE") {
            Navigator.of(context).pop();
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(16.0),
                    ),
                  ),
                  content: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                          "The link you used might have been expired.\n\nPlease check your inbox again and use the latest link."),
                      SizedBox(
                        height: 32.0,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: SecondaryCTA(
                          callback: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "OK",
                            style: Theme.of(context).brightness == Brightness.dark
                                   ? DarkTheme.secondaryCTATextStyle
                                   : LightTheme.secondaryCTATextStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        }
        print("signInWithEmailLink function:- " + e.toString() + "\n" + s.toString());
      }
    } else {
      Navigator.of(context).pop();
      print("264:--Invalid login link");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      validator: (value) => Constant.emailValidator(value),
      onSaved: (value) => _email = value,
      style: Theme.of(context).brightness == Brightness.dark
             ? DarkTheme.formFieldTextStyle
             : LightTheme.formFieldTextStyle,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        counterStyle: Theme.of(context).brightness == Brightness.dark
                      ? DarkTheme.counterStyle
                      : LightTheme.counterStyle,
        contentPadding: Constant.formFieldContentPadding,
        hintText: "john.doe@abc.com",
        hintStyle: Theme.of(context).brightness == Brightness.dark
                   ? DarkTheme.formFieldHintStyle
                   : LightTheme.formFieldHintStyle,
        border: Theme.of(context).brightness == Brightness.dark
                ? DarkTheme.formFieldBorder
                : LightTheme.formFieldBorder,
        focusedBorder: Theme.of(context).brightness == Brightness.dark
                       ? DarkTheme.formFieldFocusedBorder
                       : LightTheme.formFieldFocusedBorder,
        labelText: "Email",
        labelStyle: Theme.of(context).brightness == Brightness.dark
                    ? DarkTheme.formFieldLabelStyle
                    : LightTheme.formFieldLabelStyle,
      ),
    );

    final loginButton = PrimaryBlueCTA(
      callback: () async {
        FocusScope.of(context).unfocus();
        if (_loginLoading == false) {
          FocusScope.of(context).unfocus();
          bool status = await _validateAndSave();
          if (status) {
            Constant.showToastInstruction("Email sent to\n$_email.");
          } else {
            Constant.showToastError("Email not sent.");
          }
        }
      },
      child: _loginLoading
          ? Center(
              child: SizedBox(
                height: 24.0,
                width: 24.0,
                child: CircularProgressIndicator(),
              ),
            )
          : Text(
              "Request Login Email",
              style: Theme.of(context).brightness == Brightness.dark
                     ? DarkTheme.primaryCTATextStyle
                     : LightTheme.primaryCTATextStyle,
            ),
    );

    final loginForm = Form(
      key: _formKey,
      child: ListView(physics: NeverScrollableScrollPhysics(), shrinkWrap: true, children: <Widget>[
        email,
        SizedBox(height: 24),
        loginButton,
      ]),
    );
    return loginForm;
  }

  @override
  bool get wantKeepAlive => true;
}
