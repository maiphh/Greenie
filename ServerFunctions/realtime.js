const express = require("express");
const server = express();
const { initializeApp } = require("firebase/app")


const { getFirestore, collection, getDocs, doc, updateDoc, getDoc } = require("firebase/firestore/lite");
const firebaseConfig = {
    "apiKey": "AIzaSyByCjwHACHa4tcjCI8SIGXaNPyS2SN27so",
    "authDomain": "greenieverse.firebaseapp.com",
    "databaseURL": "https://greenieverse-default-rtdb.asia-southeast1.firebasedatabase.app",
    "projectId": "greenieverse",
    "storageBucket": "greenieverse.appspot.com",
    "messagingSenderId": "789378223490",
    "appId": "1:789378223490:web:81ed252d6467674559d39b",
    "measurementId": "G-WQK7WMR4WE"
  }
const app = initializeApp(firebaseConfig);
const db = getFirestore(app);
// get id     

// Refernce data 
const tree = {
  'common': 5,
  'rare': 10,
  'epic': 20,
  'legendary': 50,
  'mythical': 100
}

const totalGP = async (invetoryID) => {
  const docRef = doc(db, `gameInventory/${invetoryID}`);
  const snapshot = await getDoc(docRef);
  const trees = snapshot.data()["items"];

  if (trees.length == 0) {
    return 0;
  }
  sum = 0;
  trees.forEach((item) => {
    sum += tree[item];
  })
  return sum;
}
const updateAllGP = async () => {
  
  // Get all docs
  const user = collection(db, "userProfile");
  const snapshot = await getDocs(user);
  const list = snapshot.docs.map((doc) => doc.id);
  list.forEach((item) => {
    updateGP(item);
  })
}

const updateGP = async (uid) => {
  const docRef = doc(db, `userProfile/${uid}`);
  const docSnap = await getDoc(docRef);
  const currentGP = docSnap.data()['GP'];
  const inventory = docSnap.data()['inventoryID'];
  if (!inventory) return;
  const increase = await totalGP(inventory);
  await updateDoc(docRef, "GP", currentGP + increase);
}

const time = 60000;
setInterval(async () => {
  await updateAllGP();
}, time)

// Open app for retaining runtime
server.get(
  '/',
  (req, res) => {
    res.send("Hello world");
  }
)

const port = 3000;
server.listen(3000, () => {
  console.log("Server is listening");
})

// Replit link: https://replit.com/@minhnguyen286/FreeRealTime#index.js