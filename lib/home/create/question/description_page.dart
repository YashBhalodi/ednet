import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/contants.dart';
import 'package:flutter/material.dart';

class DescriptionPage extends StatefulWidget {
  final Question question;
  final PageController parentPageController;

  const DescriptionPage({Key key,@required this.question,@required this.parentPageController}) : super(key: key);
    @override
  _DescriptionPageState createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> with AutomaticKeepAliveClientMixin{
  ScrollController _scrollController = ScrollController();
  TextEditingController _descriptionController;
  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.question.description);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
      return ListView(
      shrinkWrap: true,
      padding: Constant.edgePadding,
      controller: _scrollController,
      children: <Widget>[
        Text(
          "Description",
          style: Constant.sectionSubHeadingStyle,
        ),
        SizedBox(
          height: 8.0,
        ),
        Text(
          "Explain your question in details\n\nIt's best to be clear, concise and to the point.",
          style: Constant.sectionSubHeadingDescriptionStyle,
        ),
        SizedBox(
          height: 64.0,
        ),
        TextFormField(
          autofocus: true,
          onTap: () {
            _scrollController.animateTo(200.0,
                duration: Constant.scrollAnimationDuration, curve: Curves.easeInOut);
          },
          onEditingComplete: () {
            widget.parentPageController
                .nextPage(duration: Constant.pageAnimationDuration, curve: Curves.easeInOut);
            FocusScope.of(context).unfocus();
          },
          onSaved: (d) {
            setState(() {
              widget.question.description = d;
            });
          },
          controller: _descriptionController,
          style: Constant.formFieldTextStyle,
          minLines: 20,
          maxLines: 25,
          validator: (value) => Constant.questionDescriptionValidator(value),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            border: null,
            focusedBorder: null,
            contentPadding: Constant.formFieldContentPadding,
            counterText: _descriptionController.text.length.toString(),
            hintText: "Describe the question in details...",
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
