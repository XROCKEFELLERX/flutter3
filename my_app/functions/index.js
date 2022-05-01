const functions = require("firebase-functions");
const compte = require('./controllers/compte');
const product = require('./controllers/productManage');
const order = require('./controllers/order');
const right = require('./controllers/right');

module.exports = {
    compte,
    product,
    order,
    right,
  };
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
