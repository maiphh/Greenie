import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:/home.dart';

class GpShop extends StatefulWidget {
  const GpShop({super.key});

  @override
  State<GpShop> createState() => _GpShopState();
}

class _GpShopState extends State<GpShop> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              backgroundColor: Colors.green,
              bottom: const TabBar(tabs: [
                Tab(
                  text: "Products",
                ),
                Tab(
                  text: "Vouchers",
                ),
              ]),
              actions: [
                IconButton(
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: MySearchDelegate(),
                      );
                    },
                    icon: const Icon(Icons.search))
              ]),
          body: TabBarView(
            children: [
              StreamBuilder(
                  stream: readProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text(
                          "Something went wrong hahahha${snapshot.error}");
                    } else if (snapshot.hasData) {
                      final components = snapshot.data!;
                      return ListView(
                          children: components.map((buildItem)).toList());
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
              Text("Vouchers")
              // TestComponent(),
            ],
          ),
        ),
      ),
    );
  }
}

Stream<List<Item>> readProducts() => FirebaseFirestore.instance
    .collection('product')
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => Item.fromJSON(doc.data())).toList());
Future<String> readProductImage(String path) =>
    FirebaseStorage.instance.ref().child(path).getDownloadURL();

Widget buildItem(Item component) {
  return ItemComponent(
    brand: component.brand,
    itemName: component.itemName,
    price: component.price,
    imageUrl: component.imageUrl,
  );
}

class MySearchDelegate extends SearchDelegate {
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
          }
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  List<Item> filterItems(List<Item> list) {
    List<Item> curatedList = [];
    for (var item in list) {
      if (item.brand.toLowerCase().contains(query.toLowerCase()) ||
          item.itemName.toLowerCase().contains(query.toLowerCase()) ||
          item.price.toString().contains(query.toLowerCase())) {
        curatedList.add(item);
      }
    }

    return curatedList;
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder(
        stream: readProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong hahahha${snapshot.error}");
          } else if (snapshot.hasData) {
            final components = snapshot.data!;
            final curatedList = filterItems(components);
            return ListView(children: curatedList.map((buildItem)).toList());
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder(
        stream: readProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong hahahha${snapshot.error}");
          } else if (snapshot.hasData) {
            final components = snapshot.data!;
            final curatedList = filterItems(components);
            return ListView(children: curatedList.map((buildItem)).toList());
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

class ItemComponent extends StatelessWidget {
  final String brand;
  final String itemName;
  final int price;
  String imageUrl;

  ItemComponent(
      {super.key,
      required this.brand,
      required this.itemName,
      required this.price,
      required this.imageUrl});
  static ItemComponent fromJSON(Map<String, dynamic> json) => ItemComponent(
        brand: json['collaborator'],
        itemName: json['description'],
        price: json['price']['cost'],
        imageUrl: json['image'],
      );

  getImageUrl() async {
    final storageRef = FirebaseStorage.instance.ref();
    final ref = storageRef.child(this.imageUrl);
    final url = await ref.getDownloadURL();
    imageUrl = url;
    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.9;
    double height = MediaQuery.of(context).size.height * 1 / 10;
    double borderRad = width * 0.03;
    // const String assetPath = "lib/assets/bottle green 2.png";

    return Padding(
      padding: EdgeInsets.symmetric(vertical: height * 0.14),
      child: Align(
        alignment: Alignment.center,
        child: ClipShadowPath(
          shadow: const BoxShadow(
              color: Color.fromARGB(255, 109, 109, 109),
              offset: Offset(3, 1.8),
              spreadRadius: 10,
              blurRadius: 10,
              blurStyle: BlurStyle.inner),
          clipper: ComponentClipper(),
          child: GestureDetector(
            onTap: () => {print("Tapped")},
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(borderRad))),
              width: width,
              height: height,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: width * 0.015),
                child: Row(
                  children: [
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                        child: FutureBuilder(
                          future: getImageUrl(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Image(image: NetworkImage(this.imageUrl));
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        )),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          this.brand,
                          style: TextStyle(
                              color: const Color(0xff37734D),
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.05),
                        ),
                        Text(
                          this.itemName,
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.04),
                        ),
                        Text(
                          "Price: " + "${this.price}" + " GP",
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.normal,
                              fontSize: width * 0.04),
                        )
                      ],
                    ),
                    new Spacer(),
                    Container(
                      width: width * 0.17,
                      height: height,
                      child: TextButton(
                        onPressed: () {
                          print("buttontapped");

                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Row(
                                      children: [
                                        const Spacer(),
                                        const Center(
                                            child:
                                                Text("Purchase confirmation")),
                                        new Spacer(),
                                        Container(
                                          width: width * 0.08,
                                          height: width * 0.08,
                                          child: IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () =>
                                                {Navigator.pop(context)},
                                          ),
                                        )
                                      ],
                                    ),
                                    content: const Text(
                                        "Are you sure you want to buy this item?"),
                                    actions: [
                                      TextButton.icon(
                                          onPressed: () => {
                                                Navigator.pop(context),
                                              },
                                          icon: const Icon(Icons.abc),
                                          label: const Text("Label"))
                                    ],
                                  ));
                        },
                        child: const Text("Buy"),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Item {
  final String brand;
  final String itemName;
  final int price;
  final String imageUrl;

  const Item(
      {required this.brand,
      required this.itemName,
      required this.price,
      required this.imageUrl});
  static Item fromJSON(Map<String, dynamic> json) => Item(
      brand: json['collaborator'],
      itemName: json['category'],
      price: json['price']['cost'],
      imageUrl: json['image']);
}

class ComponentClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    int roundnessFactor = 50;

    Path path = Path();

    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.moveTo(size.width * 0.73, size.height);
    path.quadraticBezierTo(size.width * 0.78, size.height - size.width * 0.08,
        size.width * 0.83, size.height);
    path.moveTo(size.width * 0.83, 0);
    path.quadraticBezierTo(
        size.width * 0.78, size.width * 0.08, size.width * 0.73, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class ClipShadowPath extends StatelessWidget {
  final Shadow shadow;
  final CustomClipper<Path> clipper;
  final Widget child;

  const ClipShadowPath({
    Key? key,
    required this.shadow,
    required this.clipper,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ClipShadowShadowPainter(
        clipper: clipper,
        shadow: shadow,
      ),
      child: ClipPath(child: child, clipper: clipper),
    );
  }
}

class _ClipShadowShadowPainter extends CustomPainter {
  final Shadow shadow;
  final CustomClipper<Path> clipper;

  _ClipShadowShadowPainter({required this.shadow, required this.clipper});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = shadow.toPaint();
    var clipPath = clipper.getClip(size).shift(shadow.offset);
    // canvas.drawPath(clipPath, paint);
    canvas.drawShadow(clipPath, Colors.black, shadow.offset.distance, false);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
