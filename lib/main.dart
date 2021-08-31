import 'dart:io';
import 'package:cameo/Network/networkHelper.dart';
import 'package:cameo/Screens/CameoDetailScreen.dart';
import 'package:cameo/Screens/ChatScreen.dart';
import 'package:cameo/Screens/MainScreen.dart';
import 'package:cameo/Screens/MessageScreen.dart';
import 'package:cameo/Screens/NotificationScreen.dart';
import 'package:cameo/Screens/SignupScreen.dart';
import 'package:cameo/constants.dart';
import 'package:cameo/models/notification_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'Screens/LoginScreen.dart';
import 'Screens/WelcomeScreen.dart';
import 'models/payment_credential.dart';
import 'models/user_model.dart';

void main() async {
  HttpOverrides.global = new MyHttpOverrides();
  Function initialWidget;
  ApiHelper apiHelper = ApiHelper();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterSecureStorage storage = FlutterSecureStorage();
  String isLoggedIn = await storage.read(key: "user_id");
  if (isLoggedIn == null)
    initialWidget = (context) => WelcomeScreen();
  else {
    var userJson = await apiHelper.userDetiail(isLoggedIn);
    Get.put(User.fromJson(userJson[0]));
    Get.put<PaymentCredential>(PaymentCredential(
        paypalClientId: userJson[5]["paypal_id"]["publishable"],
        paypalSecretId: userJson[5]["paypal_id"]["secret"],
        stripePublishableKey: userJson[4]["stripe_publishable"],
        stripeSecretKey: userJson[4]["stripe_secret"]));
    NotificationList notificationList = await apiHelper.notification();
    Get.put(notificationList);
    initialWidget = (context) => MainScreen();
  }

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
    return GetMaterialApp(
        theme: ThemeData(
            primaryColor: Color(0xff101010),
            accentColor: Colors.white,
            unselectedWidgetColor: kSecondaryColor,
            primarySwatch: Colors.pink),
        debugShowCheckedModeBanner: false,
        navigatorObservers: [
          ClearFocusOnPop()
        ],
        routes: {
          '/': widget.initialWidget,
          '/welcome': (context) => WelcomeScreen(),
          '/login': (context) => LoginScreen(),
          '/signup': (context) => SignupScreen(),
          '/home': (context) => MainScreen(),
          '/detail': (context) => CameoDetailScreen(),
          '/chat': (context) => ChatScreen(),
          '/notification': (context) => NotificationScreen(),
          '/messages': (context) => MessagesScreen()
        });
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

class ClearFocusOnPop extends NavigatorObserver {
  @override
  void didPop(Route route, Route previousRoute) {
    super.didPop(route, previousRoute);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration.zero);
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    });
  }
}
