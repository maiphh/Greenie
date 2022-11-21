import 'package:flutter/material.dart';

class GpShop extends StatefulWidget {
  const GpShop({Key? key}) : super(key: key);

  @override
  State<GpShop> createState() => _GpShopState();
}

class _GpShopState extends State<GpShop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 45,
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xffDBDCDF),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      borderSide: BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      borderSide: BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    labelText: 'Search',
                    labelStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Voucher",
                style: TextStyle(
                    color: Color(0xff37734D),
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              const SizedBox(height: 10),
              voucher('lib/assets/4.png', 'Starbucks', 'Discount 5\$', '500'),
              voucher('lib/assets/4.png', 'Highlands', 'Discount 7\$', '750'),
              const SizedBox(height: 30),
              const Text(
                "Item",
                style: TextStyle(
                    color: Color(0xff37734D),
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              const SizedBox(height: 10),
              item('lib/assets/bottle green 2.png', "Bottle", "Greenie Bottle",
                  '700')
            ],
          ),
        ),
      ),
    );
  }

  Stack voucher(image, brand, value, price) {
    return Stack(
      children: [
        const Image(image: AssetImage('lib/assets/voucher.png')),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: Image(
                  image: AssetImage(image),
                  width: 55,
                  height: 55,
                ),
              ),
            ),
            const SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  brand,
                  style: const TextStyle(
                      color: Color(0xff37734D),
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
                Text(
                  value,
                  style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                const SizedBox(height: 5),
                Text(
                  "Price: " + price + " GP",
                  style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      fontSize: 12),
                ),
              ],
            ),
            const SizedBox(width: 122),
            TextButton(
              onPressed: () {},
              child: const Text("Buy"),
            )
          ],
        )
      ],
    );
  }

  Stack item(image, brand, value, price) {
    return Stack(
      children: [
        const Image(image: AssetImage('lib/assets/item.png')),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: Image(
                  image: AssetImage(image),
                  width: 55,
                  height: 70,
                ),
              ),
            ),
            const SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  brand,
                  style: const TextStyle(
                      color: Color(0xff37734D),
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
                Text(
                  value,
                  style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                const SizedBox(height: 10),
                Text(
                  "Price: " + price + " GP",
                  style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      fontSize: 12),
                ),
              ],
            ),
            const SizedBox(width: 109),
            TextButton(
              onPressed: () {},
              child: const Text("Buy"),
            )
          ],
        )
      ],
    );
  }
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

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return Container();
  }
}

// appBar: AppBar(
// title: const Text("Search"),
// actions: [
// IconButton(
// onPressed: () {
// showSearch(context: context, delegate: MySearchDelegate());
// },
// icon: const Icon(Icons.search),
// ),
// ],
// ),
