import 'package:flutter/material.dart';
import '/Screens/Login/components/background.dart';
import '/Screens/Signup/signup_screen.dart';
import '/components/already_have_an_account_acheck.dart';
import '/components/rounded_button.dart';
import '/components/rounded_input_field.dart';
import '/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../login_screen.dart';
import 'package:http/http.dart' as http;
import '../../appMenu/menu.dart';
import 'dart:convert';

import '../../api/auth.dart';
import 'dart:convert';

class Body extends StatefulWidget {
  Body(this.newStatus);
  var newStatus;

  @override
  State<Body> createState() => _BodyState(newStatus);
}

class _BodyState extends State<Body> {
  var email;
  var password;
  var newStatus = 0;
  var saveStates;

  var lel;
  _BodyState(this.saveStates) {
    // newStatus = widget.newStatus;
  }
  @override
  final AuthenticationService _auth = AuthenticationService();
  Map jsonList = {};
  Future<void> takeCompte(String uid) async {
    var client = http.Client();
    try {
      var url =
          "https://us-central1-flutter3-fe413.cloudfunctions.net/compte-user/" +
              uid;

      var response = await http.get(
        Uri.parse(url),
      );
      String dataRole = "";
      setState(() {
        jsonList = json.decode(response.body);
      });
      dataRole = jsonList["role"];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return MenuBurger(dataRole, email);
          },
        ),
      );
    } finally {
      client.close();
    }
  }

  var errorMessage = "";
  var signStatus = 0;

  int fillForm = 0;

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: size.height * 0.16),
            SizedBox(
              width: 310,
              child: Container(
                child: Text(
                  "LOGIN",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ),
            ),
            RoundedInputField(
              hintText: "Your Email",
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            RoundedPasswordField(onChanged: (value) {
              setState(() {
                password = value;
              });
            }),
            if (signStatus == -1)
              Container(
                  child: Text(
                errorMessage,
                style: TextStyle(
                  color: Colors.red,
                ),
              )),
            RoundedButton(
              text: "LOG IN",
              press: () async {
                dynamic result =
                    await _auth.signInWithEmailAndPassword(email, password);

                if (result == null) {
                  // setState(() {
                  //   errorAuth = 1;
                  //   status = 0;
                  // });
                } else {
                  takeCompte(result.uid);
                }
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen(0, "");
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
