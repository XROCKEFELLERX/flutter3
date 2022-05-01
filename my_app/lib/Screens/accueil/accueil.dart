import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'cardProd.dart';
import 'dart:math';

class Accueil extends StatefulWidget {
  @override
  const Accueil({
    Key? key,
    required this.role,
    required this.mail,
  }) : super(key: key);
  final String role;
  final String mail;

  State<Accueil> createState() => _AccueilState(role, mail);
}

class _AccueilState extends State<Accueil> {
  @override
  _AccueilState(this.role, this.mail) {
    takeListWidget();
  }
  final String role;
  final String mail;

  dynamic jsonList = [];
  Future<void> takeListWidget() async {
    var client = http.Client();
    try {
      var url =
          "https://us-central1-flutter3-fe413.cloudfunctions.net/product-user/null";
      var response = await http.get(
        Uri.parse(url),
      );
      var jsonTmp = json.decode(response.body);

      setState(() {
        jsonList = jsonTmp;
        print(jsonList);
      });
    } finally {
      client.close();
    }
  }

  Future<void> sendOrder(String id, String mail) async {
    await takeTown();

    var data = {"idProd": id, "mail": mail, "city": city};
    var client = http.Client();
    try {
      var url =
          "https://us-central1-flutter3-fe413.cloudfunctions.net/order-user/products";
      var response = await http.post(Uri.parse(url), body: data);
    } finally {
      client.close();
      //Navigator.of(context).pop();
    }
  }

  String city = "";
  Future<void> takeTown() async {
    var client = http.Client();
    Random random = Random.secure();

    try {
      var url = "https://geo.api.gouv.fr/regions";
      var response = await http.get(
        Uri.parse(url),
      );
      var jsonTmp = json.decode(response.body);
      print(jsonTmp);
      int randomInt = random.nextInt(jsonTmp.length);

      setState(() {
        city = jsonTmp[randomInt]["nom"];
        //jsonList = jsonTmp;
        //print(jsonList);
      });
    } finally {
      client.close();
    }
  }

  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 10.0, top: 50),
          child: Text(
            "PRODUCTS",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Flexible(
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: jsonList.length,
              itemBuilder: (BuildContext ctx, index) {
                return Container(
                  margin: EdgeInsets.only(left: 15),
                  child: Stack(
                    children: [
                      ProductCard(
                        data: jsonList[index],
                        index: index,
                      ),
                      Container(
                        color: Colors.black,
                        child: IconButton(
                          color: Colors.white,
                          icon: const Icon(Icons.shopping_cart),
                          onPressed: () {
                            sendOrder(jsonList[index]["id"], mail);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ),
      ],
    );
  }
}
