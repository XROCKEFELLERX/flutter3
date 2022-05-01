// const admin = require("firebase-admin");
// admin.initializeApp();

const functions = require("firebase-functions");
const express = require("express");
const cors = require("cors");

const compte = express();

const {db} = require("../firebase_config");

compte.use(cors({origin: true}));


compte.put("/:id", async (req, res) => {
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

compte.get("/:id", async (req, res) => {
  try {
    if (req.params.id == "null")
    {
      const snapshot = await db.collection("users/").get();
      let users = [];
      snapshot.forEach((doc) => {
        let id = doc.id;
        let data = doc.data();
  
        users.push({id, ...data});
      });
    res.status(200).send(JSON.stringify(users));

    }
    else
    {
      const snapshot =  db.collection("users/").doc(req.params.id);
      const doc = await snapshot.get();
       res.status(200).send(JSON.stringify(doc.data()));

    }
  }
  catch {
    let errorMessage = error.message; 
    console.log(errorMessage);
    res.status(400).send(errorMessage);
  }
});


exports.user = functions.https.onRequest(compte);
