import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api/firebase_take_file.dart';
import 'orderCard.dart';

class OrderPage extends StatefulWidget {
  const OrderPage(this.role);

  final String role;
  @override
  State<StatefulWidget> createState() {
    return _OrderPageState(role);
  }
}

class _OrderPageState extends State<OrderPage> {
  @override
  _OrderPageState(this.role) {
    takeListWidget();
  }
  final String role;

  List jsonList = [];
  Future<void> takeListWidget() async {
    var client = http.Client();
    try {
      var url =
          "https://us-central1-flutter3-fe413.cloudfunctions.net/order-user/null";
      var response = await http.get(
        Uri.parse(url),
      );
      var jsonTmp = json.decode(response.body);
      // print(jsonTmp);

      setState(() {
        jsonList = jsonTmp;
        print(jsonList);
      });
    } finally {
      client.close();
    }
  }

  void deleteElement(int index) {
    setState(() {
      jsonList.removeAt(index);
    });
  }

  late Future<List<FirebaseFile>> futureFiles;

  Widget build(BuildContext context) {
    return Column(
      key: Key(jsonList.toString()),
      crossAxisAlignment: CrossAxisAlignment.center,
      // mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 50.0,
        ),
        Container(
          margin: const EdgeInsets.only(top: 20.0),
        ),

        Container(
          // margin: const EdgeInsets.only(top: 190.0),
          alignment: Alignment.center,
          child: const Text(
            "Order",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 36),
          ),
        ),
        // Expanded(child: Container()),
        Flexible(
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
              ),
              itemCount: jsonList.length,
              itemBuilder: (BuildContext ctx, index) {
                return OrderCard(
                  data: jsonList[index],
                  index: index,
                  delete: deleteElement,
                );
              }
              // }),
              ),
        ),
      ],
    );
  }
}
