import 'package:bitcointicker/user.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'home.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

Future<String?> getToken() async {
  final token = await firebaseMessaging.getToken();
  return token;
}

Future<String?> combineData(String uid) async {
  final token = await getToken();
  final id = uid;
  return "${token!}|$id";
}

class Qr extends StatefulWidget {
  final String uid;
  const Qr({super.key, required this.uid});

  @override
  // ignore: no_logic_in_create_state
  State<Qr> createState() => _QrState(uid);
}

class _QrState extends State<Qr> {
  String uid;
  _QrState(this.uid);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return FutureBuilder(
        future: combineData(uid),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          String result = snapshot.data.toString();
          return Scaffold(
            bottomNavigationBar: BottomNavBar(
              uid: widget.uid,
              currentIndex: 1,
            ),
            body: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.green.shade900, Colors.green.shade400],
                        begin: Alignment.topRight,
                        end: Alignment.centerLeft),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: height * 0.75,
                            child: const Image(
                              image: AssetImage("lib/assets/Qr holder.png"),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UserProfile(uid: widget.uid),
                                  ));
                            },
                            child: Container(
                              width: width * 0.88,
                              height: height * 0.05,
                              child: Row(children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Icon(
                                    IconData(0xf06bd,
                                        fontFamily: 'MaterialIcons'),
                                    color: Colors.green[700],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("My vouchers"),
                                ),
                                new Spacer(),
                                Icon(Icons.arrow_forward),
                                SizedBox(
                                  width: 10,
                                )
                              ]),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 80),
                        child: Column(
                          children: [
                            SizedBox(
                              height: height * 0.03,
                            ),
                            const Text(
                              "Give This To The Cashier",
                              style: TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.none,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'WorkSans',
                              ),
                            ),
                            SizedBox(
                              height: height * 0.03,
                            ),
                            QrImage(size: 280, data: result),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
