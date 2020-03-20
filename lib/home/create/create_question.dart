import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/contants.dart';
import 'package:flutter/material.dart';
import 'package:ednet/utilities_files/classes.dart';

class CreateQuestion extends StatefulWidget {
    @override
    _CreateQuestionState createState() => _CreateQuestionState();
}

class _CreateQuestionState extends State<CreateQuestion> {
    Question que = Question(
        createdOn: DateTime.now(),
        description: "This is Question Description.",
        downvoteCount: 0,
        downvoters: [],
        editedOn: DateTime.now(),
        heading: "This is heading",
        topic: "Economics",
        upvoteCount: 0,
        upvoters: [],
        username: "YashB",
    );

    double _progressValue = 1 / 4;

    PageController _pageController = PageController(initialPage: 0,);

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            //TODO will pop scope for save draft confirmation before exiting
            appBar: AppBar(
                title: Text(
                    "Ask Question...",
                    style: Constant.appBarTextStyle,
                ),
            ),
            body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
Constant.myLinearProgressIndicator(_progressValue),
                    Expanded(
                      child: PageView(
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          controller: _pageController,
                          onPageChanged: (p) {
                              setState(() {
                                  _progressValue = (p + 1) / 4;
                              });
                          },
                          children: <Widget>[
                              Container(child: Center(child: Text("Page"),),),
                              Container(child: Center(child: Text("Page"),),),
                              Container(child: Center(child: Text("Page"),),),
                              Container(child: Center(child: Text("Page"),),),
                          ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical:8.0,horizontal: 4.0),
                      child: SizedBox(
                          height: 64.0,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                                Expanded(
                                    flex: 1,
                                    child: SizedBox(
                                        height: double.maxFinite,
                                      child: RaisedButton(
                                          onPressed: _progressValue == 1/4
                                                     ? null
                                                     : () {
                                              _pageController.previousPage(
                                                  duration: Constant.pageAnimationDuration,
                                                  curve: Curves.easeInOut);
                                          },
                                          padding: Constant.raisedButtonPaddingLow,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16.0),
                                              side: BorderSide(color: Colors.grey[300], width: 1.0),
                                          ),
                                          color: Colors.white,
                                          child: Icon(
                                              Icons.navigate_before,
                                              size: 24.0,
                                              color: Colors.grey[800],
                                          ),
                                          disabledColor: Colors.grey[300],
                                      ),
                                    ),
                                ),
                                SizedBox(width: 4.0,),
                                Expanded(
                                    flex: 4,
                                    child: AnimatedCrossFade(
                                        firstChild: SizedBox(
                                            height: double.maxFinite,
                                            width: double.maxFinite,
                                          child: RaisedButton(
                                              onPressed: () {},
                                              padding: Constant.raisedButtonPaddingLow,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(16.0),
                                                  side: BorderSide(color: Colors.grey[300], width: 1.0),
                                              ),
                                              color: Colors.white,
                                              child: Text(
                                                  "Save Draft",
                                                  style: Constant.secondaryCTATextStyle,
                                              ),
                                              disabledColor: Colors.grey[300],
                                          ),
                                        ),
                                        secondChild: SizedBox(
                                            height: double.maxFinite,
                                            width: double.maxFinite,
                                          child: RaisedButton(
                                              onPressed: () {},
                                              padding: Constant.raisedButtonPaddingLow,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(16.0),
                                                  side: BorderSide(color: Colors.green[500], width: 1.0),
                                              ),
                                              color: Colors.green[700],
                                              child: Text(
                                                  "Publish",
                                                  style: Constant.primaryCTATextStyle,
                                              ),
                                              disabledColor: Colors.grey[300],
                                          ),
                                        ),
                                        crossFadeState:
                                        _progressValue == 1
                                        ? CrossFadeState.showSecond
                                        : CrossFadeState.showFirst,
                                        duration: Constant.scrollAnimationDuration,
                                    ),
                                ),
                                SizedBox(width: 4.0,),
                                Expanded(
                                    flex: 1,
                                    child: SizedBox(
                                        height: double.maxFinite,
                                      child: RaisedButton(
                                          onPressed: _progressValue == 1
                                                     ? null
                                                     : () {
                                              _pageController.nextPage(
                                                  duration: Constant.pageAnimationDuration,
                                                  curve: Curves.easeInOut);
                                          },
                                          padding: Constant.raisedButtonPaddingLow,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16.0),
                                              side: BorderSide(color: Colors.grey[300], width: 1.0),
                                          ),
                                          color: Colors.white,
                                          child: Icon(
                                              Icons.navigate_next,
                                              size: 24.0,
                                              color: Colors.grey[800],
                                          ),
                                          disabledColor: Colors.grey[300],
                                      ),
                                    ),
                                )
                            ],
                        ),
                      ),
                    ),
                ],
            ),
        );
    }
}
