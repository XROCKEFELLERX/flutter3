import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WelcomePage extends StatefulWidget {
  const WelcomePage(this.role);

  final String role;
  @override
  State<StatefulWidget> createState() {
    return _WelcomePageState(role);
  }
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  _WelcomePageState(this.role) {
    takeListWidget();
    takeListRole();
  }
  final String role;

  dynamic userList = [];
  dynamic roleList = [];

  Future<void> takeListRole() async {
    var client = http.Client();
    try {
      var url =
          "https://us-central1-flutter3-fe413.cloudfunctions.net/right-user/null";
      var response = await http.get(
        Uri.parse(url),
      );
      var jsonTmp = json.decode(response.body);
      // print(jsonTmp);
      print(jsonTmp);
      setState(() {
        roleList = jsonTmp;
        print("----");
        print(roleList);
        print("----");
      });
    } finally {
      client.close();
    }
  }

  Future<void> takeListWidget() async {
    var client = http.Client();
    try {
      var url =
          "https://us-central1-flutter3-fe413.cloudfunctions.net/compte-user/null";
      var response = await http.get(
        Uri.parse(url),
      );
      var jsonTmp = json.decode(response.body);
      // print(jsonTmp);

      setState(() {
        userList = jsonTmp;
      });
    } finally {
      client.close();
    }
  }

  Future<void> setRole(int index) async {
    var client = http.Client();

    try {
      var url =
          "https://us-central1-flutter3-fe413.cloudfunctions.net/compte-user/" +
              userList[index];
      var response = await http.put(Uri.parse(url));
    } finally {
      client.close();
    }
  }

  Future<void> setRight(int index) async {
    var client = http.Client();

    var data = {
      "id": roleList[index]["orderId"],
      "edit": editRight[index].toString(),
      "shop": shopRight[index].toString(),
      "deliver": deliverRight[index].toString()
    };
    try {
      var url =
          "https://us-central1-flutter3-fe413.cloudfunctions.net/right-user/" +
              "right";
      var response = await http.put(Uri.parse(url), body: data);
    } finally {
      client.close();
    }
  }

  bool deliver = false;
  bool customer = false;
  bool admin = false;

  List deliverRight = [];
  List editRight = [];
  List shopRight = [];

  Widget build(BuildContext context) {
    return Column(
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
          margin: const EdgeInsets.only(bottom: 30.0),
          alignment: Alignment.center,
          child: const Text(
            "Users",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
        ),
        // Expanded(child: Container()),
        Flexible(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: userList.length,
            itemBuilder: (BuildContext ctx, index) {
              if (userList[index]["role"] == "customer")
                customer = true;
              else if (userList[index]["role"] == "admin")
                admin = true;
              else
                deliver = true;
              return Card(
                elevation: 3,
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        child: Text(
                          userList[index]["mail"],
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Text("Admin"),
                          ),
                          Switch(
                            value: admin,
                            onChanged: (value) {
                              setState(() {
                                admin = value;
                                deliver = false;
                                customer = false; //    isSwitched = value;
                              });
                              setRole(index);
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Text("Customers"),
                          ),
                          Switch(
                            value: customer,
                            onChanged: (value) {
                              setState(() {
                                customer = value;
                                deliver = false;
                                admin = false;
                                //    isSwitched = value;
                              });
                              setRole(index);
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Text("Delivrer"),
                          ),
                          Switch(
                            value: deliver,
                            onChanged: (value) {
                              setState(() {
                                deliver = value;
                                customer = false;
                                admin = false;
                                //    isSwitched = value;
                              });
                              setRole(index);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Container(
          margin: EdgeInsets.only(bottom: 15),
          child: Text(
            "Rights: ",
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
        ),
        Flexible(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: roleList.length,
            itemBuilder: (BuildContext ctx, index) {
              if (roleList[index]["shop"] == "true")
                shopRight.add(true);
              else
                shopRight.add(false);

              if (roleList[index]["deliver"] == "true")
                deliverRight.add(true);
              else
                deliverRight.add(false);
              if (roleList[index]["edit"] == "true")
                editRight.add(true);
              else
                editRight.add(false);
              print(editRight);
              print(roleList.length);
              return Card(
                elevation: 3,
                child: Column(
                  children: [
                    Container(
                      child: Text(
                        roleList[index]["orderId"],
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text("Edit"),
                        ),
                        Switch(
                          value: editRight[index],
                          onChanged: (value) {
                            setState(() {
                              editRight[index] = value;
                            });
                            setRight(index);
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text("Shop"),
                        ),
                        Switch(
                          value: shopRight[index],
                          onChanged: (value) {
                            setState(() {
                              shopRight[index] = value;
                            });
                            setRight(index);
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text("Deliver"),
                        ),
                        Switch(
                          value: deliverRight[index],
                          onChanged: (value) {
                            setState(() {
                              deliverRight[index] = value;
                            });
                            setRight(index);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          //   return ProductCard(
          //     data: roleList[index],
          //     index: index,
          //   );
          // }),
        ),
      ],
    );
  }
}
