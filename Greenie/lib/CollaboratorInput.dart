import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void updateGP(int value, String uid) {
  final docUser = FirebaseFirestore.instance.collection("userProfile").doc(uid);

  docUser.update({'GP': FieldValue.increment(value)});
}

FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

FirebaseDatabase database = FirebaseDatabase.instance;
DatabaseReference ref = FirebaseDatabase.instance.ref("data");

class CollaboratorInput extends StatelessWidget {
  String? uid;
  CollaboratorInput({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Collaborator's input"),
      ),
      body: TextFormField(),
    );
  }
}
