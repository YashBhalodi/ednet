import 'package:ednet/setup/login_page.dart';
import 'package:ednet/setup/signup_instruction_page.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/material.dart';

class Onboarding extends StatefulWidget {
  final bool isLogin;

  const Onboarding({Key key, this.isLogin: false}) : super(key: key);

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  PageController _pageController;
  int stepOfOnboarding;

  @override
  void initState() {
    super.initState();
    if (widget.isLogin == true) {
      _pageController = PageController(initialPage: 4);
      stepOfOnboarding = 5;
    } else {
      _pageController = PageController();
      stepOfOnboarding = 1;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          Constant.myLinearProgressIndicator(stepOfOnboarding / 5),
          Expanded(
            child: PageView(
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              physics: NeverScrollableScrollPhysics(),
              pageSnapping: true,
              onPageChanged: (p) {
                setState(() {
                  stepOfOnboarding = p + 1;
                });
              },
              children: <Widget>[
                Page1(),
                Page2(),
                Page3(),
                Page4(),
                Page5(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    onPressed: stepOfOnboarding == 1
                        ? null
                        : () {
                            _pageController.previousPage(
                                duration: Constant.pageAnimationDuration, curve: Curves.easeInOut);
                          },
                    padding: Constant.raisedButtonPaddingLow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      side: BorderSide(color: Colors.grey[300], width: 2.0),
                    ),
                    color: Colors.white,
                    child: Icon(
                      Icons.navigate_before,
                      size: 32.0,
                      color: Colors.grey[800],
                    ),
                    disabledColor: Colors.grey[300],
                  ),
                ),
                SizedBox(
                  width: 8.0,
                ),
                Expanded(
                  child: RaisedButton(
                    onPressed: stepOfOnboarding == 5
                        ? null
                        : () {
                            _pageController.nextPage(
                                duration: Constant.pageAnimationDuration, curve: Curves.easeInOut);
                          },
                    padding: Constant.raisedButtonPaddingLow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      side: BorderSide(color: Colors.grey[300], width: 2.0),
                    ),
                    color: Colors.white,
                    disabledColor: Colors.grey[300],
                    child: Icon(
                      Icons.navigate_next,
                      size: 32.0,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () async {
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setBool("welcome", true);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) {
                return LoginPage();
              },
            ),
          );
        },
      ),*/
    );
  }
}

class Page5 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Padding(
            padding: Constant.edgePadding,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Login using your email",
                    style: Constant.sectionSubHeadingStyle,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    "Securely login without any hassle of remembering password.",
                    style: Constant.sectionSubHeadingDescriptionStyle,
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  LoginPage(),
                ],
              ),
            ),
          ),
        ),
        Divider(
          thickness: 1.5,
          color: Colors.blue[200],
          endIndent: 5.0,
          indent: 5.0,
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: Constant.edgePadding,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Sign Up for Ednet",
                    style: Constant.sectionSubHeadingStyle,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    "To build authentic network of students, only verified Email address as users.",
                    style: Constant.sectionSubHeadingDescriptionStyle,
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  SecondaryCTA(
                    child: Text(
                      "Sign up instruction",
                      style: Constant.secondaryCTATextStyle
                    ),
                    callback: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        return SignUpInstruction();
                      }));
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("Page 1")),
    );
  }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("Page 2")),
    );
  }
}

class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("Page 3")),
    );
  }
}

class Page4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("Page 4")),
    );
  }
}
