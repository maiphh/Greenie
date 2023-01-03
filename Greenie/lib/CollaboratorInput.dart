import 'package:bitcointicker/qrScanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void updateGP(int value, String? uid) {
  final docUser = FirebaseFirestore.instance.collection("userProfile").doc(uid);

  docUser.update({'GP': FieldValue.increment(value)});
}

FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

FirebaseDatabase database = FirebaseDatabase.instance;

Future<String?> getToken() async {
  // Getting the token makes everything work as expected
  // await firebaseMessaging.getToken().then((String? token) {
  //   print(token);
  //   return token;
  // });
  final token = await firebaseMessaging.getToken();
  return token;
}

Future<dynamic> realData(int GP, String? uid, String? token) async {
  DatabaseReference ref = FirebaseDatabase.instance.ref("");
  final snapshot = await ref.get();
  // final token = await getToken();

  // if (!snapshot.exists) {
  //   print("Hello");
  // }
  // print("Hello world");
  // print(snapshot.value);
  await ref.push().set({
    "key": token,
    "uid": uid,
    "GP": GP,
  });
  return snapshot;
}

Future updateRealtimeDatabase(int GP, String? uid, String? token) async {
  // DatabaseReference ref = FirebaseDatabase.instance.ref("data");
  // await ref.set({
  //   {"GP": 10, "key": "bla", "uID": ""}
  // });
  return realData(GP, uid, token);
}

class CollaboratorInput extends StatelessWidget {
  String? uid;
  CollaboratorInput({super.key, required this.uid});
  final _formKey = GlobalKey<FormState>();
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QRScanPage(),
                ));
          },
        ),
        backgroundColor: Colors.green,
        title: Text("Collaborator's input"),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 250,
                  child: TextFormField(
                    decoration:
                        InputDecoration(hintText: "Enter the amount of GP"),
                    controller: controller,
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }

                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        final data = uid!.split("|");
                        String token = data[0];
                        String id = data[1];
                        updateGP(int.parse(controller.text), id);
                        await updateRealtimeDatabase(
                            int.parse(controller.text), id, token);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text("Adding ${controller.text}GP...")),
                        );
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
