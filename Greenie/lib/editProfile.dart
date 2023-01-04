import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'user.dart';

class EditProfile extends StatefulWidget {
  final String uid;
  final String name;
  const EditProfile({super.key, required this.uid, required this.name});

  @override
  // ignore: no_logic_in_create_state
  State<EditProfile> createState() => _EditProfileState(uid, name);
}

class _EditProfileState extends State<EditProfile> {
  String uid;
  String name;
  _EditProfileState(this.uid, this.name);

  File? image;
  String finalPath = "";
  Future uploadImage(String path) async {
    if (path == "") return;
    final imageTemp = File(path);
    final storageRef = FirebaseStorage.instance.ref();
    final avatarRef = storageRef.child(path);
    try {
      await avatarRef.putFile(
          imageTemp,
          SettableMetadata(
            contentType: "image/jpeg",
          ));
    } on Exception catch (e) {
      print("Something wrong");
    }
  }

  Future getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    // final fcmToken = await FirebaseMessaging.instance.getToken();
    // print(fcmToken);
    if (image == null) {
      print("no image");
      return;
    }
    ;
    final path = image.path;
    finalPath = path;
    // final imageTemp = File(image.path);
    // this.image = imageTemp;

    // final storageRef = FirebaseStorage.instance.ref();
    // final avatarRef = storageRef.child(path);
    // try {
    //   await avatarRef.putFile(imageTemp, SettableMetadata(
    //     contentType: "image/jpeg",
    //   ));
    // }
    // on Exception catch (e) {
    //   print("Something wrong");
    // }
  }

  @override
  Widget build(BuildContext context) {
    String username = "";
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 30,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Edit your profile",
                  style: TextStyle(
                      decoration: TextDecoration.none,
                      fontFamily: 'WorkSans',
                      fontSize: 32,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 60,
                ),
                TextField(
                  onChanged: (value) {
                    username = value;
                  },
                  decoration: const InputDecoration(
                    label: Text("Username"),
                    enabledBorder: OutlineInputBorder(),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    getImage();
                  },
                  child: const Text("Upload image"),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: () {
                        final usersRef = FirebaseFirestore.instance
                            .collection('userProfile')
                            .doc(uid);
                        uploadImage(finalPath);
                        if (finalPath == "")
                          finalPath = "https://i.stack.imgur.com/l60Hf.png";
                        if (username == "") username = name;
                        usersRef.get().then((docSnapshot) async => {
                              await usersRef.update(
                                  {'name': username, 'avatar': finalPath})
                            });
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        );
                        // ignore: use_build_context_synchronously
                        Future.delayed(const Duration(milliseconds: 1000), () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserProfile(uid: uid),
                              ));
                        });
                      },
                      child: const Text(
                        "Update",
                        style: TextStyle(fontSize: 20),
                      )),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
