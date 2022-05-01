// const admin = require("firebase-admin");
// admin.initializeApp();

const functions = require("firebase-functions");
const express = require("express");
const cors = require("cors");

const right = express();

const {db} = require("../firebase_config");

right.use(cors({origin: true}));


right.put("/:id", async (req, res) => {
  const body = req.body;
  const idOrder = body.id;

  delete body.id;
 //body.delete(id);
  try {
    await db.collection("GROUP/").doc(idOrder).update({
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


right.get("/:id", async (req, res) => {
  try {  
    const snapshot = await db.collection("GROUP/").get();
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

exports.user = functions.https.onRequest(right);
