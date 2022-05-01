import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api/firebase_take_file.dart';

class AddProduct extends StatefulWidget {
  @override
  const AddProduct(
    this.logList,

    //  required this.refreshFunction,
  );
  final Map logList;

  _AddProductState createState() => _AddProductState(logList);
}

class _AddProductState extends State<AddProduct> {
  // late File imageFile;
  bool imageFill = false;
  final picker = ImagePicker();
  List<File> imageFile = [];
  final Map logList;
  String city = "";

  _AddProductState(this.logList);
  chooseImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null)
      setState(() {
        validator = 0;
        imageFile.add(File(pickedFile.path));
        imageFill = true;
      });
  }

  Map<dynamic, dynamic> takeData() {
    var data = {};

    if (prixVente != null) data.addAll({"PRIX_VENTE": prixVente});
    data.addAll({"NBPHOTO": imageFile.length.toString()});

    data.addAll({"NOM": nomValue});

    data.addAll({"VENDU": "0"});

    return data;
  }

  Future<void> sendProduct() async {
    var client = http.Client();
    Map data = takeData();
    try {
      var url =
          "https://us-central1-flutter3-fe413.cloudfunctions.net/product-user/products";
      var response = await http.post(Uri.parse(url), body: data);
      var jsonList = json.decode(response.body);
      print(jsonList);
      // for (int i = 0; imageFile.length != i; i++) {
      //   print("dsqdsdsq");
      final destination = jsonList["idProd"] + "/0";
      FirebaseApi.uploadFile(destination, imageFile[0]);
      // }
    } finally {
      client.close();
      //Navigator.of(context).pop();
    }
  }

  String? nomValue;
  String? prixVente;
  int validator = 0;
  int checkValidator = 0;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            decoration: new BoxDecoration(color: Colors.white),
            padding: EdgeInsets.only(top: 10),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    child: imageFill != false
                        ? SizedBox(
                            height: 150,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: imageFile.length,
                              shrinkWrap: true,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(
                                  width: 15,
                                );
                              },
                              itemBuilder: (context, index) {
                                return Stack(
                                    alignment: Alignment.topRight,
                                    children: <Widget>[
                                      Container(
                                        height: 180,
                                        width: 180,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: FileImage(imageFile[index]),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 30,
                                        width: 30,
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: Colors.black38,
                                        ),
                                        child: IconButton(
                                          // splashColor: Colors.transparent,
                                          // highlightColor: Colors.transparent,
                                          padding: EdgeInsets.zero,
                                          icon: Icon(
                                            Icons.clear,
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              imageFile.removeAt(index);
                                              if (imageFile.length == 0) {
                                                imageFill = false;
                                                validator = 1;
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    ]);
                              },
                            ),
                          )
                        : Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/addPhoto.png"),
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                          ),
                  ),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FlatButton(
                            onPressed: () {
                              chooseImage(ImageSource.camera);
                            },
                            color: Colors.indigo[400],
                            child: Text(
                              "Camera",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FlatButton(
                            onPressed: () {
                              chooseImage(ImageSource.gallery);
                            },
                            color: Colors.indigo[400],
                            child: Text(
                              "Gallery*",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  validator == 1
                      ? Container(
                          // height: 100,
                          // width: 100,
                          child: Text(
                            "Veuillez choisir au moins une photo",
                            style:
                                TextStyle(fontSize: 12, color: Colors.red[700]),
                          ),
                        )
                      : Container(
                          // height: 100,
                          // width: 100,
                          child: Text(""),
                        ),
                  Container(
                    margin: const EdgeInsets.only(
                      left: 10.0,
                      top: 20,
                    ),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "1 - Informations",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: TextFormField(
                      onChanged: (text) {
                        nomValue = text;
                      },
                      validator: (value) {
                        if (value == null || value.length == 0) {
                          return 'Veuillez entrez un nom';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Nom du produit',
                        labelStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: TextFormField(
                      onChanged: (text) {
                        nomValue = text;
                      },
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Description',
                        labelStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: TextFormField(
                      onChanged: (text) {
                        prixVente = text;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrez un prix de vente';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Prix de vente (Ex: 10.00)',
                        labelStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  checkValidator == 1
                      ? Container(
                          // height: 100,
                          // width: 100,
                          child: Text(
                            "Veuillez remplir tous les champs obligatoire",
                            style:
                                TextStyle(fontSize: 12, color: Colors.red[700]),
                          ),
                        )
                      : Container(
                          // height: 100,
                          // width: 100,
                          ),
                  checkValidator == 1
                      ? SizedBox(
                          height: 20.0,
                        )
                      : Container(
                          // height: 100,
                          // width: 100,
                          ),
                  Container(
                    width: 300,
                    child: FlatButton(
                      onPressed: () {
                        setState(() {
                          if (imageFile.length == 0) validator = 1;
                        });
                        if (_formKey.currentState!.validate() &&
                            imageFile.length >= 1) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Envoi en cours...')),
                          );
                          sendProduct();
                        } else
                          checkValidator = 1;
                        // }
                        //chooseImage(ImageSource.gallery);
                      },
                      color: Colors.indigo[400],
                      child: Text(
                        "Ajouter",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Map<dynamic, dynamic> jsonList;
// final List<isWidget> _userWidget = [];

// Future<void> takeListWidget() async {
//   var client = http.Client();
//   try {
//     var url =
//         "https://us-central1-area-5269b.cloudfunctions.net/app/get_area_user";
//     var response = await http.post(url, body: {
//       'email': isEmail,
//     });
//     print('Response status: ${response.statusCode}');
//     jsonList = json.decode(response.body);
//     //print('Response body: ${response.body}');
//   } finally {
//     client.close();
//   }
// }
