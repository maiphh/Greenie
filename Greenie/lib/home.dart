import 'package:bitcointicker/game.dart';
import 'package:bitcointicker/gpShop.dart';
import 'package:bitcointicker/qr.dart';
import 'package:bitcointicker/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_border/dotted_border.dart';
import "game.dart";

String userName = "";
int balance = 0;
String currency = "GP";
int treesPlanted = 0;
Future getData(String uid) async {
  final docUser = FirebaseFirestore.instance.collection("userProfile").doc(uid);
  var data = await docUser.get();
  balance = data['GP'];
  userName = data['name'];

  var gameId = await getInventoryID(uid);
  final docTrees =
      FirebaseFirestore.instance.collection("gameInventory").doc(gameId);
  var treeData = await docTrees.get();

  treesPlanted = treeData["items"].length;
}

Icon normalNotificationIcon = const Icon(Icons.notifications_none_outlined);
Icon shoppingCartIcon = const Icon(
  Icons.shopping_cart_outlined,
  color: Color(0xFF7BC143),
);
Icon scanIcon = const Icon(
  Icons.qr_code_scanner_outlined,
  color: Color(0xFF7BC143),
);
Icon personIcon = const Icon(
  Icons.person_outline,
  color: Color(0xFF7BC143),
);
String assetImagesDir = "lib/assets";
List<AssetImage> itemImages = [
  AssetImage("$assetImagesDir/logo-starbucks-1992.png"),
  AssetImage("$assetImagesDir/Highlands_Coffee_logo.svg.png"),
  AssetImage("$assetImagesDir/logo-katinat-text.webp"),
  AssetImage("$assetImagesDir/logo-phuc-long-coffee-and-tea.webp")
];

class Homepage extends StatefulWidget {
  String uid;

  Homepage({super.key, required this.uid});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        FutureBuilder(
            future: getData(widget.uid),
            builder: ((context, snapshot) {
              return Content(uid: this.widget.uid);
            })),
      ]),
      bottomNavigationBar: BottomNavBar(
        uid: this.widget.uid,
        currentIndex: 0,
      ),
    );
  }
}

class Content extends StatelessWidget {
  String uid;
  Content({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 30, right: 30, top: 40),
      child: Container(
        height: 1000,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            GreetingAndNotification(),
            StatusPad(
              uid: this.uid,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: Text(
                "Collaborators",
                style: TextStyle(
                    color: Colors.green[700],
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
            ItemList(),
          ],
        ),
      ),
    );
  }
}

class ItemList extends StatefulWidget {
  const ItemList({super.key});

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  @override
  Widget build(BuildContext context) {
    List<Item> itemList = [];
    for (int i = 0; i < itemImages.length; i++) {
      itemList.add(Item(itemImages[i]));
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      height: 300,
      child: ListView(
        // padding: EdgeInsets.only(left: 20),

        scrollDirection: Axis.horizontal,
        children: itemList,
      ),
    );
  }
}

class Item extends StatelessWidget {
  final AssetImage itemImage;
  Item(this.itemImage, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(right: 20),
        width: 200,
        height: 300,
        decoration: BoxDecoration(
            image: DecorationImage(image: itemImage),
            gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFBFCFE), Color(0xFFE4E4E5)]),
            borderRadius: const BorderRadius.all(Radius.circular(10)) //
            ));
  }
}

class StatusPad extends StatelessWidget {
  String uid;
  StatusPad({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 380,
        height: 210,
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
            // backgroundBlendMode: BlendMode.hardLight,
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment(0.99, 3),
                colors: <Color>[Color(0xFF0E4123), Color(0xFF94E7AE)]),
            image: const DecorationImage(
                alignment: Alignment.centerRight,
                image: AssetImage("lib/assets/tree_background.png"))),
        child: FutureBuilder(
          future: getData(this.uid),
          builder: (context, snapshot) {
            return StatusPadContent(uid: this.uid);
          },
        ));
  }
}

class StatusPadContent extends StatelessWidget {
  String uid;
  StatusPadContent({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "$balance $currency",
            textAlign: TextAlign.left,
            style: GoogleFonts.workSans(
                textStyle: TextStyle(fontSize: 45, fontWeight: FontWeight.w600),
                color: Colors.white),
          ),
          Text(
            "Have been saved!",
            style: TextStyle(fontFamily: "Work Sans", color: Colors.white),
          ),
          DottedBorder(
              padding: EdgeInsets.all(9),
              borderType: BorderType.RRect,
              radius: Radius.circular(8),
              dashPattern: [9, 6],
              color: Colors.white,
              child: Container(
                  child: Text(
                "$treesPlanted trees have been planted",
                style: const TextStyle(
                    color: Colors.white, fontFamily: "Work Sans", fontSize: 12),
              )))
        ],
      ),
    );
  }
}

class GreetingAndNotification extends StatelessWidget {
  const GreetingAndNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Hi $userName,",
          style: GoogleFonts.workSans(
              textStyle: TextStyle(
                  color: Colors.green[700],
                  fontSize: 18,
                  fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}

class BottomNavBar extends StatefulWidget {
  String uid;
  int currentIndex;
  BottomNavBar({super.key, required this.uid, required this.currentIndex});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  // setBottomBarIndex(index) {
  //   setState(() {
  //     currentIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          width: size.width,
          height: 80,
          child: Stack(
            // overflow: Overflow.visible,
            children: [
              CustomPaint(
                size: Size(size.width, 80),
                painter: BNBCustomPainter(),
              ),
              Center(
                heightFactor: 0.3,
                child: FloatingActionButton(
                    backgroundColor: Colors.lightGreen,
                    elevation: 0.1,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Game(uid: widget.uid),
                          ));
                    },
                    child: const ImageIcon(
                      AssetImage("lib/assets/nav_globe.png"),
                      size: 90,
                      color: Color.fromARGB(255, 33, 103, 36),
                    )),
              ),
              Container(
                width: size.width,
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.home_outlined,
                        color: widget.currentIndex == 0
                            ? Color(0xFF7BC143)
                            : Colors.grey.shade400,
                      ),
                      onPressed: () {
                        // setBottomBarIndex(0);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Homepage(uid: widget.uid),
                            ));
                      },
                      splashColor: Colors.white,
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.qr_code_scanner_outlined,
                          color: widget.currentIndex == 1
                              ? Color(0xFF7BC143)
                              : Colors.grey.shade400,
                        ),
                        onPressed: () {
                          // setBottomBarIndex(1);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Qr(uid: widget.uid),
                              ));
                        }),
                    Container(
                      width: size.width * 0.20,
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.shopping_cart_outlined,
                          color: widget.currentIndex == 2
                              ? Color(0xFF7BC143)
                              : Colors.grey.shade400,
                        ),
                        onPressed: () {
                          // setBottomBarIndex(2);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GpShop(uid: widget.uid),
                              ));
                        }),
                    IconButton(
                        icon: Icon(
                          Icons.person_outlined,
                          color: widget.currentIndex == 3
                              ? Color(0xFF7BC143)
                              : Colors.grey.shade400,
                        ),
                        onPressed: () {
                          // setBottomBarIndex(3);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    UserProfile(uid: widget.uid),
                              ));
                        }),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 20); // Start
    path.quadraticBezierTo(size.width * 0, 0, size.width * 0.08, 0);
    // path.moveTo(size.width * 0.3, 0);
    path.quadraticBezierTo(size.width * 0.25, 0, size.width * 0.30, 0);
    path.quadraticBezierTo(size.width * 0.37, 0, size.width * 0.40, 20);
    // path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);

    path.arcToPoint(Offset(size.width * 0.60, 20),
        radius: Radius.circular(43.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.63, 0, size.width * 0.70, 0);
    path.quadraticBezierTo(size.width * 0.63, 0, size.width * 0.92, 0);
    path.quadraticBezierTo(size.width, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    // canvas.drawShadow(path, Colors.black, 1000000, false);
    canvas.drawShadow(path, Colors.black, 10, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
