import 'package:bitcointicker/game.dart';
import 'package:bitcointicker/gpShop.dart';
import 'package:bitcointicker/qr.dart';
import 'package:bitcointicker/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_border/dotted_border.dart';

String userName = "quangrmit";
double balance = 15.99;
String currency = "GP";
int treesPlanted = 13;
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
String assetImagesDir = "assets/images";
List<AssetImage> itemImages = [
  AssetImage("$assetImagesDir/item1.png"),
  AssetImage("$assetImagesDir/item2.png")
];

class Homepage extends StatelessWidget {
  String uid;
  Homepage({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: const [
        Content(),
      ]),
      bottomNavigationBar: BottomNavBar(uid: this.uid),
    );
  }
}

class Content extends StatelessWidget {
  const Content({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 30, right: 30, top: 40),
      child: Container(
        height: 1000,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: const [
            GreetingAndNotification(),
            StatusPad(),
            ItemList(),
            History()
          ],
        ),
      ),
    );
  }
}

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: ListView(
        // primary: false,
        shrinkWrap: true,

        scrollDirection: Axis.vertical,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            height: 40,
            color: Colors.greenAccent,
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            height: 40,
            color: Colors.greenAccent,
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            height: 40,
            color: Colors.greenAccent,
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            height: 40,
            color: Colors.greenAccent,
          ),
        ],
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
      height: 230,
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
        width: 180,
        // height: 100,
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
  const StatusPad({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 380,
        height: 180,
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
                image: AssetImage('assets/images/tree_background.png'))),
        child: const StatusPadContent());
  }
}

class StatusPadContent extends StatelessWidget {
  const StatusPadContent({super.key});

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
              textStyle: const TextStyle(
                  color: Color(0xFF51C57D),
                  fontSize: 18,
                  fontWeight: FontWeight.w600)),
        ),
        Transform.scale(
            scale: 1.25,
            child: IconButton(
              onPressed: () {},
              icon: normalNotificationIcon,
            ))
      ],
    );
  }
}

class BottomNavBar extends StatefulWidget {
  String uid;
  BottomNavBar({super.key, required this.uid});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 0;

  setBottomBarIndex(index) {
    setState(() {
      currentIndex = index;
    });
  }

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
                      size: 50,
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
                        color: currentIndex == 0
                            ? Color(0xFF7BC143)
                            : Colors.grey.shade400,
                      ),
                      onPressed: () {
                        setBottomBarIndex(0);
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
                          color: currentIndex == 1
                              ? Color(0xFF7BC143)
                              : Colors.grey.shade400,
                        ),
                        onPressed: () {
                          setBottomBarIndex(1);
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
                          color: currentIndex == 2
                              ? Color(0xFF7BC143)
                              : Colors.grey.shade400,
                        ),
                        onPressed: () {
                          setBottomBarIndex(2);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GpShop(uid: widget.uid),
                              ));
                        }),
                    IconButton(
                        icon: Icon(
                          Icons.person_outlined,
                          color: currentIndex == 3
                              ? Color(0xFF7BC143)
                              : Colors.grey.shade400,
                        ),
                        onPressed: () {
                          setBottomBarIndex(3);
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
