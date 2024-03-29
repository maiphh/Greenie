// import 'package:bitcointicker/mystery.dart';
// import 'dart:js';

import 'package:bitcointicker/CollaboratorInput.dart';
import 'package:bitcointicker/home.dart';
import 'package:bitcointicker/qrScanner.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:flutter_notification_channel/notification_visibility.dart';
import 'package:quickalert/quickalert.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
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
import 'game.dart';
import 'mystery.dart';
import 'qr.dart';

final navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // create high notification channel with id 123
  var result = await FlutterNotificationChannel.registerNotificationChannel(
    description: 'A green channel',
    id: '123',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'ChanGreenie',
    visibility: NotificationVisibility.VISIBILITY_PUBLIC,
    allowBubbles: true,
    enableSound: true,
    showBadge: true,
  );
  /********************************************************************************
  *Title: Bug report
  *Author: Repox
  *Date: May 3, 2021
  *Code version: None
  *Availability: https://github.com/firebase/flutterfire/issues/6011 (Accessed 20 December, 2022)
  *********************************************************************************/

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');

  // Store token to database
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Getting the token makes everything work as expected
  await _firebaseMessaging.getToken().then((String? token) {
    print(token);
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message: ${message.data}');

    if (message.notification != null || navigatorKey.currentContext != null) {
      String body = message.notification!.body!;
      String title = message.notification!.title!;

      QuickAlert.show(
          context: navigatorKey.currentContext!,
          title: title,
          text: body,
          type: QuickAlertType.success);
      // showDialog(
      //       context: navigatorKey.currentContext!, // suggests importing dart.js
      //                         // this.context => "invalid reference to 'this' expression"
      //       builder: (_) => AlertDialog(
      //             title: Text(title),
      //             content: Text(body),
      //           ));
      // print('Message also contained a notification: ${message.notification?.body}');
    }
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print("MyApp");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.green, primaryColor: Colors.green),
      initialRoute: 'login',
      routes: {
        'mystery': (context) =>
            const Mystery(uid: "mLOlF0uTBLcwRzzGCdi3RXJ2SSp2"),
        // 'welcome': (context) => const Welcome(),
        'home': (context) => Homepage(uid: "rss0sFQri3gHQFWpKYTegWr0lvb2"),
        'login': (context) => const MyPhone(),
        'signup': (context) => const Signup(),
        'QrScanner': (context) => const QRScanPage(),
        // 'shop': (context) => const GpShop(uid: "bchUjZi23OdRSFWuq0sGMjOfdTn2"),
        'pin': (context) => const MyVerify(),
        'collaboratorInput': (context) =>
            CollaboratorInput(uid: "rss0sFQri3gHQFWpKYTegWr0lvb2"),
        // 'game': (context) => const Game(uid: "rss0sFQri3gHQFWpKYTegWr0lvb2"),
      },
    );
  }
}
