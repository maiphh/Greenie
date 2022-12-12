import 'package:bitcointicker/phone.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'user.dart';

class MyVerify extends StatefulWidget {
  const MyVerify({Key? key}) : super(key: key);

  @override
  State<MyVerify> createState() => _MyVerifyState();
}

class _MyVerifyState extends State<MyVerify> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String sms = "";

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/assets/img1.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Phone Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Enter the Pin that is sent to your phone!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Pinput(
                onChanged: (value) {
                  sms = value;
                },
                length: 6,
                // defaultPinTheme: defaultPinTheme,
                // focusedPinTheme: focusedPinTheme,
                // submittedPinTheme: submittedPinTheme,

                showCursor: true,
                onCompleted: (pin) => print(pin),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      try {
                        PhoneAuthCredential credential =
                            PhoneAuthProvider.credential(
                                verificationId: MyPhone.verify, smsCode: sms);

                        // Sign the user in (or link) with the credential
                        await auth.signInWithCredential(credential);

                        final User? user = auth.currentUser;
                        final uid = user?.uid;
                        final usersRef = FirebaseFirestore.instance
                            .collection('userProfile')
                            .doc(uid);
                        dynamic inventoryID;
                        usersRef.get().then((docSnapshot) async => {
                              if (!docSnapshot.exists)
                                {
                                  await FirebaseFirestore.instance
                                      .collection("gameInventory")
                                      .add({'items': []}).then(
                                          (documentSnapshot) => inventoryID =
                                              documentSnapshot.id),
                                  await FirebaseFirestore.instance
                                      .collection('userProfile')
                                      .doc(uid)
                                      .set({
                                    'avatar':
                                        "https://www.plant-for-the-planet.org/wp-content/uploads/2022/06/team-hs-placeholder.jpg",
                                    'name': "User",
                                    'GP': 0,
                                    'usercode': uid,
                                    'inventoryID': inventoryID
                                  })
                                }
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
                                builder: (context) =>
                                    UserProfile(uid: uid.toString()),
                              ));
                        });
                      } on FirebaseAuthException catch (e) {
                        String title = "";
                        if (e.message!.contains(
                            'The sms verification code used to create the phone auth credential is invalid')) {
                          title = "Wrong Pin. Please try again!";
                        } else if (e.message!
                            .contains('The sms code has expired')) {
                          title = "Pin expired. Please try again!";
                        }
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Verification Error!"),
                            content: Text(title),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("OK"),
                              )
                            ],
                          ),
                        );
                      }
                    },
                    child: const Text("Verify Phone Number")),
              ),
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Edit Phone Number ?",
                        style: TextStyle(color: Colors.black),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
