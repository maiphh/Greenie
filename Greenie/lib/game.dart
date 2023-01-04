import 'package:bitcointicker/home.dart';
import 'package:bitcointicker/mystery.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:sliding_up_panel/sliding_up_panel.dart';

void wrapMethod(String uid) async {
  await getInventoryID(uid);
}

Future getInventoryID(String uid) async {
  String inventoryID = "";
  FirebaseFirestore db = FirebaseFirestore.instance;
  final docRef = db.collection("userProfile").doc(uid);
  final doc = await docRef.get();
  dynamic data = doc.data() as Map<String, dynamic>;
  inventoryID = data['inventoryID'];
  globalInventory = inventoryID;
  return inventoryID;
}

// ignore: must_be_immutable
class Game extends StatefulWidget {
  final String uid;

  const Game({super.key, required this.uid});

  @override
  State<Game> createState() => _GameState(uid);

  // final Stream<DocumentSnapshot> items = FirebaseFirestore.instance
  //   .collection('gameInventory')
  //   .doc(uid)
  //   .snapshots();
}

String uidGlobal = "";
String globalInventory = "";

class _GameState extends State<Game> {
  String uid;
  _GameState(this.uid);

  @override
  void initState() {
    // TODO: implement initState
    var placeholder = [uid];
    // getInventoryID(uid).then((value) {
    //   print(value);
    // });
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   getInventoryID(uid);
    // });
    // Future.delayed(Duration.zero, () async {
    //   await getInventoryID(uid);
    // });
    // Future.wait([for (var i in placeholder) getInventoryID(i)]);
    // print(result[0]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    uidGlobal = uid;
    final Stream<DocumentSnapshot> items = FirebaseFirestore.instance
        .collection('gameInventory')
        .doc(uidGlobal)
        .snapshots();

    BorderRadiusGeometry radius = const BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );

    Map<String, dynamic> toCount() {
      print("toCount commonCount is: ${commonCount}");
      return {
        'common': commonCount,
        'epic': epicCount,
        'legendary': legendaryCount,
        'mythical': mythicalCount,
        'rare': rareCount
      };
    }

    Stream<List<GameItem>> readGameItem() => FirebaseFirestore.instance
        .collection('gameItem')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => GameItem.fromJson({...doc.data(), ...toCount()}))
            .toList());
    Widget buildImageItem(GameItem gameItem) => GridTile(
          // ignore: prefer_const_constructors
          // gridDelegate:
          //     SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          // itemBuilder: (context, index) =>
          child: Image(image: Image.network(gameItem.image).image),
        );

    Widget buildGameItem(GameItem gameItem) => Foo(
          gameItem: gameItem,
        );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Mystery(uid: widget.uid),
                  ));
            },
            icon: Icon(Icons.shopping_cart),
          )
        ],
        title: Center(
            child: Text(
          "Mini Planet",
          style: TextStyle(fontSize: 23),
        )),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        // actions: const [OptionButton(), OptionButton()],
      ),
      body: SlidingUpPanel(
        backdropEnabled: true,
        panel: Column(children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Text(
              'Tree List',
              style: TextStyle(
                color: Colors.green,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("gameInventory")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData)
                  return const Center(child: CircularProgressIndicator());

                return FutureBuilder(
                  future: getInventoryID(uidGlobal),
                  builder: (_, snap) {
                    if (!snap.hasData)
                      return const Center(child: CircularProgressIndicator());
                    var counts = {
                      "common": 0,
                      "rare": 0,
                      "epic": 0,
                      "legendary": 0,
                      "mythical": 0
                    };
                    int common = 0;
                    String inventoryID = snap.data.toString();
                    final gameList =
                        snapshot.data!.docs.where((DocumentSnapshot document) {
                      return document.id == inventoryID;
                    }).map((DocumentSnapshot document) {
                      final itemList = document['items'];
                      for (String i in itemList) {
                        counts[i] = counts[i]! + 1;
                      }
                      return common;
                    });
                    String result = gameList.first.toString();
                    // print(counts.toString());
                    String another = counts["common"].toString();
                    // Need to loop through game Item
                    // FInd the old reference
                    GameItem a1 = new GameItem(
                        image: "lib/assets/common.png",
                        name: "Common",
                        reward: "5",
                        count: counts["common"]!);
                    GameItem a2 = new GameItem(
                        image: "lib/assets/rare.png",
                        name: "Rare",
                        reward: "10",
                        count: counts["rare"]!);
                    GameItem a3 = new GameItem(
                        image: "lib/assets/epic.png",
                        name: "Epic",
                        reward: "20",
                        count: counts["epic"]!);
                    GameItem a4 = new GameItem(
                        image: "lib/assets/legend.png",
                        name: "Legendary",
                        reward: "50",
                        count: counts["legendary"]!);
                    GameItem a5 = new GameItem(
                        image: "lib/assets/mythic.png",
                        name: "Mythical",
                        reward: "100",
                        count: counts["mythical"]!);

                    final gameItem = [a1, a2, a3, a4, a5];
                    var totalCount = "0";
                    for (GameItem g in gameItem) {
                      totalCount += g.reward;
                    }
                    return
                        // Column(children: [
                        ListView(
                      children: gameItem.map(buildGameItem).toList(),
                    );
                    //   Text("${totalCount}")
                    // ]);
                  },
                );
              },
            ),
          ),
          Container(child: countReward())
          //   Padding(
        ]),
        collapsed: Container(
          decoration:
              BoxDecoration(borderRadius: radius, color: Colors.green[200]),
          // color: Colors.greenAccent,
          child: Center(
            child: Text(
              "Tree List",
              style: TextStyle(
                color: Colors.green,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        body: ClipRRect(
          child: Expanded(
            flex: 8,
            child: Stack(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('lib/assets/planet1.png'),
                              fit: BoxFit.cover)),
                    )),
                displayGameInventory(),
              ],
            ),
          ),
        ),
        borderRadius: radius,
      ),
    );
  }
}

class countReward extends StatelessWidget {
  const countReward({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance.collection("gameInventory").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());

        return FutureBuilder(
          future: getInventoryID(uidGlobal),
          builder: (_, snap) {
            if (!snap.hasData)
              return const Center(child: CircularProgressIndicator());
            var counts = {
              "common": 0,
              "rare": 0,
              "epic": 0,
              "legendary": 0,
              "mythical": 0
            };
            int common = 0;
            String inventoryID = snap.data.toString();
            final gameList =
                snapshot.data!.docs.where((DocumentSnapshot document) {
              return document.id == inventoryID;
            }).map((DocumentSnapshot document) {
              final itemList = document['items'];
              for (String i in itemList) {
                counts[i] = counts[i]! + 1;
              }
              return common;
            });
            String result = gameList.first.toString();
            // print(counts.toString());
            String another = counts["common"].toString();
            // Need to loop through game Item
            // FInd the old reference
            GameItem a1 = new GameItem(
                image: "lib/assets/common.png",
                name: "Common",
                reward: "5",
                count: counts["common"]!);
            GameItem a2 = new GameItem(
                image: "lib/assets/rare.png",
                name: "Rare",
                reward: "10",
                count: counts["rare"]!);
            GameItem a3 = new GameItem(
                image: "lib/assets/epic.png",
                name: "Epic",
                reward: "20",
                count: counts["epic"]!);
            GameItem a4 = new GameItem(
                image: "lib/assets/legend.png",
                name: "Legendary",
                reward: "50",
                count: counts["legendary"]!);
            GameItem a5 = new GameItem(
                image: "lib/assets/mythic.png",
                name: "Mythical",
                reward: "100",
                count: counts["mythical"]!);

            final gameItem = [a1, a2, a3, a4, a5];
            var reward = 0;
            for (GameItem a in gameItem) {
              reward += a.count * int.parse(a.reward);
            }
            return Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
                child: Text(
                  "Reward: ${reward}GPs/ min",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[600]),
                ));
          },
        );
      },
    );
  }
}


class TreeGrid extends StatefulWidget {
  const TreeGrid({super.key});

  @override
  State<TreeGrid> createState() => _TreeGridState();
}

class _TreeGridState extends State<TreeGrid> {
  @override
  Widget build(BuildContext context) {
    return Container();
    // return displayGameInventory();
  }
}

class OptionButton extends StatelessWidget {
  const OptionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          alignment: Alignment.center,
          backgroundColor: Colors.green[200],
          foregroundColor: Colors.black,
          shadowColor: Colors.grey,
        ),
        child: const Icon(
          Icons.favorite,
          // color: Colors.amber,
        ));
  }
}

int commonCount = 0;
int epicCount = 0;
int legendaryCount = 0;
int mythicalCount = 0;
int rareCount = 0;

class displayGameInventory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance.collection("gameInventory").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> sna) {
        if (!sna.hasData) {
          return Text("Something has gone wrong: $sna.error");
        }
        ;
        if (sna.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        return FutureBuilder(
            future: getInventoryID(uidGlobal),
            builder: (_, snap) {
              if (!snap.hasData)
                return const Center(child: CircularProgressIndicator());
              String inventoryID = snap.data.toString();
              final snapshot = sna.data!.docs.where((DocumentSnapshot doc) {
                return doc.id == inventoryID;
              });
              final data = snapshot.first;
              List<String> itemImages = <String>[];
              List<dynamic> origin = data['items'];
              List<dynamic> items = origin.reversed.toList();
              for (int i = 0; i < items.length; i++) {
                if (items[i] == "common") {
                  itemImages.add("lib/assets/common.png");
                  commonCount++;
                }
                if (items[i] == "epic") {
                  itemImages.add("lib/assets/epic.png");
                  epicCount++;
                }
                if (items[i] == "legendary") {
                  itemImages.add("lib/assets/legend.png");
                  legendaryCount++;
                }
                if (items[i] == "mythical") {
                  itemImages.add("lib/assets/mythic.png");
                  mythicalCount++;
                }
                if (items[i] == "rare") {
                  itemImages.add("lib/assets/rare.png");
                  rareCount++;
                }
              }
              print(itemImages.length);
              return Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 200),
                child: (GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemCount: itemImages.length,
                    itemBuilder: ((BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.all(8),
                        child: Image.asset(itemImages[index]),
                      );
                    }))),
              );
            });
      },
    );
  }
}

// ignore: empty_constructor_bodies
class GameItem {
  String image;
  String name;
  String reward;
  int count;

  GameItem(
      {required this.image,
      required this.name,
      required this.reward,
      required this.count});

  // Map<String, dynamic> toJson() =>
  //     {'image': image, 'name': name, 'reward': reward};

  static GameItem fromJson(Map<String, dynamic> json) => GameItem(
      image: json['image'],
      name: json['name'],
      reward: json['reward'],
      count: json[json['name']]);
}

class Foo extends StatefulWidget {
  GameItem gameItem;
  Foo({Key? key, required this.gameItem}) : super(key: key);
  @override
  State<Foo> createState() => _FooState();
}

class _FooState extends State<Foo> {
  @override
  Widget build(BuildContext context) {
    print("This is foo");
    return ListTile(
      leading: CircleAvatar(
          backgroundColor: Colors.white,
          child: Image.asset(widget.gameItem.image)),
      title: Text(widget.gameItem.name),
      subtitle: Text("Reward: ${widget.gameItem.reward} GPs/min"),
      trailing: Text(widget.gameItem.count.toString()),
    );
  }
}
