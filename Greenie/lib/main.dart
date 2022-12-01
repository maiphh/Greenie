import 'package:flutter/material.dart';
import 'Login.dart';
import 'Signup.dart';
import 'Welcome.dart';
import 'Login&Signup.dart';
import 'user.dart';
import 'gpShop.dart';
import 'package:bitcointicker/Login&Signup.dart';
import 'Signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'verify.dart';
import 'phone.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      initialRoute: 'welcome',
      routes: {
        'welcome': (context) => const Welcome(),
        'auth': (context) => const LS(),
        'login': (context) => const MyPhone(),
        'signup': (context) => const Signup(),
        'shop': (context) => const GpShop(),
        'pin': (context) => const MyVerify(),
      },
    );
  }
}