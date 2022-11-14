import 'package:flutter/material.dart';
import 'Login.dart';
import 'Signup.dart';
import 'Welcome.dart';
import 'Login&Signup.dart';
import 'user.dart';
import 'gpShop.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const Welcome(),
    );
  }
}
