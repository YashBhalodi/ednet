import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/utilities_files/contants.dart';

class UniversityDetails extends StatefulWidget {
  final DocumentSnapshot userSnap;
  final DocumentSnapshot universitySnap;
  final Function onSuccess;

  const UniversityDetails({Key key,@required this.userSnap,@required this.universitySnap,@required this.onSuccess}) : super(key: key);

    @override
  _UniversityDetailsState createState() => _UniversityDetailsState();
}

class _UniversityDetailsState extends State<UniversityDetails> {
    GlobalKey _universityKey = GlobalKey<FormState>();
    FocusNode _universityNameFocus = FocusNode();
    FocusNode _universityCountryFocus = FocusNode();
    FocusNode _universityStateFocus = FocusNode();
    FocusNode _universityCityFocus = FocusNode();
    FocusNode _submitPartTwoFocus = FocusNode();
    ScrollController _universityScrollController = ScrollController();

    bool _isLoading = false;
    String _inputUniversityCountry;
    String _inputUniversityState;
    String _inputUniversityCity;

    Future<void> uploadUniversityDetails() async {
        try {
            Firestore.instance.collection('University').document(widget.universitySnap.documentID).updateData({
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
                    _isLoading = false;});
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
    return Form(
        key: _universityKey,
        child: ListView(
            padding: Constant.edgePadding,
            controller: _universityScrollController,
            shrinkWrap: true,
            children: <Widget>[
                Text(
                    widget.universitySnap.data['name'],
                    style: Constant.sectionSubHeadingStyle,
                ),
                SizedBox(height: 16.0,),
                Text(
                    "University Details",
                    style: Constant.sectionSubHeadingDescriptionStyle,
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
                    initialValue: widget.universitySnap.data['country']??null,
                    validator: (value) => Constant.nameValidator(value),
                    keyboardType: TextInputType.text,
                    style: Constant.formFieldTextStyle,
                    decoration: InputDecoration(
                        counterStyle: Constant.counterStyle,
                        contentPadding: Constant.formFieldContentPadding,
                        hintText: "India",
                        hintStyle: Constant.formFieldHintStyle,
                        border: Constant.formFieldBorder,
                        focusedBorder: Constant.formFieldFocusedBorder,
                        labelText: "Country",
                        labelStyle: Constant.formFieldLabelStyle,
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
                    initialValue: widget.universitySnap.data['state']??null,
                    validator: (value) => Constant.nameValidator(value),
                    keyboardType: TextInputType.text,
                    style: Constant.formFieldTextStyle,
                    decoration: InputDecoration(
                        counterStyle: Constant.counterStyle,
                        contentPadding: Constant.formFieldContentPadding,
                        hintText: "Gujarat",
                        hintStyle: Constant.formFieldHintStyle,
                        border: Constant.formFieldBorder,
                        focusedBorder: Constant.formFieldFocusedBorder,
                        labelText: "Region/State",
                        labelStyle: Constant.formFieldLabelStyle,
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
                        FocusScope.of(context).requestFocus(_submitPartTwoFocus);
                        _universityScrollController.animateTo(300.0,
                            duration: Constant.scrollAnimationDuration, curve: Curves.easeInOut);
                    },
                    initialValue: widget.universitySnap.data['city']??null,
                    validator: (value) => Constant.nameValidator(value),
                    keyboardType: TextInputType.text,
                    style: Constant.formFieldTextStyle,
                    decoration: InputDecoration(
                        counterStyle: Constant.counterStyle,
                        contentPadding: Constant.formFieldContentPadding,
                        hintText: "Gandhinagar",
                        hintStyle: Constant.formFieldHintStyle,
                        border: Constant.formFieldBorder,
                        focusedBorder: Constant.formFieldFocusedBorder,
                        labelText: "City",
                        labelStyle: Constant.formFieldLabelStyle,
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
                        child: RaisedButton(
                            focusNode: _submitPartTwoFocus,
                            onPressed: () async {
                                await _submitUniversityDetailForm();
                            },
                            padding: Constant.raisedButtonPaddingHigh,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                                side: BorderSide(color: Colors.green[800], width: 2.0),
                            ),
                            color: Colors.green[50],
                            child: _isLoading
                                   ? Constant.greenCircularProgressIndicator
                                   : Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                    Text(
                                        "Next",
                                        style: TextStyle(
                                            fontSize: 22.0,
                                            color: Colors.green[800],
                                        ),
                                    ),
                                    SizedBox(
                                        width: 8.0,
                                    ),
                                    Icon(
                                        Icons.arrow_forward,
                                        size: 20.0,
                                        color: Colors.green[800],
                                    )
                                ],
                            ),
                        ),
                    ),
                ),
            ],
        ),
    );
  }
}
