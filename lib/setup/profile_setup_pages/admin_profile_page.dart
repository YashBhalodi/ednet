import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/home_page.dart';
import 'package:ednet/setup/profile_setup_pages/topic_selection_profile_setup.dart';
import 'package:ednet/setup/profile_setup_pages/university_details_profile_setup_page.dart';
import 'package:ednet/setup/profile_setup_pages/user_details_profile_setup_page.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminProfileSetup extends StatefulWidget {
  final DocumentSnapshot userSnap;
  final DocumentSnapshot universitySnap;

  const AdminProfileSetup({Key key, @required this.userSnap, @required this.universitySnap})
      : super(key: key);

  @override
  _AdminProfileSetupState createState() => _AdminProfileSetupState();
}

class _AdminProfileSetupState extends State<AdminProfileSetup> {
  PageController _pageController = PageController();
  double _progressValue = 1 / 3;

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
        _progressValue = 2 / 3;
      });
    } else if (stepNumber == 2) {
      _pageController.animateToPage(2,
          duration: Constant.pageAnimationDuration, curve: Curves.easeInOut);
      setState(() {
        _progressValue = 1;
      });
    } else if (stepNumber == 3) {
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
      print("Admin profile page:--Error");
    }
  }

  @override
  Widget build(BuildContext context) {
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
                _progressValue == 1 ? "Almost Done..." : "Let's set up your profile...",
                style: TextStyle(
                  color: Colors.green[900],
                  fontSize: 20.0,
                ),
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
                  UniversityDetails(
                    userSnap: widget.userSnap,
                    universitySnap: widget.universitySnap,
                    onSuccess: _onSuccessOfStep,
                  ),
                  TopicSelection(
                    userSnap: widget.userSnap,
                    universitySnap: widget.universitySnap,
                    onSuccess: _onSuccessOfStep,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
