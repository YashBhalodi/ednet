import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReportFlow {
  ///[contentCollection]=='Questions' or [contentCollection]=='Answers' or [contentCollection]=='Articles'
  ///[contentDocId] is the document id in which the sub-collection 'reports' will be created if not already present.
    static void showSubmitReportBottomSheet(
    context, {
    @required String contentCollection,
    @required String contentDocId,
  }) {
    showModalBottomSheet(
        context: context,
        elevation: 10.0,
        isDismissible: true,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16.0),
            topLeft: Radius.circular(16.0),
          ),
        ),
        builder: (context) {
          return Container(
            constraints: BoxConstraints.loose(
              Size(
                MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height * 0.65 +
                    MediaQuery.of(context).viewInsets.bottom,
              ),
            ),
              padding: const EdgeInsets.only(bottom:60),
              child: SubmitContentReport(
              contentCollection: contentCollection,
              contentDocId: contentDocId,
            ),
          );
        });
  }
}

class SubmitContentReport extends StatefulWidget {
  final String contentCollection;
  final String contentDocId;

  ///[contentCollection]=='Questions' or [contentCollection]=='Answers' or [contentCollection]=='Articles'
  ///[contentDocId] is the document id in which the sub-collection 'reports' will be created if not already present.
  const SubmitContentReport({Key key, @required this.contentCollection, @required this.contentDocId})
      : super(key: key);

  @override
  _SubmitContentReportState createState() => _SubmitContentReportState();
}

class _SubmitContentReportState extends State<SubmitContentReport> {
  ScrollController _scrollController = ScrollController();
  GlobalKey _formKey = GlobalKey<FormState>();
  Report _report = Report();
  bool _submitLoading = false;
  List<String> _selectedViolationList = [];
  List<String> _availableViolationList;
  List<String> _availableViolationDescription;
  String _comment;

  void _loadAvailableViolations() {
    if (widget.contentCollection == 'Questions') {
      _availableViolationList = [
        "Harassment",
        "Spam",
        "Insincere",
        "Poorly Written",
        "Incorrect Topics",
        "Non-Educational",
        "Others",
      ];
      _availableViolationDescription = [
        "Disparaging or adversarial towards a group or a person",
        "Undisclosed promotion for a link or product",
        "Not seeking genuine answers",
        "Not in English or has very bad formatting, grammar and spelling",
        "Topics are irrelevant to the content or overly broad",
        "Not relevant to some educational curriculum",
        "Violations that are not covered above"
      ];
    } else if (widget.contentCollection == 'Articles') {
      _availableViolationList = [
        "Harassment",
        "Spam",
        "Poorly Written",
        "Incorrect Topics",
        "Non-Educational",
        "Others",
      ];
      _availableViolationDescription = [
        "Disparaging or adversarial towards a group or a person",
        "Undisclosed promotion for a link or product",
        "Not in English or has very bad formatting, grammar and spelling",
        "Topics are irrelevant to the content or overly broad",
        "Not relevant to some educational curriculum",
        "Violations that are not covered above"
      ];
    } else if (widget.contentCollection == 'Answers') {
      _availableViolationList = [
        "Harassment",
        "Spam",
        "Doesn't Answer the Question",
        "Joke Answer",
        "Poorly Written",
        "Others"
      ];
      _availableViolationDescription = [
        "Disparaging or adversarial towards a group or a person",
        "Undisclosed promotion for a link or product",
        "Does not address the question that was asked",
        "Not a sincere answer",
        "Not in English or has very bad formatting, grammar and spelling",
        "Violations that are not covered above"
      ];
    } else {
      print(
          '122___ReportContentState___ReportContentState._loadAvailableViolations__report_content_sheet.dart');
      throw "Invalid Content Collection type";
    }
  }

  Future<void> _submitReport() async {
    setState(() {
      _submitLoading = true;
    });
    if (_selectedViolationList.length >= 1) {
      final FormState _form = _formKey.currentState;
      if (_form.validate()) {
        FocusScope.of(context).unfocus();
        _form.save();
        _report.reporter = await Constant.getCurrentUserDocId();
        _report.weight = 0.0; //TODO Calculate weight
        _report.comment = _comment;
        _report.violations = _selectedViolationList;
        _report.reportedOn = DateTime.now();
        await _report.upload(widget.contentCollection, widget.contentDocId);
      } else {
        await _scrollController.animateTo(300,
            duration: Constant.scrollAnimationDuration, curve: Curves.easeInOut);
        setState(() {
          _submitLoading = false;
        });
        return;
      }
    } else {
      Constant.showToastError("Please select atleast one option");
      setState(() {
        _submitLoading = false;
      });
      return;
    }
    setState(() {
      _submitLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    _loadAvailableViolations();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 16.0,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: Scrollbar(
              child: ListView(
                controller: _scrollController,
                shrinkWrap: true,
                children: <Widget>[
                  SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      "Select atleast one violation that is applicable...",
                      style: Theme.of(context).brightness == Brightness.dark
                          ? DarkTheme.headingDescriptionStyle
                          : LightTheme.headingDescriptionStyle,
                    ),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _availableViolationList.length,
                    itemBuilder: (_, i) {
                      return MyCheckBoxTile(
                        title: _availableViolationList[i],
                        subtitle: _availableViolationDescription[i],
                        outputList: _selectedViolationList,
                      );
                    },
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextFormField(
                        onSaved: (value) {
                          _comment = value;
                        },
                        minLines: 3,
                        maxLines: 7,
                        validator: (value) => Constant.reportCommentValidator(value),
                        style: Theme.of(context).brightness == Brightness.dark
                            ? DarkTheme.formFieldTextStyle
                            : LightTheme.formFieldTextStyle,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          filled: true,
                          fillColor: Theme
                                         .of(context)
                                         .brightness == Brightness.dark
                                     ? DarkTheme.textFieldFillColor
                                     : LightTheme.textFieldFillColor,
                          counterStyle: Theme.of(context).brightness == Brightness.dark
                              ? DarkTheme.counterStyle
                              : LightTheme.counterStyle,
                          contentPadding: Constant.formFieldContentPadding,
                          hintText: "Describe the issue with this content in brief...",
                          hintStyle: Theme.of(context).brightness == Brightness.dark
                              ? DarkTheme.formFieldHintStyle
                              : LightTheme.formFieldHintStyle,
                          border: Theme.of(context).brightness == Brightness.dark
                              ? DarkTheme.formFieldBorder
                              : LightTheme.formFieldBorder,
                          focusedBorder: Theme.of(context).brightness == Brightness.dark
                              ? DarkTheme.formFieldFocusedBorder
                              : LightTheme.formFieldFocusedBorder,
                          labelText: "Description",
                          labelStyle: Theme.of(context).brightness == Brightness.dark
                              ? DarkTheme.formFieldLabelStyle
                              : LightTheme.formFieldLabelStyle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          SizedBox(
            width: double.maxFinite,
            height: 54.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: SecondaryNegativeCardButton(
                    callback: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Cancle",
                      style: Theme.of(context).brightness == Brightness.dark
                             ? DarkTheme.secondaryNegativeTextStyle
                             : LightTheme.secondaryNegativeTextStyle,
                    ),
                  ),
                ),
                Expanded(
                  child: SecondaryPositiveCardButton(
                    callback: () async {
                      if (_submitLoading == false) {
                        await _submitReport();
                      }
                    },
                    child: _submitLoading
                        ? SizedBox(
                            height: 18.0,
                            width: 18.0,
                            child: CircularProgressIndicator(),
                          )
                        : Text(
                            "Report",
                            style: Theme.of(context).brightness == Brightness.dark
                                   ? DarkTheme.secondaryPositiveTextStyle
                                   : LightTheme.secondaryPositiveTextStyle,
                          ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
