import 'package:cameo/Network/networkHelper.dart';
import 'package:cameo/Screens/MyPurchaseScreen.dart';
import 'package:cameo/Screens/SaleScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/default_transitions.dart';

class CameoNotification {
  String message;
  String event;
  String id;
  String sendEvent;
  CameoNotification({this.message, this.event, this.id, this.sendEvent});
}

class NotificationList extends GetxController {
  var notificationList = [].obs;
  void addNotification(CameoNotification cameoNotification) {
    this.notificationList.add(cameoNotification);
  }

  void markSeen(String id, String sendEvent) async {
    ApiHelper apiHelper = ApiHelper();
    bool result = await apiHelper.markNotificationSeen(
        notificationId: id, sendEvent: sendEvent);
    if (result) {
      CameoNotification cameoNotification =
          this.notificationList.firstWhere((element) => element.id == id);
      this.notificationList.remove(cameoNotification);
      Get.back();
      if (cameoNotification.event == "sales") {
        Get.to(() => SaleScreen());
      }
      if (cameoNotification.event == "purchases") {
        Get.to(() => MyPurchaseScreen());
      }
    } else {
      Get.back();
      Get.snackbar(
        "Error occured",
        "Something went wrong make sure that you're connected to the internet.",
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(0),
        backgroundColor: Colors.red.shade800,
        colorText: Colors.white,
        borderRadius: 0,
      );
    }
  }
}
