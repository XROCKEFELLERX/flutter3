import 'package:flutter/material.dart';
import '/Screens/Login/login_screen.dart';
import '/Screens/Signup/components/background.dart';
import '/Screens/Signup/components/or_divider.dart';
import '/Screens/Signup/components/social_icon.dart';
import '/components/already_have_an_account_acheck.dart';
import '/components/rounded_button.dart';
import '/components/rounded_input_field.dart';
import '/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import '../../appMenu/menu.dart';
import '../../api/auth.dart';
import 'dart:convert';

import '../signup_screen.dart';

class Body extends StatefulWidget {
  var newStatus;
  var errorMsg;
  @override
  Body(this.newStatus, this.errorMsg);

  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final AuthenticationService _auth = AuthenticationService();

  @override
  var mail = "";
  var mdp = "";
  var role = "";
  int status = 0;
  Future<dynamic> addUser() async {
    var client = http.Client();

    try {
      dynamic result = await _auth.registerWithEmailAndPassword(
        mail,
        mdp,
        "customer",
      );

      if (result.toString().contains("The email address is badly formatted")) {
        return;
      } else if (result.toString().contains(
          "The email address is already in use by another account.")) {
        return;
      }

      if (result == null || result.toString().contains("[firebase_auth/")) {
        return;
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return MenuBurger(role, mail);
            },
          ),
        );
      }
      return result;
    } finally {
      client.close();
      return null;
    }
  }

  Widget build(BuildContext context) {
    int statusLog = 0;

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
                  "SIGNUP",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              hintText: "Your Email",
              onChanged: (value) {
                setState(() {
                  mail = value;
                  print(mail);
                });
              },
            ),
            RoundedPasswordField(
              onChanged: (value) {
                setState(() {
                  mdp = value;
                  print(mdp);
                });
              },
            ),
            RoundedButton(
              text: "SIGNUP",
              press: () async {
                //sendAccount();
                addUser();
                // var data = {
                //   "MDP": mdp,
                //   "MAIL": mail,
                //   "NAME": name,
                //   "FIRSTNAME": firstname,
                //   "BOUTIQUE": boutique,
                // };

                if (statusLog == 1) {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) {
                  //     //   return MenuBurger(data);
                  //   }),
                  // );
                }
                // await login();
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) {
                //       if (newStatus == 1) {
                //         return LoginScreen(0);
                //       } else
                //         return SignUpScreen(
                //           -1,
                //           newError,
                //         );
                //     },
                //   ),
                // );
              },
            ),
            SizedBox(height: size.height * 0.01),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen(0);
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
