import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:ui' show lerpDouble;

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

class _GameState extends State<Game> {
  String uid;
  _GameState(this.uid);

  int commonCount = 0;
  int epicCount = 0;
  int legendaryCount = 0;
  int mythicalCount = 0;
  int rareCount = 0;
  List<String> itemImages = <String>[];
  void countTrees(List<dynamic> items) {
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
    print("common count is : ${commonCount}");
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
        leading:
            IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back)),
        // actions: const [OptionButton(), OptionButton()],
      ),
      body: SlidingUpPanel(
        backdropEnabled: true,
        panel: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
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
              child: Container(
                  child: StreamBuilder<List<GameItem>>(
                stream: readGameItem(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error = ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final GameItem = snapshot.data!;

                    return ListView(
                      // children: GameItem.map(buildGameItem).toList(),
                      children:
                          GameItem.map((gameItem) => Foo(gameItem: gameItem))
                              .toList(),
                    );

                    // GameItem.map(buildGameItem).toList();
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              )),
            ),
          ],
        ),
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
                displayGameInventory(
                  items: items,
                  itemImages: itemImages,
                  countTrees: countTrees,
                ),
              ],
            ),
          ),
        ),
        borderRadius: radius,
      ),
    );
  }
}

class TopBar extends StatefulWidget {
  const TopBar({super.key});

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          // color: Colors.black,
          decoration: const BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back)),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () {},
                    // ignore: prefer_const_constructors
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                      Colors.green[300],
                    )),
                    child: const Text('TuanCuiBuonBa'),
                  ))
            ],
          ),
        )
      ],
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

typedef countTreesCallback = Function(List<dynamic>);

class displayGameInventory extends StatelessWidget {
  late Stream<DocumentSnapshot> items;
  List<String> itemImages;
  countTreesCallback countTrees;
  displayGameInventory(
      {super.key,
      required this.items,
      required this.itemImages,
      required this.countTrees});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: items,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Text("Something has gone wrong: $snapshot.error");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        final data = snapshot.requireData;

        List<dynamic> items = data['items'];
        countTrees(items);

        return GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemCount: itemImages.length,
            itemBuilder: ((BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.all(8),
                child: Image.asset(itemImages[index]),
              );
            }));
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

Stream<List<GameItem>> readGameItem() => FirebaseFirestore.instance
    .collection('gameItem')
    .snapshots()
    .map((snapshot) => snapshot.docs
        .map((doc) => GameItem.fromJson({...doc.data(), ...toCount()}))
        .toList());

Widget buildGameItem(GameItem gameItem) => Foo(
      gameItem: gameItem,
    );

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
          child: Image.network(widget.gameItem.image)),
      title: Text(widget.gameItem.name),
      subtitle: Text("Rarity: ${widget.gameItem.reward}"),
      trailing: Text(widget.gameItem.count.toString()),
    );
  }
}
