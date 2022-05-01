// import 'package:fithompro/Screens/addProduct/addProduct.dart';
import 'package:flutter/material.dart';
import '../accueil/accueil.dart';
import '../profil/profil.dart';
import '../home_page/home_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../addProduct/addProduct.dart';

class MenuBurger extends StatefulWidget {
  const MenuBurger(
    this.role,
    this.mail,
  );
  final String role;
  final String mail;

  @override
  State<MenuBurger> createState() => _MenuBurgerState(role, mail);
}

class _MenuBurgerState extends State<MenuBurger> {
  int currentTab = 0;
  int _selectedIndex = 0;
  String role = "";
  String mail = "";

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text("Vous n'avez pas les droits !"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  dynamic jsonList = [];
  Future<void> takeListWidget() async {
    var client = http.Client();
    try {
      var url =
          "https://us-central1-flutter3-fe413.cloudfunctions.net/right-user/null";
      var response = await http.get(
        Uri.parse(url),
      );
      var jsonTmp = json.decode(response.body);

      setState(() {
        jsonList = jsonTmp;
        print("!!!!!");
        print(jsonList);
        print("!!!!!");

        print(role);

        print("!!!!!!");
        if (jsonList[0]["orderId"] == role)
          jsonList = jsonList[0];
        else if (jsonList[1]["orderId"] == role)
          jsonList = jsonList[1];
        else if (jsonList[2]["orderId"] == role) jsonList = jsonList[2];
      });
    } finally {
      client.close();
    }
  }

  _MenuBurgerState(this.role, this.mail) {
    //if (jsonList[""])
    takeListWidget();
    currentScreen = WelcomePage(
      role,
    );
  }
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = Container(); //

  int status = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.purple,
        onPressed: () {
          setState(() {
            if (jsonList["edit"] == "true")
              _showMyDialog();
            else {
              currentScreen = AddProduct(
                  {}); // if user taps on this dashboard tab will be active
              currentTab = 0;
            }
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (jsonList["edit"] == "true")
                    MaterialButton(
                      minWidth: 80,
                      onPressed: () {
                        setState(() {
                          currentScreen = WelcomePage(
                              role); // if user taps on this dashboard tab will be active
                          currentTab = 0;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.home,
                            color: currentTab == 0
                                ? Colors.deepPurple
                                : Colors.grey,
                          ),
                          Text(
                            'Home',
                            style: TextStyle(
                              color: currentTab == 0
                                  ? Colors.deepPurple
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (jsonList["shop"] == "true")
                    MaterialButton(
                      minWidth: 80,
                      onPressed: () {
                        setState(() {
                          currentScreen = Accueil(
                            role: role,
                            mail: mail,
                          ); // if user taps on this dashboard tab will be active
                          currentTab = 1;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.search,
                            color: currentTab == 1
                                ? Colors.deepPurple
                                : Colors.grey,
                          ),
                          Text(
                            'Search',
                            style: TextStyle(
                              color: currentTab == 1
                                  ? Colors.deepPurple
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                ],
              ),

              // Right Tab bar icons
              if (jsonList["deliver"] == "true")
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    MaterialButton(
                      minWidth: 110,
                      onPressed: () {
                        setState(() {
                          currentScreen = OrderPage(
                            role,
                          ); // if user aps on this dashboard tab will be active
                          currentTab = 3;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.shop,
                            color:
                                currentTab == 3 ? Colors.purple : Colors.grey,
                          ),
                          Text(
                            'Order',
                            style: TextStyle(
                              color:
                                  currentTab == 3 ? Colors.purple : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
