import 'package:flutter/material.dart';
import '../../Screens/Signup/components/body.dart';

class SignUpScreen extends StatelessWidget {
  var statusConnect;
  var errorMsg;

  SignUpScreen(this.statusConnect, this.errorMsg);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(statusConnect, errorMsg),
    );
  }
}
