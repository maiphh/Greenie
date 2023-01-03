import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'home.dart';

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
                const Image(
                  image: AssetImage("lib/assets/Qr holder.png"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  child: Column(
                    children: [
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
                      const SizedBox(
                        height: 30,
                      ),
                      QrImage(size: 280, data: uid),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          color: const Color(0xFFB1F39A),
                          border: Border.all(
                            color: const Color(0xFF7BC143),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "GP Wallet",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text("15 GP"),
                              ],
                            ),
                            const SizedBox(
                              width: 50,
                            ),
                            const Image(
                              image: AssetImage("lib/assets/plusicon.png"),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
