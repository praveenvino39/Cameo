import 'dart:convert';
import 'dart:developer';
import 'dart:io' as os;

import 'package:cameo/Network/PaypalPayment.dart';
import 'package:cameo/Network/stripe/StripeCardScreen.dart';
import 'package:cameo/Screens/PaymentStatusScreen.dart';
import 'package:cameo/Widgets/Loading%20Indicators/LoadingIndicator.dart';
import 'package:cameo/constants.dart';
import 'package:cameo/models/cameo_model.dart';
import 'package:cameo/models/notification_model.dart';
import 'package:cameo/models/user_model.dart';
import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../utils.dart';

// http://ec2-54-189-124-142.us-west-2.compute.amazonaws.com/
const baseUrl = 'https://cameo.deliveryventure.com/api';
const domainUrl = 'https://cameo.deliveryventure.com';

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
    log(response.body);
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
    log(id.toString());
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
    var userId = await FlutterSecureStorage().read(key: "user_id");
    print('calling: $baseUrl${endPoints["user_detail"]}$userId');
    http.Response response =
        await http.get('$baseUrl${endPoints["user_detail"]}$userId');
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
      if (response.data["message"] == 'SUCCESS') {
        User currentUser = Get.find<User>();
        currentUser.country = country;
        currentUser.address = address;
        currentUser.city = city;
        currentUser.fullname = fullname;
        currentUser.profession = profession;
        currentUser.description = description;
        currentUser.langSpeaks = language;
        currentUser.zipcode = zipcode;
        currentUser.contact = phone;
        currentUser.stateName = state;
      }
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
      print(response.data);
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

  //Order

  void createOrder({String source, Cameo cameo}) async {
    User user = Get.find<User>();
    Get.back();
    Get.defaultDialog(
        barrierDismissible: false,
        title: "Please wait",
        content: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(kSecondaryColor),
          ),
        ));
    var response = await http
        .post("https://cameo.deliveryventure.com/api/gigs/save_payment", body: {
      "gigs_id": cameo.gigsDetails.id,
      "seller_id": cameo.gigsDetails.userId,
      "USERID": user.userid,
      "time_zone": "Asia/Kolkata",
      "item_amount": cameo.gigsDetails.gigPrice,
      "dollar_amount": cameo.gigsDetails.gigPrice,
      "gig_price": cameo.gigsDetails.gigPrice,
      "extra_gig_ref": "",
      "currency_type": cameo.gigsDetails.currencyType,
      "currency": cameo.gigsDetails.currencySign,
      "payment_super_fast_delivery": "1",
      "status": "1",
      "source": source
    });

    Map serverStatus = jsonDecode(response.body);
    var itemNumber = serverStatus["message"]["item_number"].toString();
    if (serverStatus["status"] == true) {
      switch (source) {
        case "paypal":
          Get.to(
            () {
              var cameoTitle =
                  "${titleCase(string: cameo.gigsDetails.title)}\'s cameo";
              return PaypalPayment(
                onFinish: (serverResponse) async {
                  // payment done
                  print(serverResponse);
                  this.updatePaypalPaymentSuccess(
                      itemNumber: itemNumber, serverResponse: serverResponse);
                },
                itemName: cameoTitle,
                itemPrice: cameo.gigsDetails.gigPrice,
                currency: cameo.gigsDetails.currencyType,
                itemNumber: itemNumber,
              );
            },
          );

          break;

        case "stripe":
          Get.back();
          Get.to(() => StripeCardScreen(),
              arguments: {"cameo": cameo, "item_number": itemNumber});
          break;
        default:
      }
    } else {
      Get.snackbar(
        "",
        "",
        margin: EdgeInsets.all(0),
        borderRadius: 0,
        backgroundColor: Colors.red,
        titleText: Text("Error", style: TextStyle(color: Colors.white)),
        messageText: Text(
          "Something went wrong, try again later",
          style: TextStyle(color: Colors.white),
        ),
      );
    }
  }

  void updatePaypalPaymentSuccess(
      {String itemNumber, String serverResponse}) async {
    // String mock =
    //     '{"id":"PAYID-MBM6VNQ3HC99887F3223161W","intent":"sale","state":"approved","cart":"5M586017NB099244M","payer":{"payment_method":"paypal","status":"VERIFIED","payer_info":{"email":"sb-7l6qt5476809@business.example.com","first_name":"John","last_name":"Doe","payer_id":"69NG939PG3ZSE","shipping_address":{"recipient_name":"John Doe","line1":"1 Main St","city":"San Jose","state":"CA","postal_code":"95131","country_code":"US"},"country_code":"US","business_name":"John Doe\'s Test Store"}},"transactions":[{"amount":{"total":"1.00","currency":"USD","details":{"subtotal":"1.00","shipping":"0.00","insurance":"0.00","handling_fee":"0.00","shipping_discount":"0.00","discount":"0.00"}},"payee":{"merchant_id":"H93GCV5FEKSVJ","email":"sb-tdpsu3320676@business.example.com"},"description":"The payment transaction description.","item_list":{"items":[{"name":"Mick Foley\'s cameo","price":"1.00","currency":"USD","tax":"0.00","quantity":1}],"shipping_address":{"recipient_name":"John Doe","line1":"1 Main St","city":"San Jose","state":"CA","postal_code":"95131","country_code":"US"}},"related_resources":[{"sale":{"id":"7FS80907E18059042","state":"completed","amount":{"total":"1.00","currency":"USD","details":{"subtotal":"1.00","shipping":"0.00","insurance":"0.00","handling_fee":"0.00","shipping_discount":"0.00","discount":"0.00"}},"payment_mode":"INSTANT_TRANSFER","protection_eligibility":"ELIGIBLE","protection_eligibility_type":"ITEM_NOT_RECEIVED_ELIGIBLE,UNAUTHORIZED_PAYMENT_ELIGIBLE","transaction_fee":{"value":"0.40","currency":"USD"},"parent_payment":"PAYID-MBM6VNQ3HC99887F3223161W","create_time":"2021-03-23T13:20:12Z","update_time":"2021-03-23T13:20:12Z","links":[{"href":"https://api.sandbox.paypal.com/v1/payments/sale/7FS80907E18059042","rel":"self","method":"GET"},{"href":"https://api.sandbox.paypal.com/v1/payments/sale/7FS80907E18059042/refund","rel":"refund","method":"POST"},{"href":"https://api.sandbox.paypal.com/v1/payments/payment/PAYID-MBM6VNQ3HC99887F3223161W","rel":"parent_payment","method":"GET"}]}}]}],"failed_transactions":[],"create_time":"2021-03-23T13:18:45Z","update_time":"2021-03-23T13:20:12Z","links":[{"href":"https://api.sandbox.paypal.com/v1/payments/payment/PAYID-MBM6VNQ3HC99887F3223161W","rel":"self","method":"GET"}]}';
    Map convertedJson = jsonDecode(serverResponse);
    // print(convertedJson);
    http.Response response =
        await http.post("$baseUrl/gigs/pay_success", body: {
      "item_number": itemNumber,
      "response": jsonEncode(convertedJson),
      "payment_type": "paypal"
    });
    print(response.body);
    var convertedResponse = jsonDecode(response.body);
    if (convertedResponse["status"] == true) {
      Get.back();

      Get.to(() => PaymentStatusScreen(), arguments: {"payment_status": true});
    }
  }

  void updateStripePaymentSuccess(
      {String itemNumber, String serverResponse}) async {
    var mock =
        '{"id":"pi_1IZaHsGDJI6B9tkqeoYOnXvW","object":"payment_intent","amount":500,"amount_capturable":0,"amount_received":500,"application":null,"application_fee_amount":null,"canceled_at":null,"cancellation_reason":null,"capture_method":"automatic","charges":{"object":"list","data":[{"id":"ch_1IZaHtGDJI6B9tkqS194z0WY","object":"charge","amount":500,"amount_captured":500,"amount_refunded":0,"application":null,"application_fee":null,"application_fee_amount":null,"balance_transaction":"txn_1IZaHuGDJI6B9tkqYoxN5MOr","billing_details":{"address":{"city":null,"country":null,"line1":null,"line2":null,"postal_code":null,"state":null},"email":null,"name":null,"phone":null},"calculated_statement_descriptor":"Stripe","captured":true,"created":1616844401,"currency":"usd","customer":null,"description":"ernie hudson","destination":null,"dispute":null,"disputed":false,"failure_code":null,"failure_message":null,"fraud_details":{},"invoice":null,"livemode":false,"metadata":{},"on_behalf_of":null,"order":null,"outcome":{"network_status":"approved_by_network","reason":null,"risk_level":"normal","risk_score":3,"seller_message":"Payment complete.","type":"authorized"},"paid":true,"payment_intent":"pi_1IZaHsGDJI6B9tkqeoYOnXvW","payment_method":"pm_1IZaHsGDJI6B9tkqk7GewfJy","payment_method_details":{"card":{"brand":"visa","checks":{"address_line1_check":null,"address_postal_code_check":null,"cvc_check":"pass"},"country":"US","exp_month":12,"exp_year":2023,"fingerprint":"fJKsaPQeF9Uo9rbT","funding":"credit","installments":null,"last4":"4242","network":"visa","three_d_secure":null,"wallet":null},"type":"card"},"receipt_email":null,"receipt_number":null,"receipt_url":"https://pay.stripe.com/receipts/acct_1Fm42FGDJI6B9tkq/ch_1IZaHtGDJI6B9tkqS194z0WY/rcpt_JByEKz2BqurDgwaewFTAsQaH4H1Was0","refunded":false,"refunds":{"object":"list","data":[],"has_more":false,"total_count":0,"url":"/v1/charges/ch_1IZaHtGDJI6B9tkqS194z0WY/refunds"},"review":null,"shipping":{"address":{"city":"Chennai","country":"Angola","line1":"12, new york, us","line2":null,"postal_code":"600035","state":"Chennai"},"carrier":null,"name":"Demouser","phone":null,"tracking_number":null},"source":null,"source_transfer":null,"statement_descriptor":null,"statement_descriptor_suffix":null,"status":"succeeded","transfer_data":null,"transfer_group":null}],"has_more":false,"total_count":1,"url":"/v1/charges?payment_intent=pi_1IZaHsGDJI6B9tkqeoYOnXvW"},"client_secret":"pi_1IZaHsGDJI6B9tkqeoYOnXvW_secret_IzhCSmYsZV4AUYYOO9SKWPESD","confirmation_method":"automatic","created":1616844400,"currency":"usd","customer":null,"description":"ernie hudson","invoice":null,"last_payment_error":null,"livemode":false,"metadata":{},"next_action":null,"on_behalf_of":null,"payment_method":"pm_1IZaHsGDJI6B9tkqk7GewfJy","payment_method_options":{"card":{"installments":null,"network":null,"request_three_d_secure":"automatic"}},"payment_method_types":["card"],"receipt_email":null,"review":null,"setup_future_usage":null,"shipping":{"address":{"city":"Chennai","country":"Angola","line1":"12, new york, us","line2":null,"postal_code":"600035","state":"Chennai"},"carrier":null,"name":"Demouser","phone":null,"tracking_number":null},"source":null,"statement_descriptor":null,"statement_descriptor_suffix":null,"status":"succeeded","transfer_data":null,"transfer_group":null}';
    // Map convertedJson = jsonDecode(serverResponse);
    http.Response response = await http.post("$baseUrl/gigs/pay_success",
        body: {
          "item_number": itemNumber,
          "response": serverResponse,
          "payment_type": "stripe"
        });
    print(response.body);
    var convertedResponse = jsonDecode(response.body);
    if (convertedResponse["status"] == true) {
      Get.back();
      Get.to(() => PaymentStatusScreen(), arguments: {"payment_status": true});
    }
  }

  Future<NotificationList> notification() async {
    var userId = await FlutterSecureStorage().read(key: "user_id");
    http.Response response =
        await http.get("${baseUrl}/gigs/get_notification_count/$userId");
    var data = jsonDecode(response.body);
    NotificationList notificationList = NotificationList();
    if (data["total_count"] > 0) {
      for (var notification in data["data"]) {
        CameoNotification cameoNotification = CameoNotification(
            message: notification[3],
            id: notification[0],
            event: notification[2],
            sendEvent: notification[1]);
        notificationList.addNotification(cameoNotification);
      }
    }
    return notificationList;
  }

  Future<bool> markNotificationSeen(
      {String notificationId, String sendEvent}) async {
    http.Response response = await http.get(
        "$baseUrl/gigs/change_notification_status/$notificationId?sts=$sendEvent");
    var data = jsonDecode(response.body);
    if (data["message"] == "SUCCESS") {
      return true;
    } else {
      return false;
    }
  }
}
