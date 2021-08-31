import 'dart:convert';
import 'dart:developer';

import 'package:cameo/Network/networkHelper.dart';
import 'package:cameo/Screens/MainScreen.dart';
import 'package:cameo/Screens/WelcomeScreen.dart';
import 'package:cameo/models/notification_model.dart';
import 'package:cameo/models/payment_credential.dart';
import 'package:cameo/models/user_model.dart' as model;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class OauthHelper {
  FirebaseAuth _firebaseAuth;
  UserCredential _user;

  OauthHelper() {
    _firebaseAuth = FirebaseAuth.instance;
  }

  Future<bool> signInGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
      ],
    );
    try {
      GoogleSignInAccount account = await _googleSignIn.signIn();
      String email = account.email;
      String googleId = account.id;
      String photoUrl = account.photoUrl;
      print("${account.displayName}  $email  $googleId  $photoUrl");
      var user = {
        "profileid": account.id,
        "fullname": account.displayName,
        "profileurl": account.photoUrl,
        "email": account.email,
        "auth": "Google",
        "firstname": account.displayName
      };
      ApiHelper apiHelper = ApiHelper();
      http.Response response = await apiHelper.login(user);
      var data = jsonDecode(response.body);
      if (data["status"] == true) {
        await FlutterSecureStorage()
            .write(key: "user_id", value: data["data"][0]["userid"]);
        var user = await apiHelper.userDetiail(data["data"][0]["userid"]);
        Get.delete<model.User>();
        Get.put(model.User.fromJson(user[0]));
        NotificationList notificationList = await apiHelper.notification();
        Get.put(notificationList);
        Get.put<PaymentCredential>(PaymentCredential(
            paypalClientId: user[5]["paypal_id"]["publishable"],
            paypalSecretId: user[5]["paypal_id"]["secret"],
            stripePublishableKey: user[4]["stripe_publishable"],
            stripeSecretKey: user[4]["stripe_secret"]));
        Get.offAll(MainScreen());
      } else {
        Get.snackbar("Error", "Field missing try with email login",
            snackPosition: SnackPosition.BOTTOM,
            padding: EdgeInsets.all(0),
            backgroundColor: Colors.white,
            colorText: Colors.black);
      }

      return true;
    } on PlatformException catch (e) {
      log(e.toString());
      return false;
    }
  }

  void signOutGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: ['email'],
    );
    await _googleSignIn.signOut();
    print("Logged out");
  }
}
