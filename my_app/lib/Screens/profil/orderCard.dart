import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../constants.dart';
import '../api/firebase_take_file.dart';
import 'dart:convert';
import 'dart:math';

class OrderCard extends StatefulWidget {
  const OrderCard({
    Key? key,
    required this.data,
    required this.index,
    required this.delete,
  }) : super(key: key);
  final Map<Object, dynamic> data;
  final int index;
  final Function delete;

  @override
  _OrderCardState createState() => _OrderCardState(
        data,
        index,
        delete,
      );
}

class _OrderCardState extends State<OrderCard> {
  late Map<Object, dynamic> data;
  int index;
  final Function delete;

  _OrderCardState(this.data, this.index, this.delete) {
    // print(data);
  }

  int saveIndex = 0;
  Future<void> takePhoto() async {
    // print(data["id"]);
    setState(() {
      futureFiles = FirebaseApi.listAll(data["idProd"] + "/");
    });
  }

  void initState() {
    print("-----");
    print(data);
    print("-----");

    super.initState();
    takePhoto();
  }

  String city = "";

  late Future<List<FirebaseFile>> futureFiles;

  String parseCat(List<dynamic> catData) {
    String res = "";
    for (int i = 0; i != catData.length; i++) {
      res = res + catData[i] + "/";
    }
    res = res.substring(0, res.length - 1);
    return res;
  }

  Future<void> deleteOrder() async {
    var client = http.Client();

    try {
      var url =
          "https://us-central1-flutter3-fe413.cloudfunctions.net/order-user/" +
              data["orderId"];
      var response = await http.delete(Uri.parse(url));
      print(response.body);
      delete(index);
    } finally {
      client.close();
      //  Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder<List<FirebaseFile>>(
      future: futureFiles,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError) {
              return Center(child: Text('Some error occurred!'));
            } else {
              final files = snapshot.data!;

              return Card(
                elevation: 7,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 150.0,
                      width: 150.0,
                      padding: EdgeInsets.all(4),
                      child: Image.network(files[0].url),
                    ),
                    Row(
                      children: [
                        Container(
                          //alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 20),
                          child: Text("Deliver to: "), //data["NOM"]),
                        ),
                        Container(
                          //alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 20),
                          child: Text(data["mail"] +
                              " à " +
                              data["city"]), //data["NOM"]),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          //alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 20),
                          child: Text("order id: "), //data["NOM"]),
                        ),
                        Container(
                          //alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 20),
                          child: Text(data["orderId"]), //data["NOM"]),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 40),
                      height: 65,
                      width: 180,
                      color: Colors.green,
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            deleteOrder();
                          }, // Handle your callback
                          child: Text(
                            "Deliver",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
        }
      },
    );
  }
}
