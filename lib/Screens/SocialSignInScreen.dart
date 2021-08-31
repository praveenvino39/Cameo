import 'package:cameo/Network/oauth_helper.dart';
import 'package:cameo/Widgets/CustomAppBar.dart';
import 'package:cameo/Widgets/Loading%20Indicators/LoadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visa/engine/simple-auth.dart';
import 'package:visa/fb.dart';
import 'package:visa/google.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SocialSignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Center(
          child: Column(
            children: [
              RaisedButton(
                onPressed: () async {
                  GoogleSignInApi.login();
                },
                child: Text("Hello World"),
              ),
              RaisedButton(
                onPressed: () async {
                  GoogleSignInApi.logout();
                },
                child: Text("Hello World"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class GoogleSignInApi {
  static final _googleSignIn = GoogleSignIn();
  static Future login() async {
    print(await _googleSignIn.signIn());
  }

  static Future logout() {
    _googleSignIn.signOut();
  }
}
