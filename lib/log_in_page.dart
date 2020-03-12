import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
    @override
    LoginPageState createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
    String _email;
    String _link;
    final _formKey = GlobalKey<FormState>();
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    @override
    void initState() {
        super.initState();
        WidgetsBinding.instance.addObserver(this);
    }

    @override
    Widget build(BuildContext context) {
        final snackBarEmailSent = SnackBar(content: Text('Email Sent!'));
        final snackBarEmailNotSent = SnackBar(
            content: Text('Email Not Sent. Error.'),
        );

        final email = TextFormField(
            keyboardType: TextInputType.emailAddress,
            autofocus: false,
            validator: (value) {
                if (value.isEmpty) return "Email cannot be empty";
                return null;
            },
            onSaved: (value) => _email = value,
            decoration: InputDecoration(
                hintText: 'Email',
                prefixIcon: Icon(Icons.mail),
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            ),
        );

        final loginButton = Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
                color: Colors.lightBlueAccent,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                child: Text("Send Verification Email"),
                onPressed: (() async => await validateAndSave()
                                        ? _scaffoldKey.currentState.showSnackBar(snackBarEmailSent)
                                        : _scaffoldKey.currentState.showSnackBar(snackBarEmailNotSent)),
                padding: EdgeInsets.all(12),
            ),
        );

        final loginForm = Form(
            key: _formKey,
            child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 24, right: 24),
                children: <Widget>[
                    SizedBox(height: 50),
                    email,
                    SizedBox(height: 40),
                    loginButton
                ],
            ),
        );
        return Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            body: Center(child: loginForm));
    }

    Future<bool> validateAndSave() async {
        final FormState form = _formKey.currentState;
        if (form.validate()) {
            form.save();
            bool sent = await _sendSignInWithEmailLink();
            return sent;
        }
        return false;
    }

    Future<bool> _sendSignInWithEmailLink() async {
        final FirebaseAuth user = FirebaseAuth.instance;
        try {
            user.sendSignInWithEmailLink(
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

    @override
    void didChangeAppLifecycleState(AppLifecycleState state) {
        if (state == AppLifecycleState.resumed) {
            _retrieveDynamicLink();
        }
    }

    Future<void> _retrieveDynamicLink() async {
        final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.retrieveDynamicLink();

        final Uri deepLink = data?.link;
        print("deepLink:-"+deepLink.toString());

        if (deepLink.toString() != null) {
            _link = deepLink.toString();
            _signInWithEmailAndLink();
        }
        return deepLink?.toString();
    }

    Future<void> _signInWithEmailAndLink() async {
        final FirebaseAuth user = FirebaseAuth.instance;
        bool validLink = await user.isSignInWithEmailLink(_link);
        if (validLink) {
            try {
                await user.signInWithEmailAndLink(email: _email, link: _link);
            } catch (e) {
                print(e);
                _showDialog(e.toString());
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
}
