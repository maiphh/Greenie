import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'user.dart';

class EditProfile extends StatefulWidget {
  final String uid;
  const EditProfile({super.key, required this.uid});

  @override
  // ignore: no_logic_in_create_state
  State<EditProfile> createState() => _EditProfileState(uid);
}

class _EditProfileState extends State<EditProfile> {
  String uid;
  _EditProfileState(this.uid);

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

                        usersRef.get().then((docSnapshot) async => {
                              await usersRef.update({
                                'name': username,
                              })
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
