// import 'package:bitcointicker/mystery.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:google_sign_in/google_sign_in.dart';
import 'user.dart';
import 'qr.dart';
import 'mystery.dart';
import 'home.dart';

class MyPhone extends StatefulWidget {
  const MyPhone({Key? key}) : super(key: key);
  static String verify = "";

  @override
  State<MyPhone> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<MyPhone> {
  TextEditingController countryController = TextEditingController();
  bool login = false;
  void _loginwithfacebook() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    setState(() {
      login = true;
    });
    try {
      final facebookLoginResult = await FacebookAuth.instance.login();
      final userData = await FacebookAuth.instance.getUserData();

      final facebookAuthCredential = FacebookAuthProvider.credential(
          facebookLoginResult.accessToken!.token);
      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
      final User? user = auth.currentUser;
      final uid = user?.uid;

      // get firebase messaging token
      final token = await FirebaseMessaging.instance.getToken();

      final usersRef =
          FirebaseFirestore.instance.collection('userProfile').doc(uid);
      dynamic inventoryID;
      usersRef.get().then((docSnapshot) async => {
            if (!docSnapshot.exists)
              {
                await FirebaseFirestore.instance
                    .collection("gameInventory")
                    .add({'items': []}).then((documentSnapshot) =>
                        inventoryID = documentSnapshot.id),
                await usersRef.set({
                  'email': userData['email'],
                  'avatar': userData['picture']['data']['url'],
                  'name': userData['name'],
                  'GP': 0,
                  'usercode': uid,
                  'inventoryID': inventoryID,
                  'registrationKey': token
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
              builder: (context) => Homepage(uid: uid.toString()),
            ));
      });
    } on FirebaseAuthException catch (e) {
      String title = "";
      switch (e.code) {
        case 'account-exists-with-different-credential':
          title = 'This account exist with a different sign in provider!';
          break;
        case 'invalid-credential':
          title = "Unknown error has occurred";
          break;
      }
      print(title);
    } finally {
      setState(() {
        login = false;
      });
    }
  }

  void _loginwithgoogle() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    setState(() {
      login = true;
    });
    final googleSignin = GoogleSignIn(scopes: ['email']);
    try {
      final googleSignInAccount = await googleSignin.signIn();

      // ignore: unnecessary_null_comparison
      if (googleSignInAccount == null) {
        setState(() {
          login = false;
        });
        return;
      }
      final googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);

      await FirebaseAuth.instance.signInWithCredential(credential);

      final User? user = auth.currentUser;
      final uid = user?.uid;

      final usersRef =
          FirebaseFirestore.instance.collection('userProfile').doc(uid);
      dynamic inventoryID;
      usersRef.get().then((docSnapshot) async => {
            if (!docSnapshot.exists)
              {
                await FirebaseFirestore.instance
                    .collection("gameInventory")
                    .add({'items': []}).then((documentSnapshot) =>
                        inventoryID = documentSnapshot.id),
                usersRef.set({
                  'email': googleSignInAccount.email,
                  'avatar': googleSignInAccount.photoUrl,
                  'name': googleSignInAccount.displayName,
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
              builder: (context) => Homepage(uid: uid.toString()),
            ));
      });
    } on FirebaseAuthException catch (e) {
      String title = "";
      switch (e.code) {
        case 'account-exists-with-different-credential':
          title = 'This account exist with a different sign in provider!';
          break;
        case 'invalid-credential':
          title = "Unknown error has occurred";
          break;
      }
      print(title);
    }
  }

  void _loginwithphone(phone) async {
    setState(() {
      login = true;
    });

    try {
      showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: countryController.text + phone,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? resendToken) {
          MyPhone.verify = verificationId;
          Navigator.pushNamed(context, 'pin');
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      String title = "";
      switch (e.code) {
        case 'account-exists-with-different-credential':
          title = 'This account exist with a different sign in provider!';
          break;
        case 'invalid-credential':
          title = "Unknown error has occurred";
          break;
        case 'invalid-verification-code':
          title = "The verification code of the credential is not valid";
          break;
        case 'invalid-verification-id':
          title = "The verification id of the credential is not valid.id";
          break;
      }
      print(title);
    } finally {
      setState(() {
        login = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    countryController.text = "+84";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const IconData facebook = IconData(0xe255, fontFamily: 'MaterialIcons');
    String phone = "";
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
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
                "Please register before saving the planet!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 40,
                      child: TextField(
                        controller: countryController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const Text(
                      "|",
                      style: TextStyle(fontSize: 33, color: Colors.grey),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: TextField(
                      onChanged: (value) {
                        phone = value;
                      },
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Phone",
                      ),
                    ))
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // const SizedBox(
              //       height: 20,
              //     ),

              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      _loginwithphone(phone);
                    },
                    child: const Text("Send the code")),
              ),
              const SizedBox(height: 20),

              Row(children: const <Widget>[
                Expanded(
                  child: Divider(
                    thickness: 1,
                  ),
                ),
                SizedBox(width: 20),
                Text("or"),
                SizedBox(width: 20),
                Expanded(
                  child: Divider(
                    thickness: 1,
                  ),
                ),
              ]),
              const SizedBox(height: 20),
              // SizedBox(
              //   width: double.infinity,
              //   height: 45,
              //   child: ElevatedButton.icon(
              //       icon: const Icon(facebook),
              //       style: ElevatedButton.styleFrom(
              //           backgroundColor: const Color(0xFF1778F2),
              //           shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(10))),
              //       onPressed: () async {
              //         _loginwithfacebook();
              //       },
              //       label: const Text("Continue with Facebook")),
              // ),
              // const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () async {
                    _loginwithgoogle();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Image(
                        width: 30,
                        height: 30,
                        image:
                            AssetImage('lib/assets/Google_Icons-09-512.webp'),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text("Continue with Google"),
                      SizedBox(width: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
