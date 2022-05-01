// const admin = require("firebase-admin");
// admin.initializeApp();

const functions = require("firebase-functions");
const express = require("express");
const cors = require("cors");

const productApp = express();

const {db} = require("../firebase_config");

productApp.use(cors({origin: true}));

productApp.get("/:id", async (req, res) => {
  try {  
    const snapshot = await db.collection("PRODUCTS/").get();
    let users = [];
    snapshot.forEach((doc) => {
      let id = doc.id;
      let data = doc.data();

      users.push({id, ...data});
    });
    res.status(200).send(JSON.stringify(users));
  }
  catch {
    let errorMessage = error.message; 
    console.log(errorMessage);
    res.status(400).send(errorMessage);
  }
});


productApp.delete("/:id", async (req, res) => {
  try {
    await db.collection("BOUTIQUE/" + req.params.id + "/PRODUITS").doc(req.body.id).delete();
    res.status(200).send();
  }
  catch {
    let errorMessage = error.message; 
    console.log(errorMessage);
    res.status(400).send(errorMessage);
  }
});

productApp.post("/:id", async (req, res) => {
  const product = req.body;
  var prodId;
  //let prodJson = JSON.parse(req.body);
  try {
    await db.collection("PRODUCTS/").add(product).then(function(docRef){
      prodId = docRef.id;
    });

    res.status(201).send({idProd: prodId});
  }
  catch {
    let errorMessage = error.message; 
    console.log(errorMessage);
    res.status(400).send(errorMessage);
  }
});

exports.user = functions.https.onRequest(productApp);
