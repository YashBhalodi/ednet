import 'package:ednet/home/feed/question/question_page.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateAnswer extends StatefulWidget {
    final Question question;
    final Answer answer;

    const CreateAnswer({Key key, @required this.question, this.answer}) : super(key: key);

    @override
    _CreateAnswerState createState() => _CreateAnswerState();
}

class _CreateAnswerState extends State<CreateAnswer> {
    final GlobalKey _answerFormKey = GlobalKey<FormState>();
    Answer _answer;

    @override
    void initState() {
        super.initState();
        _answer = widget.answer ?? Answer();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            body: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                    Expanded(
                        child: ListView(
                            shrinkWrap: true,
                            children: <Widget>[
                                QuestionTile(
                                    question: widget.question,
                                ),
                                ListView(
                                    shrinkWrap: true,
                                    padding: Constant.edgePadding,
                                    physics: NeverScrollableScrollPhysics(),
                                    children: <Widget>[
                                        Text(
                                            "Answer to question...",
                                            style: Constant.sectionSubHeadingStyle,
                                        ),
                                        SizedBox(
                                            height: 20.0,
                                        ),
                                        Form(
                                            key: _answerFormKey,
                                            child: TextFormField(
                                                onSaved: (d) {
                                                    setState(() {
                                                        _answer.content = d;
                                                    });
                                                },
                                                style: Constant.formFieldTextStyle,
                                                minLines: 15,
                                                maxLines: 25,
                                                maxLength: 10000,
                                                validator: (value) =>
                                                    Constant.answerValidator(value),
                                                keyboardType: TextInputType.multiline,
                                                decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.grey[200],
                                                    border: null,
                                                    focusedBorder: null,
                                                    contentPadding: Constant
                                                        .formFieldContentPadding,
                                                    hintText: "Clear and concise answer will get you more upvotes...",
                                                ),
                                            ),
                                        )
                                    ],
                                )
                            ],
                        ),
                    ),
                    SizedBox(
                        height: 54.0,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                                Expanded(
                                    child: RaisedButton(
                                        child: Text("Save Draft",style: Constant.secondaryCTATextStyle,),
                                        onPressed: () {
                                            //TODO implement save draft
                                        },
                                        padding: Constant.raisedButtonPaddingHigh,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10.0),
                                                bottomLeft: Radius.circular(10.0),),
                                            side: BorderSide(color: Colors.grey[300], width: 2.0),
                                        ),
                                        color: Colors.white,
                                        disabledColor: Colors.grey[300],
                                    ),
                                ),
                                Expanded(
                                    child: RaisedButton(
                                        onPressed: (){
                                            //TODO implement Post answer
                                        },
                                        textColor: Colors.white,
                                        child: Text("Post Answer",style: Constant.primaryCTATextStyle,),
                                        padding: Constant.raisedButtonPaddingHigh,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(topRight:Radius.circular(10.0),bottomRight: Radius.circular(10.0),),
                                            side: BorderSide(color: Colors.blue[400], width: 2.0),
                                        ),
                                        color: Colors.blue[700],
                                        disabledColor: Colors.grey[300],
                                    ),
                                ),
                            ],
                        ),
                    )
                ],
            ),
        );
    }
}
