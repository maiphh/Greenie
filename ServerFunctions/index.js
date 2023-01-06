const express = require('express');
const app = express();
var admin = require("firebase-admin");
var { getFirestore, Query } = require("firebase-admin/firestore");
// const { isEqual } = require('lodash');
// var {  } = require("firebase-admin");

var serviceAccount = require("./greenieverse-secret.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://greenieverse-default-rtdb.asia-southeast1.firebasedatabase.app"
});
// const db = admin.database();
const db = getFirestore();

const updateData = async (uid, gp) => {
    // considering send err to the collaborator
    let userRef
    try {
      userRef = await db.collection('userProfile').doc(uid);

    }
    catch (err) {
      console.log(err);
    }
    const doc = await userRef.get();
    const current = doc.data()['GP'];
    const res = await userRef.update({GP: current + gp});
    console.log("Update successfully");

}
// Notify if data has changed
const fire_db = admin.database();
var ref = fire_db.ref("/")

ref.on("child_added", (snapshot, preChildKey) => {
  if (snapshot.val().key == "value") {
    return;
  }
  // Retrieve data
  const val = snapshot.val();
  const key = val.key;
  const gp = val.GP;
  const uid = val.uid;


  // update database
  // updateData(uid, gp);
  

  // send notification
  const message = {
    notification: {
      title: "Rewards",
  
      body: `You have received ${gp}`,
    },
  
    android: {
      notification: {    
        channel_id: "123",
        priority: "high"
      }
    },
    token: key
  }
  admin.messaging().send(message).then((response) => {
    console.log("Message sent successfully");
  
  
  }).catch((err) => {
  
    console.log("Can't send message");
  })
  
  

})


