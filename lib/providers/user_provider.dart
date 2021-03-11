import 'package:cameo/models/user_model.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  User currentUser;

  User get() {
    return currentUser;
  }

  void set(
      {String userId,
      String email,
      String username,
      String fullname,
      bool verified,
      bool status,
      String contact,
      String description,
      String profession,
      String language,
      String address,
      String country,
      String zipcode,
      String city}) {
    this.currentUser = User(
        userId: userId,
        email: email,
        username: username,
        fullname: fullname,
        verified: verified,
        status: status,
        contact: contact,
        description: description,
        address: address,
        profession: profession,
        language: language,
        country: country,
        zipcode: zipcode,
        city: city);
  }
}
