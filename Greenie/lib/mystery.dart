import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class Mystery extends StatefulWidget {
  final String uid;
  const Mystery({required this.uid, super.key});

  @override
  // ignore: no_logic_in_create_state
  State<Mystery> createState() => _MysteryState(uid);
}

class _MysteryState extends State<Mystery> {
  String uid;
  _MysteryState(this.uid);

  late dynamic inventoryID;
  late dynamic itemList;

  Future getData() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    final docRef = db.collection("userProfile").doc(uid);
    await docRef.get().then(
      (DocumentSnapshot doc) {
        dynamic data = doc.data() as Map<String, dynamic>;
        inventoryID = data['inventoryID'];
      },
      onError: (e) => print("Error getting document: $e"),
    );
    final inventRef = db.collection("gameInventory").doc(inventoryID);
    await inventRef.get().then(
      (DocumentSnapshot doc) {
        dynamic data = doc.data() as Map<String, dynamic>;
        itemList = data['items'];
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    dynamic alert(image, rarity) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: null,
          content: SizedBox(
            height: height * 0.25,
            width: width * 0.6,
            child: Column(
              children: [
                SizedBox(
                    width: width * 0.2,
                    child: Image(
                      image: AssetImage(image),
                    )),
                const Spacer(),
                Text.rich(
                  TextSpan(
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                      children: [
                        const TextSpan(
                            text: "Congratulations! You just open a "),
                        TextSpan(
                          text: rarity,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: " plant!")
                      ]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        color: const Color(0xFF242424),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                FutureBuilder(
                    future: getData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {}
                      return Container();
                    }),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Center(
                  child: Image(
                    image: AssetImage('lib/assets/chest.png'),
                  ),
                ),
                const Center(
                  child: Text(
                    "MYSTERY",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        letterSpacing: 8),
                  ),
                ),
                const Center(
                  child: Text(
                    "PLANT",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        letterSpacing: 8),
                  ),
                ),
                const Spacer(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Price: ",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Text(
                      "200 GP",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: SizedBox(
                    width: 150,
                    height: 40,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () {
                          int random = Random().nextInt(100);

                          if (random < 50) {
                            itemList.add("common");
                            alert("lib/assets/common.png", "common");
                          }

                          if (random >= 50 && random < 80) {
                            itemList.add("rare");
                            alert("lib/assets/rare.png", "rare");
                          }

                          if (random >= 80 && random < 90) {
                            itemList.add("epic");
                            alert("lib/assets/epic.png", "epic");
                          }

                          if (random >= 90 && random < 97) {
                            itemList.add("legendary");
                            alert("lib/assets/legend.png", "legendary");
                          }

                          if (random >= 97) {
                            itemList.add("mythical");
                            alert("lib/assets/mythic.png", "mythical");
                          }

                          print(itemList.join(","));

                          final inventRef = FirebaseFirestore.instance
                              .collection('gameInventory')
                              .doc(inventoryID);

                          inventRef.get().then((docSnapshot) async => {
                                inventRef.update({
                                  'items': itemList,
                                })
                              });

                          setState(() {});
                        },
                        child: const Text(
                          "Buy",
                          style: TextStyle(fontSize: 20),
                        )),
                  ),
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
