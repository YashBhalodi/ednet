import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/material.dart';

class UniversityDetails extends StatefulWidget {
  final DocumentSnapshot userSnap;
  final DocumentSnapshot universitySnap;
  final Function onSuccess;

  const UniversityDetails(
      {Key key, @required this.userSnap, @required this.universitySnap, @required this.onSuccess})
      : super(key: key);

  @override
  _UniversityDetailsState createState() => _UniversityDetailsState();
}

class _UniversityDetailsState extends State<UniversityDetails> with AutomaticKeepAliveClientMixin {
  GlobalKey _universityKey = GlobalKey<FormState>();
  FocusNode _universityNameFocus = FocusNode();
  FocusNode _universityCountryFocus = FocusNode();
  FocusNode _universityStateFocus = FocusNode();
  FocusNode _universityCityFocus = FocusNode();
  ScrollController _universityScrollController = ScrollController();

  bool _isLoading = false;
  String _inputUniversityCountry;
  String _inputUniversityState;
  String _inputUniversityCity;

  Future<void> uploadUniversityDetails() async {
    try {
      Firestore.instance
          .collection('University')
          .document(widget.universitySnap.documentID)
          .updateData({
        'city': _inputUniversityCity,
        'state': _inputUniversityState,
        'country': _inputUniversityCountry,
      });
    } catch (e) {
      print("updateUniversitydata:-");
      print(e);
    }
  }

  Future<void> _submitUniversityDetailForm() async {
    final FormState form = _universityKey.currentState;
    setState(() {
      _isLoading = true;
    });
    if (form.validate()) {
      form.save();
      try {
        FocusScope.of(context).unfocus();
        await uploadUniversityDetails();
        setState(() {
          _isLoading = false;
        });
        widget.onSuccess(2);
      } catch (e) {
        print("uploadUniversityDetails:-");
        print(e);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _universityNameFocus.dispose();
    _universityCountryFocus.dispose();
    _universityStateFocus.dispose();
    _universityCityFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Form(
      key: _universityKey,
      child: Scrollbar(
        child: ListView(
          padding: Constant.edgePadding,
          controller: _universityScrollController,
          shrinkWrap: true,
          children: <Widget>[
            Text(
              widget.universitySnap.data['name'],
              style: Theme.of(context).brightness == Brightness.dark
                  ? DarkTheme.headingStyle
                  : LightTheme.headingStyle,
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              "University Details",
              style: Theme.of(context).brightness == Brightness.dark
                  ? DarkTheme.headingDescriptionStyle
                  : LightTheme.headingDescriptionStyle,
            ),
            SizedBox(
              height: 32.0,
            ),
            TextFormField(
              onSaved: (value) {
                _inputUniversityCountry = value.trim();
              },
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(_universityStateFocus);
                _universityScrollController.animateTo(100.0,
                    duration: Constant.scrollAnimationDuration, curve: Curves.easeInOut);
              },
              initialValue: widget.universitySnap.data['country'] ?? null,
              validator: (value) => Constant.countryValidator(value),
              keyboardType: TextInputType.text,
              style: Theme.of(context).brightness == Brightness.dark
                  ? DarkTheme.formFieldTextStyle
                  : LightTheme.formFieldTextStyle,
              decoration: InputDecoration(
                counterStyle: Theme.of(context).brightness == Brightness.dark
                    ? DarkTheme.counterStyle
                    : LightTheme.counterStyle,
                contentPadding: Constant.formFieldContentPadding,
                hintText: "India",
                hintStyle: Theme.of(context).brightness == Brightness.dark
                    ? DarkTheme.formFieldHintStyle
                    : LightTheme.formFieldHintStyle,
                border: Theme.of(context).brightness == Brightness.dark
                    ? DarkTheme.formFieldBorder
                    : LightTheme.formFieldBorder,
                focusedBorder: Theme.of(context).brightness == Brightness.dark
                    ? DarkTheme.formFieldFocusedBorder
                    : LightTheme.formFieldFocusedBorder,
                labelText: "Country",
                labelStyle: Theme.of(context).brightness == Brightness.dark
                    ? DarkTheme.formFieldLabelStyle
                    : LightTheme.formFieldLabelStyle,
              ),
              focusNode: _universityCountryFocus,
            ),
            SizedBox(
              height: 32.0,
            ),
            TextFormField(
              onSaved: (value) {
                _inputUniversityState = value.trim();
              },
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(_universityCityFocus);
                _universityScrollController.animateTo(200.0,
                    duration: Constant.scrollAnimationDuration, curve: Curves.easeInOut);
              },
              initialValue: widget.universitySnap.data['state'] ?? null,
              validator: (value) => Constant.stateValidator(value),
              keyboardType: TextInputType.text,
              style: Theme.of(context).brightness == Brightness.dark
                  ? DarkTheme.formFieldTextStyle
                  : LightTheme.formFieldTextStyle,
              decoration: InputDecoration(
                counterStyle: Theme.of(context).brightness == Brightness.dark
                    ? DarkTheme.counterStyle
                    : LightTheme.counterStyle,
                contentPadding: Constant.formFieldContentPadding,
                hintText: "Gujarat",
                hintStyle: Theme.of(context).brightness == Brightness.dark
                    ? DarkTheme.formFieldHintStyle
                    : LightTheme.formFieldHintStyle,
                border: Theme.of(context).brightness == Brightness.dark
                    ? DarkTheme.formFieldBorder
                    : LightTheme.formFieldBorder,
                focusedBorder: Theme.of(context).brightness == Brightness.dark
                    ? DarkTheme.formFieldFocusedBorder
                    : LightTheme.formFieldFocusedBorder,
                labelText: "Region/State",
                labelStyle: Theme.of(context).brightness == Brightness.dark
                    ? DarkTheme.formFieldLabelStyle
                    : LightTheme.formFieldLabelStyle,
              ),
              focusNode: _universityStateFocus,
            ),
            SizedBox(
              height: 32.0,
            ),
            TextFormField(
              onSaved: (value) {
                _inputUniversityCity = value.trim();
              },
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
                _universityScrollController.animateTo(300.0,
                    duration: Constant.scrollAnimationDuration, curve: Curves.easeInOut);
              },
              initialValue: widget.universitySnap.data['city'] ?? null,
              validator: (value) => Constant.cityValidator(value),
              keyboardType: TextInputType.text,
              style: Theme.of(context).brightness == Brightness.dark
                  ? DarkTheme.formFieldTextStyle
                  : LightTheme.formFieldTextStyle,
              decoration: InputDecoration(
                counterStyle: Theme.of(context).brightness == Brightness.dark
                    ? DarkTheme.counterStyle
                    : LightTheme.counterStyle,
                contentPadding: Constant.formFieldContentPadding,
                hintText: "Gandhinagar",
                hintStyle: Theme.of(context).brightness == Brightness.dark
                    ? DarkTheme.formFieldHintStyle
                    : LightTheme.formFieldHintStyle,
                border: Theme.of(context).brightness == Brightness.dark
                    ? DarkTheme.formFieldBorder
                    : LightTheme.formFieldBorder,
                focusedBorder: Theme.of(context).brightness == Brightness.dark
                    ? DarkTheme.formFieldFocusedBorder
                    : LightTheme.formFieldFocusedBorder,
                labelText: "City",
                labelStyle: Theme.of(context).brightness == Brightness.dark
                    ? DarkTheme.formFieldLabelStyle
                    : LightTheme.formFieldLabelStyle,
              ),
              focusNode: _universityCityFocus,
            ),
            SizedBox(
              height: 32.0,
            ),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: PrimaryBlueCTA(
                  child: _isLoading
                      ? Theme.of(context).brightness == Brightness.dark
                          ? DarkTheme.circularProgressIndicator
                          : LightTheme.circularProgressIndicator
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Text(
                              "Next",
                                style: Theme
                                           .of(context)
                                           .brightness == Brightness.dark
                                       ? DarkTheme.primaryCTATextStyle
                                       : LightTheme.primaryCTATextStyle,
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Icon(
                              Icons.arrow_forward,
                              size: 20.0,
                                color: Theme
                                           .of(context)
                                           .brightness == Brightness.dark
                                       ? DarkTheme.primaryCTATextColor
                                       : LightTheme.primaryCTATextColor,
                            )
                          ],
                        ),
                  callback: () async {
                    await _submitUniversityDetailForm();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
