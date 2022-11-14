import 'package:flutter/material.dart';
import 'Login&Signup.dart';

class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("lib/assets/Welcome.png"), fit: BoxFit.cover),
      ),
      child: Column(children: [
        const SizedBox(height: 640),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 100.0, vertical: 15),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const LS()));
          },
          child: const Text(
            'Start Saving',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ]),
    );
  }
}
