import 'package:ednet/setup/login_page.dart';
import 'package:ednet/setup/signup_instruction_page.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Onboarding extends StatefulWidget {
  final bool isLogin;

  const Onboarding({Key key, this.isLogin: false}) : super(key: key);

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  PageController pageController;
  int stepOfOnboarding;
  int triedExit = 0;

  @override
  void initState() {
    super.initState();
    if (widget.isLogin == true) {
      pageController = PageController(initialPage: 4);
      stepOfOnboarding = 5;
    } else {
      pageController = PageController();
      stepOfOnboarding = 1;
    }
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (triedExit >= 1) {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          return true;
        } else {
          triedExit++;
          Constant.showToastInstruction("Press again to exit");
          return false;
        }
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          resizeToAvoidBottomInset: false,
          body: Column(
            children: <Widget>[
              Constant.myLinearProgressIndicator(stepOfOnboarding / 5),
              Expanded(
                child: PageView(
                  controller: pageController,
                  scrollDirection: Axis.horizontal,
                  physics: NeverScrollableScrollPhysics(),
                  pageSnapping: true,
                  onPageChanged: (p) {
                    setState(() {
                      stepOfOnboarding = p + 1;
                    });
                  },
                  children: <Widget>[
                    Page1(key:Key('page1')),
                    Page2(key:Key('page2')),
                    Page3(key:Key('page3')),
                    Page4(key:Key('page4')),
                    Page5(key:Key('page5')),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
                child: SizedBox(
                  height: 50,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: StepButton(
                          key: Key('prevButton'),
                          callback: stepOfOnboarding == 1
                              ? null
                              : () {
                                  pageController.previousPage(
                                      duration: Constant.pageAnimationDuration,
                                      curve: Curves.easeInOut);
                                },
                          direction: 'prev',
                        ),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Expanded(
                        child: StepButton(
                          key: Key('nextButton'),
                          callback: stepOfOnboarding == 5
                              ? null
                              : () {
                                  pageController.nextPage(
                                      duration: Constant.pageAnimationDuration,
                                      curve: Curves.easeInOut);
                                },
                          direction: 'next',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Page5 extends StatelessWidget {
  const Page5({Key key}) : super(key:key);

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
                    style: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.headingStyle
                        : LightTheme.headingStyle,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    "Securely login without any hassle of remembering password.",
                    style: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.headingDescriptionStyle
                        : LightTheme.headingDescriptionStyle,
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
                    "Join EDNET",
                    style: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.headingStyle
                        : LightTheme.headingStyle,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    "Only verified institutional email ids can join EDNET.\nWe can build authentic network of students and professors using these ids.",
                    style: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.headingDescriptionStyle
                        : LightTheme.headingDescriptionStyle,
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  SecondaryCTA(
                    child: Text("How to join EDNET",
                        style: Theme.of(context).brightness == Brightness.dark
                            ? DarkTheme.secondaryCTATextStyle
                            : LightTheme.secondaryCTATextStyle),
                    callback: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return SignUpInstruction();
                          },
                        ),
                      );
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

//TODO Fill the content of onboarding
class Page1 extends StatelessWidget {
  const Page1({Key key}) : super(key:key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("Page 1")),
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({Key key}) : super(key:key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("Page 2")),
    );
  }
}

class Page3 extends StatelessWidget {
  const Page3({Key key}) : super(key:key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("Page 3")),
    );
  }
}

class Page4 extends StatelessWidget {
  const Page4({Key key}) : super(key:key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("Page 4")),
    );
  }
}
