import 'dart:convert';
import 'dart:io' as os;

import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

// http://ec2-54-189-124-142.us-west-2.compute.amazonaws.com/
const baseUrl = 'http://ec2-54-189-124-142.us-west-2.compute.amazonaws.com/api';
const domainUrl = 'http://ec2-54-189-124-142.us-west-2.compute.amazonaws.com';

const endPoints = {
  //authentication and authorization
  "country": '/user/country',
  "state": '/user/state',
  "login": '/user/login',
  "registration": '/user/registration',

  //Homescreen
  "popular": '/gigs/popularGigs',
  "latest": '/gigs/latestGigs',
  "charity": '/charity',
  "new": '/new',
  "category": '/category',
  "musician": '/musician',
  "cameo_detail": '/gigs/gigs_details',
  'buy_cameo': '/gigs/buy_gigs/',

  // user
  "user_detail": '/user/selluser_details/',
  "update_user_detail": '/user/user_details/',
  "password_update": '/user/change_password',
  "payment_detail": "/user/bank_details/",
  "update_payment": "/user/bank_details/",
  "my_cameo": '/gigs/gigs_list/',
  //Activity
  "activities": "/gigs/my_gig_activity/",
  "upload_file": "/gigs/my_upload",

  //Add Cameo
  "add_cameo": '/gigs/add_gigs',

  //order
  "order_status": "/gigs/sale_order_status",
  "order_status_buyer": "/gigs/change_gigs_status",
  "delete_video": '/gigs/update_video/',
  "upload_video": "/gigs/video_upload"
};

class ApiHelper {
  Future<http.Response> login(user) async {
    print('calling: $baseUrl${endPoints["login"]}');
    http.Response response =
        await http.post('$baseUrl${endPoints["login"]}', body: user);
    return response;
  }

  Future<List> countryJson() async {
    print('calling: $baseUrl${endPoints["country"]}');
    http.Response response = await http.get('$baseUrl${endPoints["country"]}');
    var data = jsonDecode(response.body);
    return data;
  }

  Future<http.Response> country() async {
    print('calling: $baseUrl${endPoints["country"]}');
    http.Response response = await http.get('$baseUrl${endPoints["country"]}');
    return response;
  }

  Future<http.Response> state(int countryId) async {
    print('calling: $baseUrl${endPoints["state"]}/$countryId');
    http.Response response =
        await http.get('$baseUrl${endPoints["state"]}/$countryId');
    return response;
  }

  Future<http.Response> registration(Map<String, String> user) async {
    print('calling: $baseUrl${endPoints["regitration"]} $user');
    http.Response response =
        await http.post('$baseUrl${endPoints["registration"]}', body: user);
    return response;
  }

//Poplular Cameos
  Future<List> popularCameos() async {
    print('calling: $baseUrl${endPoints["popular"]}');
    http.Response response = await http.get('$baseUrl${endPoints["popular"]}');
    var data = jsonDecode(response.body);
    return data["primary"];
  }

//Latest Cameos
  Future<List> latestCameo() async {
    print('calling: $baseUrl${endPoints["latest"]}');
    http.Response response = await http.get('$baseUrl${endPoints["latest"]}');
    var data = jsonDecode(response.body);
    return data["primary"];
  }

//Get Specific Detail
  Future<Map> cameoDetail(id) async {
    var userId = await FlutterSecureStorage().read(key: "user_id");
    print('calling: $baseUrl${endPoints["cameo_detail"]}');
    http.Response response = await http.post(
        '$baseUrl${endPoints["cameo_detail"]}',
        body: {"gig_id": id.toString(), "user_id": userId.toString()});
    Map data = jsonDecode(response.body);
    return data;
  }

  //Get User detail
  Future<List> userDetiail(id) async {
    print('calling: $baseUrl${endPoints["user_detail"]}$id');
    http.Response response =
        await http.get('$baseUrl${endPoints["user_detail"]}$id');
    Map data = jsonDecode(response.body);
    return data["message"];
  }

  Future<bool> updateUserDetail(
      {id,
      GlobalKey<ScaffoldState> scaffoldKey,
      profession,
      fullname,
      description,
      phone,
      language,
      country,
      state,
      zipcode,
      city,
      address}) async {
    var body = {
      "fullname": fullname,
      "profession": profession,
      "description": description,
      "lang_speaks": language,
      "zipcode": zipcode,
      "contact": phone,
      "state": state,
      "country": country,
      "city": city,
      "address": address
    };
    try {
      dio.Response response = await dio.Dio().post(
        '$baseUrl${endPoints['update_user_detail']}$id',
        data: body,
      );
      print(response.data);
      return response.data["message"] == 'SUCCESS' ? true : false;
    } catch (e) {
      scaffoldKey.currentState.removeCurrentSnackBar();
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
            "Something went wrong, Please check your internet connection."),
      ));
    }
  }

  Future<Map> updatePassword(
      {String currentPassword, String newPassword}) async {
    var userId = await FlutterSecureStorage().read(key: "user_id");
    var body = {
      "current_password": currentPassword,
      "new_password": newPassword,
      "id": userId
    };
    try {
      dio.Response response = await dio.Dio().post(
        '$baseUrl${endPoints["password_update"]}',
        data: body,
      );
      return response.data;
    } catch (e) {
      print("password mismatch");
    }
  }

  Future<List> getPaymentDetail() async {
    var userId = await FlutterSecureStorage().read(key: "user_id");
    try {
      dio.Response response = await dio.Dio().get(
        '$baseUrl${endPoints["payment_detail"]}$userId',
      );
      return response.data["message"];
    } catch (e) {
      print("password mismatch");
    }
  }

  Future<Map> updatePayment(
      {paypalEmail,
      accountNumber,
      accountHoldersName,
      iban,
      bankName,
      bankAddress,
      shortCode,
      routingNumber,
      ifsc}) async {
    var userId = await FlutterSecureStorage().read(key: "user_id");
    var body = {
      "bank_account": {"paypal_email_id": paypalEmail},
      "stripe_bank_details": {
        "account_holder_name": accountHoldersName,
        "account_number": accountNumber,
        "account_iban": iban,
        "bank_name": bankName,
        "bank_address": bankAddress,
        "sort_code": shortCode,
        "routing_number": routingNumber,
        "account_ifsc": ifsc
      },
      "user_id": userId
    };
    try {
      dio.Response response = await dio.Dio().post(
        '$baseUrl${endPoints["update_payment"]}',
        data: json.encode(body),
        options: dio.Options(headers: {
          os.HttpHeaders.contentTypeHeader: "application/json",
        }),
      );
      return response.data;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<Map> activities() async {
    var userId = await FlutterSecureStorage().read(key: "user_id");
    try {
      dio.Response response =
          await dio.Dio().get('$baseUrl${endPoints["activities"]}$userId');
      return response.data["data"];
    } catch (e) {
      print(e.toString());
    }
  }

  Future<Map> uploadProduct({
    PlatformFile file,
    sellerId,
    buyerId,
    orderId,
    gigId,
  }) async {
    http.MultipartRequest request = http.MultipartRequest(
      'POST',
      Uri.parse("$baseUrl${endPoints["upload_file"]}"),
    );
    Map<String, String> headers = {"Content-type": "multipart/form-data"};
    request.files.add(
      await http.MultipartFile.fromPath("product_upload", file.path),
    );
    request.headers.addAll(headers);
    request.fields.addAll({
      "gig_id": gigId,
      "order_id": orderId,
      "seller_id": sellerId,
      "buyer_id": buyerId,
    });
    var res = await request.send();
    Map data = jsonDecode(await res.stream.bytesToString());
    return data;
  }

  Future<List> getFiles({String getby}) async {
    // print(getby);
    var userId = await FlutterSecureStorage().read(key: "user_id");
    http.Response response =
        await http.get('$baseUrl/gigs/my_files/$userId?send=$getby');
    print('$baseUrl/gigs/my_files/$userId?send=$getby');
    Map data = jsonDecode(response.body);
    return data["data"];
  }

  Future<Map> postCameo(
    context,
    scaffoldState, {
    String tags,
    String title,
    int gigPrice,
    int deliveryTime,
    int categoryId,
    img,
    vid,
    String gigDetails,
    String youtubeUrl,
    String vimeoUrl,
  }) async {
    var imageArray = img.path;
    int splitIndex = img.path.lastIndexOf('/');
    imageArray = imageArray.substring(splitIndex + 1);
    try {
      int startIndex = vimeoUrl.lastIndexOf('/') + 1;
      int vimeoId = int.parse(vimeoUrl.substring(startIndex));
      var userId = await FlutterSecureStorage().read(key: "user_id");
      http.MultipartRequest request = http.MultipartRequest(
        'POST',
        Uri.parse("$baseUrl${endPoints["add_cameo"]}"),
      );
      Map<String, String> headers = {"Content-type": "multipart/form-data"};
      request.files.add(
        await http.MultipartFile.fromPath("gig_image", img.path),
      );
      request.files.add(
        await http.MultipartFile.fromPath("gig_video", vid.path),
      );

      request.headers.addAll(headers);
      request.fields.addAll({
        "user_id": userId,
        "gig_tags": tags,
        "title": title,
        "gig_price": gigPrice.toString(),
        "time_zone": "Asia/Kolkata",
        "delivering_time": deliveryTime.toString(),
        "category_id": 4.toString(),
        "gig_details": gigDetails,
        "currency_type": "USD",
        "youtube_url": youtubeUrl,
        "vimeo_url": vimeoUrl,
        "vimeo_video_id": vimeoId.toString(),
        "image_array": imageArray,
        "video_array": "1.mp4",
        "full_country_name": "11",
      });
      var res = await request.send();
      Map data = jsonDecode(await res.stream.bytesToString());
      print(data);
      return data;
    } catch (e) {
      Navigator.pop(context);
      scaffoldState.currentState.showSnackBar(
        SnackBar(
          content: Text("Please enter valid vimeo url"),
        ),
      );
    }
  }

  Future<List> searchCameo({searchQuery}) async {
    http.Response response =
        await http.get('$baseUrl/gigs/search/$searchQuery');
    var data = jsonDecode(response.body);
    print(data);
    return data["data"];
  }

  Future<List> getConversation() async {
    var userId = await FlutterSecureStorage().read(key: "user_id");
    http.Response response =
        await http.get("$baseUrl/gigs/all_chats_user/$userId");
    var data = jsonDecode(response.body);
    return data['data'];
  }
  // http://localhost/api/gigs/all_new_chats/1?from=chat_id

  Future<Map> getMessages({id}) async {
    var userId = await FlutterSecureStorage().read(key: "user_id");
    http.Response response =
        await http.get("$baseUrl/gigs/all_new_chats/$userId?from=$id");
    var data = jsonDecode(response.body);
    return {'data': data['data'], 'current_user_id': userId.toString()};
    // print(response.body);
  }

  Future<Map> sendMessage({receiverId, message}) async {
    var senderId = await FlutterSecureStorage().read(key: "user_id");
    http.Response response = await http.post("$baseUrl/gigs/buyer_chat", body: {
      "sell_gigs_userid": receiverId.toString(),
      "user_id": senderId.toString(),
      "chat_message_content": message.toString()
    });
    var data = jsonDecode(response.body);
    return data;
  }

  Future<Map> changeOrderStatus({
    orderStatus,
    orderId,
  }) async {
    http.Response response =
        await http.post("$baseUrl${endPoints['order_status']}", body: {
      "order_id": orderId.toString(),
      "order_status": orderStatus.toString(),
      "time_zone": "Asia/Kolkata"
    });
    var data = jsonDecode(response.body);
    return data;
  }

  Future<Map> changeOrderStatusBuyer({orderId, orderStatus}) async {
    http.Response response =
        await http.post("$baseUrl${endPoints['order_status_buyer']}", body: {
      "payment_id": orderId.toString(),
      "status": orderStatus.toString(),
      "time_zone": "Asia/Kolkata"
    });
    var data = jsonDecode(response.body);
    if (data["message"] == "SUCCESS") {
      return data;
    }
  }

  Future<List> myCameo() async {
    var userId = await FlutterSecureStorage().read(key: "user_id");
    print('$baseUrl${endPoints["my_cameo"]}$userId');
    http.Response response =
        await http.get('$baseUrl${endPoints["my_cameo"]}$userId');
    var data = jsonDecode(response.body);
    if (data["message"] == "SUCCESS") {
      return data["data"];
    }
  }

  Future<Map> updateCameo(
      {String tags,
      String title,
      int gigPrice,
      int deliveryTime,
      int categoryId,
      img,
      vid,
      String gigDetails,
      String youtubeUrl,
      String vimeoUrl,
      String imageArray,
      String gigId}) async {
    print(
        "$tags $title $gigPrice $deliveryTime $categoryId $youtubeUrl $vimeoUrl $imageArray $gigId");
    int startIndex = vimeoUrl.lastIndexOf('/') + 1;
    int vimeoId = int.parse(vimeoUrl.substring(startIndex));
    var userId = await FlutterSecureStorage().read(key: "user_id");
    http.MultipartRequest request = http.MultipartRequest(
      'POST',
      Uri.parse("$baseUrl${endPoints["add_cameo"]}"),
    );
    Map<String, String> headers = {"Content-type": "multipart/form-data"};
    if (img != null) {
      request.files.add(
        await http.MultipartFile.fromPath("gig_image", img.path),
      );
    }

    request.headers.addAll(headers);
    request.fields.addAll({
      "user_id": userId,
      "gig_tags": tags,
      "title": title,
      "gig_price": gigPrice.toString(),
      "time_zone": "Asia/Kolkata",
      "delivering_time": deliveryTime.toString(),
      "category_id": 4.toString(),
      "gig_details": gigDetails,
      "currency_type": "USD",
      "youtube_url": youtubeUrl,
      "vimeo_url": vimeoUrl,
      "vimeo_video_id": vimeoId.toString(),
      "image_array": imageArray,
      "full_country_name": "11",
      "update_gig_id": gigId
    });
    var res = await request.send();
    var data = await res.stream.bytesToString();
    Map convertedData = jsonDecode(data);
    return convertedData;
    // Map data = jsonDecode(await res.stream.bytesToString());
    // return data;
  }

  Future<List> buyCameo() async {
    var userId = await FlutterSecureStorage().read(key: "user_id");
    http.Response response =
        await http.get('$baseUrl${endPoints["buy_cameo"]}$userId');
    var data = jsonDecode(response.body);
    return data["data"];
  }

  Future<void> deleteVideo({String videoPath, gig_id}) async {
    print('$baseUrl${endPoints["delete_video"]}$gig_id?video=$videoPath');
    http.Response response = await http
        .get('$baseUrl${endPoints["delete_video"]}$gig_id?video=$videoPath');
    var data = jsonDecode(response.body);
    // return data["data"];
    print(data);
    //  /gigs/update_video/86?video=uploads/gigs_videos/1614349951SampleVideo_1280x720_1mb.mp4
  }

  Future<Map> uploadVideo({FilePickerResult vid, String gigId}) async {
    var videoArray = vid.files.first.path;
    int splitIndex = vid.files.first.path.lastIndexOf('/');
    videoArray = videoArray.substring(splitIndex + 1);
    print(vid.files.first.path);
    print(videoArray);
    http.MultipartRequest request = http.MultipartRequest(
      'POST',
      Uri.parse("$baseUrl${endPoints["upload_video"]}"),
    );
    Map<String, String> headers = {"Content-type": "multipart/form-data"};
    if (vid != null) {
      request.files.add(
        await http.MultipartFile.fromPath("gig_video", vid.files.first.path),
      );
    }

    request.headers.addAll(headers);
    request.fields.addAll({"video_array": videoArray, "update_gig_id": gigId});
    var res = await request.send();
    var data = await res.stream.bytesToString();
    // Map convertedData = jsonDecode(data);
    print(data);
    // return data;
  }
}
