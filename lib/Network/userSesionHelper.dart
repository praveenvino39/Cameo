import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSession {
  FlutterSecureStorage _storage = FlutterSecureStorage();
  void presistUser({String token, String username}) async {
    await _storage.write(key: "user_id", value: token);
    await _storage.write(key: "username", value: username);
  }

  Future<String> getCurrentUserId() async {
    return await _storage.read(key: "user_id");
  }

  Future<String> getCurrentUserUsername() async {
    return await _storage.read(key: "username");
  }

  dynamic isLoggedIn() {
    _storage.read(key: "user_id").then((value) {
      print(value);
      if (value == null)
        return false;
      else
        return true;
    });
  }

  void redirectLoggedInUser(context) {
    FlutterSecureStorage storage = FlutterSecureStorage();
    storage.read(key: "user_id").then(
          (value) => {
            value != null
                ? {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/home', (route) => false)
                  }
                : null
          },
        );
  }
}
