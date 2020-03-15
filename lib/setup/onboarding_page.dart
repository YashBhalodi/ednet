import 'package:ednet/setup/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Onboarding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Center(
              child: Text("Onboarding Widget"),
          ),
      ),
        floatingActionButton: FloatingActionButton(
            onPressed: () async{
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.setBool("welcome", true);
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context){
                        return LoginPage();
                    }
                ),);
            },
        ),
    );
  }
}
