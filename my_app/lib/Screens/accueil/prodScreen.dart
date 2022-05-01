import 'dart:developer';

import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../components/rounded_button.dart';
import '../../../components/roll_button.dart';
import '/components/rounded_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'cardProd.dart';
import 'package:flutter_cube/flutter_cube.dart';

class ProdScreen extends StatefulWidget {
  @override
  const ProdScreen({
    Key? key,
    required this.index,
    required this.productName,
  }) : super(key: key);
  final int index;
  final String productName;

  State<ProdScreen> createState() => _ProdScreenState(index);
}

class _ProdScreenState extends State<ProdScreen> {
  final int index;
  @override
  _ProdScreenState(this.index) {}

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Votre produit"),
        backgroundColor: Colors.black,
        leading: BackButton(
            onPressed: () => {
                  Navigator.pop(context, false),
                  //    refreshFunction(),
                }),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                //  height: ,
                margin: EdgeInsets.only(top: 30),

                child: Text(
                  widget.productName,
                  style: TextStyle(
                    color: Colors.black,
                    decoration: TextDecoration.none,
                    decorationColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
