import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'home.dart';
import 'package:quickalert/quickalert.dart';

void updateGP(int value, String uid, BuildContext context) async {
  final docUser = FirebaseFirestore.instance.collection("userProfile").doc(uid);
  var data = await docUser.get();
  var wallet = data['GP'];
  print(wallet);
  if (value < 0) {
    if (wallet + value < 0) {
      QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: "Oops...",
          text: "You don't have enough GP");
    } else {
      docUser.update({'GP': FieldValue.increment(value)});
      QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: "Purchase Successfully!");
    }
  } else {
    docUser.update({'GP': FieldValue.increment(value)});
  }
}

void updateUserVoucher(
    int value, String uid, String docId, BuildContext context) async {
  // FirebaseFirestore db = FirebaseFirestore.instance;
  // final CollectionReference voucherRef = db.collection("voucher");
  // await voucherRef
  //     .where('code', isEqualTo: code).

  // ;
  final docUser = FirebaseFirestore.instance.collection("userProfile").doc(uid);
  var data = await docUser.get();
  var wallet = data['GP'];
  print(wallet);
  if (value < 0) {
    if (wallet + value < 0) {
      QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: "Oops...",
          text: "You don't have enough GP");
    } else {
      docUser.update({'GP': FieldValue.increment(value)});
      final docVoucher =
          FirebaseFirestore.instance.collection("voucher").doc(docId);
      docVoucher.update({'user': uid});
      QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: "Purchase Successfully!");
    }
  } else {
    docUser.update({'GP': FieldValue.increment(value)});
  }
}

class GpShop extends StatefulWidget {
  final String uid;
  const GpShop({super.key, required this.uid});

  @override
  State<GpShop> createState() => _GpShopState();
}

class _GpShopState extends State<GpShop> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    
/********************************************************************************
*Title: Flutter TabBar and TabBarView Without Scaffold & AppBar | Custom Indicator & TabBarController
*Author: dbestech
*Date: November 11, 2021
*Code version: None
*Availability: https://www.youtube.com/watch?v=m_MXkSKz_F8&t=1s (Accessed 25 November, 2022)
*********************************************************************************/


    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          bottomNavigationBar: BottomNavBar(
            uid: widget.uid,
            currentIndex: 2,
          ),
          backgroundColor: Colors.white,
          appBar: AppBar(
              title: Text("foo"),
              backgroundColor: Colors.white,
              bottom: const TabBar(
                  labelColor: Colors.black,
                  indicatorColor: Colors.green,
                  tabs: [
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
                        delegate: ProductSearchDelegate(uid: widget.uid),
                      );
                    },
                    icon: const Icon(
                      Icons.search,
                      color: Colors.black,
                    ))
              ]),
          body: TabBarView(
            children: [
              ProductStreamBuilder(
                uid: widget.uid,
              ),
              VoucherStreamBuilder(uid: widget.uid)
            ],
          ),
        ),
      ),
    );
  }
}

class VoucherStreamBuilder extends StatelessWidget {
  String uid;
  VoucherStreamBuilder({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: readVouchers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong hahahha${snapshot.error}");
          } else if (snapshot.hasData) {
            var components = snapshot.data!;
            List<Voucher> newComponents = [];
            for (Voucher voucher in components) {
              if (voucher.user == "") {
                newComponents.add(voucher);
              }
            }
            components = newComponents;
            return ListView(
                children: components
                    .map((component) => VoucherComponent(
                          docId: component.docId,
                          uid: this.uid,
                          code: component.code,
                          collaborator: component.collaborator,
                          description: component.description,
                          discount: component.discount,
                          expiryDate: component.expiryDate,
                          logoPath: component.logoPath,
                          name: component.name,
                          price: component.price,
                          user: component.user,
                        ))
                    .toList());
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

class ProductStreamBuilder extends StatelessWidget {
  String uid;
  ProductStreamBuilder({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: readProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong hahahha${snapshot.error}");
          } else if (snapshot.hasData) {
            final components = snapshot.data!;
            return ListView(
                children: components
                    .map((component) => ProductComponent(
                          uid: this.uid,
                          brand: component.brand,
                          itemName: component.itemName,
                          price: component.price,
                          imageUrl: component.imageUrl,
                        ))
                    .toList());
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

Stream<List<Product>> readProducts() => FirebaseFirestore.instance
    .collection('product')
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => Product.fromJSON(doc.data())).toList());
Stream<List<Voucher>> readVouchers() => FirebaseFirestore.instance
    .collection('voucher')
    .snapshots()
    .map((snapshot) => snapshot.docs
        .map((doc) => Voucher.fromJSON(doc.data(), doc.id))
        .toList());

class Voucher {
  final String docId;
  final String code;
  final String collaborator;
  final String description;
  final double discount;
  final String expiryDate;
  final String logoPath;
  final String name;
  final int price;
  final String user;
  const Voucher(
      {required this.code,
      required this.docId,
      required this.collaborator,
      required this.description,
      required this.discount,
      required this.expiryDate,
      required this.logoPath,
      required this.name,
      required this.price,
      required this.user});
  static Voucher fromJSON(Map<String, dynamic> json, String docId) {
    return Voucher(
        docId: docId,
        code: json['code'],
        collaborator: json['collaborator'],
        description: json['description'],
        discount: json['discount'],
        expiryDate: json['expireDate'],
        logoPath: json['logo'],
        name: json['name'],
        price: json['price'],
        user: json['user']);
  }
}

class VoucherComponent extends StatelessWidget {
  final String code;
  String docId;
  final String collaborator;
  final String description;
  final double discount;
  final String expiryDate;
  String logoPath;
  final String name;
  final int price;
  String user;
  String uid;
  VoucherComponent(
      {super.key,
      required this.docId,
      required this.code,
      required this.uid,
      required this.collaborator,
      required this.description,
      required this.discount,
      required this.expiryDate,
      required this.logoPath,
      required this.name,
      required this.price,
      required this.user});

  getImageUrl() async {
    final storageRef = FirebaseStorage.instance.ref();
    final ref = storageRef.child(logoPath);
    final url = await ref.getDownloadURL();
    logoPath = url;
    return logoPath;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.9;
    double height = MediaQuery.of(context).size.height * 1 / 9;
    double borderRad = width * 0.03;

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
              // height: height,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: width * 0.015),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                        child: FutureBuilder(
                          future: getImageUrl(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Image(
                                  height: height,
                                  width: width * 0.15,
                                  image: NetworkImage(this.logoPath));
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        )),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          this.collaborator,
                          style: TextStyle(
                              color: const Color(0xff37734D),
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.05),
                        ),
                        Text(
                          "Discount: ${(this.discount * 100).toInt()}%",
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
                          QuickAlert.show(
                              onConfirmBtnTap: () {
                                // updateGP(-this.price, uid, context);
                                updateUserVoucher(
                                    -this.price, uid, docId, context);
                                // user = this.uid;
                                Navigator.pop(context);
                              },
                              context: context,
                              type: QuickAlertType.confirm,
                              title: "Purchase confirmation",
                              text: "Do you want to buy this product?",
                              widget: Container(
                                height: height * 1.9,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: width * 0.05),
                                            child: Image(
                                                width: width * 0.2,
                                                image: NetworkImage(
                                                    this.logoPath))),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              this.collaborator,
                                              style: TextStyle(
                                                  color:
                                                      const Color(0xff37734D),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: width * 0.05),
                                            ),
                                            Text(
                                              "Discount: ${(this.discount * 100).toInt()}%",
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: width * 0.04),
                                            ),
                                            Text(
                                              "Price: " +
                                                  "${this.price}" +
                                                  " GP",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: width * 0.04),
                                            )
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ));
                          // showDialog(
                          //     context: context,
                          //     builder: (context) => AlertDialog(
                          //           title: Row(
                          //             children: [
                          //               const Spacer(),
                          //               const Center(
                          //                   child:
                          //                       Text("Purchase confirmation")),
                          //               new Spacer(),
                          //             ],
                          //           ),
                          //           content: Container(
                          //             height: height * 1.9,
                          //             child: Column(
                          //               children: [
                          //                 Padding(
                          //                   padding: EdgeInsets.only(
                          //                       bottom: width * 0.05),
                          //                   child: const Text(
                          //                       "Are you sure you want to buy this item?"),
                          //                 ),
                          //                 Row(
                          //                   children: [
                          //                     Padding(
                          //                         padding: EdgeInsets.symmetric(
                          //                             horizontal: width * 0.05),
                          //                         child: Image(
                          //                             width: width * 0.2,
                          //                             image: NetworkImage(
                          //                                 this.logoPath))),
                          //                     Column(
                          //                       mainAxisAlignment:
                          //                           MainAxisAlignment
                          //                               .spaceEvenly,
                          //                       children: [
                          //                         Text(
                          //                           this.collaborator,
                          //                           style: TextStyle(
                          //                               color: const Color(
                          //                                   0xff37734D),
                          //                               fontWeight:
                          //                                   FontWeight.bold,
                          //                               fontSize: width * 0.05),
                          //                         ),
                          //                         Text(
                          //                           "Discount: ${(this.discount * 100).toInt()}%",
                          //                           style: TextStyle(
                          //                               color: Colors.black54,
                          //                               fontWeight:
                          //                                   FontWeight.bold,
                          //                               fontSize: width * 0.04),
                          //                         ),
                          //                         Text(
                          //                           "Price: " +
                          //                               "${this.price}" +
                          //                               " GP",
                          //                           style: TextStyle(
                          //                               color: Colors.grey,
                          //                               fontWeight:
                          //                                   FontWeight.normal,
                          //                               fontSize: width * 0.04),
                          //                         )
                          //                       ],
                          //                     )
                          //                   ],
                          //                 )
                          //               ],
                          //             ),
                          //           ),
                          //           actions: [
                          //             TextButton(
                          //                 onPressed: () => {
                          //                       Navigator.pop(context),
                          //                     },
                          //                 child: const Text("Cancel")),
                          //             TextButton(
                          //                 onPressed: () => {
                          //                       Navigator.pop(context),
                          //                       updateGP(-this.price, this.uid,
                          //                           context)
                          //                     },
                          //                 child: const Text("Buy")),
                          //           ],
                          //         ));
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

class CircleTabIndicator extends Decoration {
  final Color color;
  double radius;

  CircleTabIndicator({required this.color, required this.radius});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CirclePainter(color: color, radius: radius);
  }
}

class _CirclePainter extends BoxPainter {
  final double radius;
  late Color color;
  _CirclePainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    late Paint _paint;
    _paint = Paint()..color = color;
    _paint = _paint..isAntiAlias = true;
    final Offset circleOffset =
        offset + Offset(cfg.size!.width / 2, cfg.size!.height - radius);
    canvas.drawCircle(circleOffset, radius, _paint);
  }
}

typedef ProductFilterCallBack = List<Product> Function(List<Product>);
typedef VoucherFilterCallBack = List<Voucher> Function(List<Voucher>);

class Suggestions extends StatefulWidget {
  String uid;
  ProductFilterCallBack? productFilterCallback;
  VoucherFilterCallBack? voucherFilterCallback;
  Suggestions(
      {super.key,
      this.productFilterCallback,
      this.voucherFilterCallback,
      required this.uid});

  @override
  State<Suggestions> createState() => _SuggestionsState();
}

class _SuggestionsState extends State<Suggestions>
    with
        TickerProviderStateMixin<Suggestions>,
        AutomaticKeepAliveClientMixin<Suggestions> {
  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 2, vsync: this);

    return Column(
      children: [
        Container(
            child: TabBar(
                // isScrollable: true,
                indicator: CircleTabIndicator(color: Colors.green, radius: 4),
                controller: tabController,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                tabs: const [
              Tab(
                text: "Products",
              ),
              Tab(
                text: "Vouchers",
              ),
            ])),
        Flexible(
          child: TabBarView(controller: tabController, children: [
            StreamBuilder(
                stream: readProducts(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text(
                        "Something went wrong hahahha${snapshot.error}");
                  } else if (snapshot.hasData) {
                    var components = snapshot.data!;

                    if (widget.productFilterCallback != null) {
                      components = widget.productFilterCallback!(components);
                    }
                    return ListView(
                        children: components
                            .map((component) => ProductComponent(
                                  uid: widget.uid,
                                  brand: component.brand,
                                  itemName: component.itemName,
                                  price: component.price,
                                  imageUrl: component.imageUrl,
                                ))
                            .toList());
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
            StreamBuilder(
                stream: readVouchers(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text(
                        "Something went wrong hahahha${snapshot.error}");
                  } else if (snapshot.hasData) {
                    var components = snapshot.data!;
                    if (widget.voucherFilterCallback != null) {
                      components = widget.voucherFilterCallback!(components);
                    }
                    List<Voucher> newComponents = [];
                    for (Voucher voucher in components) {
                      if (voucher.user == "") {
                        newComponents.add(voucher);
                      }
                    }
                    components = newComponents;
                    return ListView(
                        children: components
                            .map((component) => VoucherComponent(
                                  docId: component.docId,
                                  uid: widget.uid,
                                  code: component.code,
                                  collaborator: component.collaborator,
                                  description: component.description,
                                  discount: component.discount,
                                  expiryDate: component.expiryDate,
                                  logoPath: component.logoPath,
                                  name: component.name,
                                  price: component.price,
                                  user: component.user,
                                ))
                            .toList());
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                })
          ]),
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ProductSearchDelegate extends SearchDelegate {
  String uid;
  ProductSearchDelegate({required this.uid});

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

  List<Product> filterProducts(List<Product> list) {
    List<Product> curatedList = [];
    for (var item in list) {
      if (item.brand.toLowerCase().contains(query.toLowerCase()) ||
          item.itemName.toLowerCase().contains(query.toLowerCase()) ||
          item.price.toString().contains(query.toLowerCase())) {
        curatedList.add(item);
      }
    }

    return curatedList;
  }

  List<Voucher> filterVouchers(List<Voucher> list) {
    List<Voucher> curatedList = [];
    for (var item in list) {
      if (item.name.toLowerCase().contains(query.toLowerCase()) ||
          item.discount
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()) ||
          item.price.toString().contains(query.toLowerCase()) ||
          item.collaborator.toLowerCase().contains(query.toLowerCase())) {
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
            var components = snapshot.data!;
            components = filterProducts(components);
            return ListView(
                children: components
                    .map((component) => ProductComponent(
                          uid: this.uid,
                          brand: component.brand,
                          itemName: component.itemName,
                          price: component.price,
                          imageUrl: component.imageUrl,
                        ))
                    .toList());
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Suggestions(
      uid: this.uid,
      productFilterCallback: filterProducts,
      voucherFilterCallback: filterVouchers,
    );
  }
}

class ProductComponent extends StatelessWidget {
  final String brand;
  final String itemName;
  final int price;
  String imageUrl;
  String uid;

  ProductComponent(
      {super.key,
      required this.brand,
      required this.itemName,
      required this.price,
      required this.uid,
      required this.imageUrl});
  static ProductComponent fromJSON(Map<String, dynamic> json) =>
      ProductComponent(
        brand: json['collaborator'],
        itemName: json['name'],
        price: json['price']['cost'],
        imageUrl: json['image'],
        uid: "",
      );

  getImageUrl() async {
    final storageRef = FirebaseStorage.instance.ref();
    final ref = storageRef.child(imageUrl);
    final url = await ref.getDownloadURL();
    imageUrl = url;
    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.9;
    double height = MediaQuery.of(context).size.height * 1 / 10;
    double borderRad = width * 0.03;

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
                              return Image(
                                  width: width * 0.15,
                                  image: NetworkImage(this.imageUrl));
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        )),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                          QuickAlert.show(
                              onConfirmBtnTap: () {
                                updateGP(-this.price, uid, context);
                                Navigator.pop(context);
                              },
                              context: context,
                              type: QuickAlertType.confirm,
                              title: "Purchase confirmation",
                              text: "Do you want to buy this product?",
                              widget: Container(
                                height: height * 1.6,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: width * 0.05),
                                            child: Image(
                                                width: width * 0.2,
                                                image: NetworkImage(
                                                    this.imageUrl))),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              this.brand,
                                              style: TextStyle(
                                                  color:
                                                      const Color(0xff37734D),
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
                                              "Price: " +
                                                  "${this.price}" +
                                                  " GP",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: width * 0.04),
                                            )
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ));

                          // showDialog(
                          //     context: context,
                          //     builder: (context) => AlertDialog(
                          //           title: Row(
                          //             children: [
                          //               const Spacer(),
                          //               const Center(
                          //                   child:
                          //                       Text("Purchase confirmation")),
                          //               new Spacer(),
                          //             ],
                          //           ),
                          //           content: Container(
                          //             height: height * 1.6,
                          //             child: Column(
                          //               children: [
                          //                 Padding(
                          //                   padding: EdgeInsets.only(
                          //                       bottom: width * 0.05),
                          //                   child: const Text(
                          //                       "Are you sure you want to buy this item?"),
                          //                 ),
                          //                 Row(
                          //                   children: [
                          //                     Padding(
                          //                         padding: EdgeInsets.symmetric(
                          //                             horizontal: width * 0.05),
                          //                         child: Image(
                          //                             width: width * 0.2,
                          //                             image: NetworkImage(
                          //                                 this.imageUrl))),
                          //                     Column(
                          //                       mainAxisAlignment:
                          //                           MainAxisAlignment
                          //                               .spaceEvenly,
                          //                       children: [
                          //                         Text(
                          //                           this.brand,
                          //                           style: TextStyle(
                          //                               color: const Color(
                          //                                   0xff37734D),
                          //                               fontWeight:
                          //                                   FontWeight.bold,
                          //                               fontSize: width * 0.05),
                          //                         ),
                          //                         Text(
                          //                           this.itemName,
                          //                           style: TextStyle(
                          //                               color: Colors.black54,
                          //                               fontWeight:
                          //                                   FontWeight.bold,
                          //                               fontSize: width * 0.04),
                          //                         ),
                          //                         Text(
                          //                           "Price: " +
                          //                               "${this.price}" +
                          //                               " GP",
                          //                           style: TextStyle(
                          //                               color: Colors.grey,
                          //                               fontWeight:
                          //                                   FontWeight.normal,
                          //                               fontSize: width * 0.04),
                          //                         )
                          //                       ],
                          //                     )
                          //                   ],
                          //                 )
                          //               ],
                          //             ),
                          //           ),
                          //           actions: [
                          //             TextButton(
                          //                 onPressed: () => {
                          //                       Navigator.pop(context),
                          //                     },
                          //                 child: const Text("Cancel")),
                          //             TextButton(
                          //                 onPressed: () => {
                          //                       Navigator.pop(context),
                          //                       updateGP(-this.price, this.uid,
                          //                           context)
                          //                     },
                          //                 child: const Text("Buy")),
                          //           ],
                          //         ));
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

class Product {
  final String brand;
  final String itemName;
  final int price;
  final String imageUrl;

  const Product(
      {required this.brand,
      required this.itemName,
      required this.price,
      required this.imageUrl});
  static Product fromJSON(Map<String, dynamic> json) => Product(
      brand: json['collaborator'],
      itemName: json['category'],
      price: json['price']['cost'],
      imageUrl: json['image']);
}

class ComponentClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
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

 /********************************************************************************
          *Title: None
          *Author: João Mello
          *Date: Jan 1, 2019
          *Code version: None
          *Availability: https://gist.github.com/multiarts/6d732a5a99278ce359bbf16c005f7c85#file-clipshadowpath-dart (Accessed 17 December, 2022)
          
    *********************************************************************************/

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
