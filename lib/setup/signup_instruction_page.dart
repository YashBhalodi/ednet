import 'package:flutter/material.dart';

//TODO Jaydeep &/ Janvi implement the "Sign Up Instruction" screen.
class SignUpInstruction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Sign Up Instructions")),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: InstructionBox(
                  name: " If you are a University Admin",
                  instruction:
                      "Kindly drop a mail at jsbhagiya@gmail.com from the registered email address of your university to get the login credentials",
                  image: "university.png"),
            ),
            Expanded(
              flex: 1,
              child: InstructionBox(
                  name: "If you are a Student/Professor",
                  instruction:
                      "Kindly ask your university admin to submit your details: ID and email address to us to get the login credentials",
                  image: "student.png"),
            ),
          ],
        ));
  }
}

class InstructionBox extends StatelessWidget {
  InstructionBox({Key key, this.name, this.instruction, this.image}) : super(key: key);
  final String name;
  final String instruction;
  final String image;

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      height: 120,
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Image.asset("assets/images/" + image),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      this.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      this.instruction,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
