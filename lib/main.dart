import 'dart:io';

import 'package:cameo/Screens/CameoDetailScreen.dart';
import 'package:cameo/Screens/ChatScreen.dart';
import 'package:cameo/Screens/MainScreen.dart';
import 'package:cameo/Screens/SignupScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'Screens/LoginScreen.dart';
import 'Screens/WelcomeScreen.dart';

void main() async {
  HttpOverrides.global = new MyHttpOverrides();
  Function initialWidget;
  WidgetsFlutterBinding.ensureInitialized();
  FlutterSecureStorage storage = FlutterSecureStorage();
  String isLoggedIn = await storage.read(key: "user_id");
  if (isLoggedIn == null)
    initialWidget = (context) => WelcomeScreen();
  else
    initialWidget = (context) => MainScreen();
  runApp(MainActivity(initialWidget));
}

// ignore: must_be_immutable
class MainActivity extends StatefulWidget {
  Function initialWidget;
  MainActivity(Function initialWidget) {
    this.initialWidget = initialWidget;
  }
  @override
  _MainActivityState createState() {
    return _MainActivityState();
  }
}

class _MainActivityState extends State<MainActivity> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:
          ThemeData(primaryColor: Color(0xff101010), accentColor: Colors.white),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': widget.initialWidget,
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => MainScreen(),
        '/detail': (context) => CameoDetailScreen(),
        '/chat': (context) => ChatScreen(),
        // '/profile': (context) => EditUserProfileScreen(),
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
