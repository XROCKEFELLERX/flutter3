// const admin = require("firebase-admin");
// admin.initializeApp();

const functions = require("firebase-functions");
const express = require("express");
const cors = require("cors");

const orderApp = express();

const {db} = require("../firebase_config");

orderApp.use(cors({origin: true}));

orderApp.get("/:id", async (req, res) => {
  try {  
    const snapshot = await db.collection("COMMANDES/").get();
    let users = [];
    snapshot.forEach((doc) => {
      let orderId = doc.id;

      let data = doc.data();

      users.push({orderId, ...data});
    });
    res.status(200).send(JSON.stringify(users));
  }
  catch {
    let errorMessage = error.message; 
    console.log(errorMessage);
    res.status(400).send(errorMessage);
  }
});


orderApp.put("/:id", async (req, res) => {
    const body = req.body;
    const idOrder = body.id;
  
    delete body.id;
   //body.delete(id);
    try {
      await db.collection("BOUTIQUE/" + req.params.id + "/COMMANDES/").doc(idOrder).update({
        ...body
      });
      res.status(200).send();
    }
    catch {
      let errorMessage = error.message; 
      console.log(errorMessage);
      res.status(400).send(errorMessage);
    }
  });

orderApp.delete("/:id", async (req, res) => {
  try {
    await db.collection("COMMANDES/").doc(req.params.id).delete();
    res.status(200).send();
  }
  catch {
    let errorMessage = error.message; 
    console.log(errorMessage);
    res.status(400).send(errorMessage);
  }
});

orderApp.post("/:id", async (req, res) => {
  const product = req.body;
  var prodId;
  //let prodJson = JSON.parse(req.body);
  try {
    await db.collection("COMMANDES/").add(product).then(function(docRef){
      prodId = docRef.id;
    });

   // await db.collection("PRODUITS/").doc(prodId).set(product);
    res.status(201).send({idProd: prodId});
  }
  catch {
    let errorMessage = error.message; 
    console.log(errorMessage);
    res.status(400).send(errorMessage);
  }
});

exports.user = functions.https.onRequest(orderApp);
