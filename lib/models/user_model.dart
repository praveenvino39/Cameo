// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';
import 'package:get/get.dart';

class User {
  User({
    this.userid,
    this.email,
    this.username,
    this.fullname,
    this.userTimezone,
    this.verified,
    this.status,
    this.city,
    this.address,
    this.zipcode,
    this.langSpeaks,
    this.country,
    this.countryName,
    this.stateId,
    this.stateName,
    this.profession,
    this.professionName,
    this.contact,
    this.description,
    this.userProfileImage,
    this.userThumbImage,
  });

  String userid;
  String email;
  String username;
  String fullname;
  String userTimezone;
  String verified;
  String status;
  String city;
  String address;
  String zipcode;
  String langSpeaks;
  String country;
  String countryName;
  String stateId;
  String stateName;
  String profession;
  String professionName;
  String contact;
  String description;
  dynamic userProfileImage;
  dynamic userThumbImage;

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
        userid: json["userid"],
        email: json["email"],
        username: json["username"],
        fullname: json["fullname"],
        userTimezone: json["user_timezone"],
        verified: json["verified"],
        status: json["status"],
        city: json["city"],
        address: json["address"],
        zipcode: json["zipcode"],
        langSpeaks: json["lang_speaks"],
        country: json["country"],
        countryName: json["country_name"],
        stateId: json["state_id"],
        stateName: json["state_name"],
        profession: json["profession"],
        professionName: json["profession_name"],
        contact: json["contact"],
        description: json["description"],
        userProfileImage: json["user_profile_image"],
        userThumbImage: json["user_thumb_image"],
      );

  Map<String, dynamic> toJson() => {
        "userid": userid,
        "email": email,
        "username": username,
        "fullname": fullname,
        "user_timezone": userTimezone,
        "verified": verified,
        "status": status,
        "city": city,
        "address": address,
        "zipcode": zipcode,
        "lang_speaks": langSpeaks,
        "country": country,
        "country_name": countryName,
        "state_id": stateId,
        "state_name": stateName,
        "profession": profession,
        "profession_name": professionName,
        "contact": contact,
        "description": description,
        "user_profile_image": userProfileImage,
        "user_thumb_image": userThumbImage,
      };
}
