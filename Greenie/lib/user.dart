import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'editProfile.dart';
import 'phone.dart';

class UserProfile extends StatefulWidget {
  final String uid;

  const UserProfile({super.key, required this.uid});

  @override
  // ignore: no_logic_in_create_state
  State<UserProfile> createState() => _UserProfileState(uid);
}

class _UserProfileState extends State<UserProfile> {
  // @override
  // void initState() async {
  //   // TODO: implement initState
  //   fcmToken = await FirebaseMessaging.instance.getToken();
  //   print(fcmToken);
  //   FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
  //     // wait for changes
  //   })
  //   .onError((err) => {
  //     print("Something is wrong")
  //   });
  // }
  String uid;

  _UserProfileState(this.uid);

  late dynamic data;
  late dynamic fcmToken;
  dynamic voucherList = [];

  Future getData() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    dynamic vouchers = [];
    final CollectionReference voucherRef = db.collection("voucher");
    await voucherRef
        .where('user', isEqualTo: uid)
        .get()
        .then((QuerySnapshot query) {
      query.docs.forEach((doc) {
        vouchers.add(doc.data());
      });
    });
    voucherList = vouchers;
    print(voucherList);
    final docRef = db.collection("userProfile").doc(uid);
    await docRef.get().then(
      (DocumentSnapshot doc) {
        data = doc.data() as Map<String, dynamic>;
      },
      onError: (e) => print("Error getting document: $e"),
    );
    // get image link
    // check if link is default image
    if (data['avatar'].contains("https://")) return;
    // if not then convert image ref to image url
    final storageRef = FirebaseStorage.instance.ref();
    final ref = await storageRef.child(data['avatar']);
    await ref.putFile(File(data['avatar']));
    final url = await ref.getDownloadURL();
    data['avatar'] = url;
    // Get notification token data["registrationKey"]
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut().then(
          (value) => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const MyPhone(),
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.green.shade900, Colors.green.shade400],
                begin: Alignment.topRight,
                end: Alignment.centerLeft),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 73),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [],
                  ),
                  SizedBox(
                    height: height * 0.43,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double innerHeight = constraints.maxHeight;
                        double innerWidth = constraints.maxWidth;
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: innerHeight * 0.72,
                                width: innerWidth,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 80,
                                    ),
                                    FutureBuilder(
                                        future: getData(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            return Text(
                                              data['name'],
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'Worksans',
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold),
                                            );
                                          }
                                          return const Text("loading...");
                                        }),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 45),
                                      child: Text(
                                        "A little effort towards saving the environment is better than no effort.",
                                        style: TextStyle(),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 80.0, vertical: 10),
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.0)),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditProfile(uid: uid),
                                            ));
                                      },
                                      child: const Text(
                                        'Edit Profile',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 110,
                              right: 20,
                              child: Container(),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(90.0),
                                  child: FutureBuilder(
                                      future: getData(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          // return CircleAvatar(
                                          //   radius: 10,
                                          //   child: ClipOval(
                                          //     child: Image.network(
                                          //       data['avatar']
                                          //     ),
                                          //   )
                                          // );
                                          return ClipOval(
                                            child: SizedBox.fromSize(
                                              size:
                                                  Size.fromRadius(height * 0.1),
                                              child: Image.network(
                                                  data['avatar'],
                                                  width: innerWidth * 0.4,
                                                  height: innerHeight * 0.4,
                                                  fit: BoxFit.cover),
                                            ),
                                          );
                                        }
                                        return const Text("loading");
                                      }),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: height * 0.5,
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'My Collection',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 27,
                              fontFamily: 'Worksans',
                            ),
                          ),
                          const Divider(
                            thickness: 2.5,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: height * 0.15,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: height * 0.15,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () {
                          logout();
                        },
                        child: const Text(
                          "Log out",
                          style: TextStyle(fontSize: 20),
                        )),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
