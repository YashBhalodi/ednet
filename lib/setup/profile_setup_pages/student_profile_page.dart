import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/home_page.dart';
import 'package:ednet/setup/profile_setup_pages/topic_selection_profile_setup.dart';
import 'package:ednet/setup/profile_setup_pages/user_details_profile_setup_page.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StudentProfileSetup extends StatefulWidget {
  final DocumentSnapshot userSnap;

  const StudentProfileSetup({Key key, @required this.userSnap}) : super(key: key);

  @override
  _StudentProfileSetupState createState() => _StudentProfileSetupState();
}

class _StudentProfileSetupState extends State<StudentProfileSetup> {
  PageController _pageController = PageController();
  double _progressValue = 1 / 2;
  int triedExit = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void _onSuccessOfStep(int stepNumber) {
    if (stepNumber == 1) {
      _pageController.animateToPage(1,
          duration: Constant.pageAnimationDuration, curve: Curves.easeInOut);
      setState(() {
        _progressValue = 1;
      });
    } else if (stepNumber == 2) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) {
            return Home(
              userSnap: widget.userSnap,
            );
          },
        ),
      );
    } else {
      print("student_profile_setup: 50 : Error");
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        if(triedExit >= 1){
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
          resizeToAvoidBottomInset: true,
          resizeToAvoidBottomPadding: true,
          body: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                padding: Constant.edgePadding,
                color: Theme
                           .of(context)
                           .brightness == Brightness.dark
                       ? DarkTheme.profileSetupBannerColor
                       : LightTheme.profileSetupBannerColor,
                child: Text(
                  _progressValue == 1 ? "Almost Done..." : "Let's set up your profile...",
                  style: Theme
                             .of(context)
                             .brightness == Brightness.dark
                         ? DarkTheme.profileSetupBannerTextStyle
                         : LightTheme.profileSetupBannerTextStyle,
                ),
              ),
              Constant.myLinearProgressIndicator(_progressValue),
              Expanded(
                child: PageView(
                  scrollDirection: Axis.horizontal,
                  controller: _pageController,
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    UserDetails(
                      userSnap: widget.userSnap,
                      parentPageController: _pageController,
                      onSuccess: _onSuccessOfStep,
                    ),
                    TopicSelection(
                      userSnap: widget.userSnap,
                      onSuccess: _onSuccessOfStep,
                      isStudent: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
