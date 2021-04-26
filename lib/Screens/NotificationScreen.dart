import 'dart:developer';

import 'package:cameo/Network/networkHelper.dart';
import 'package:cameo/Widgets/Loading%20Indicators/LoadingIndicator.dart';
import 'package:cameo/models/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';

class NotificationScreen extends StatelessWidget {
  NotificationList notificationList = Get.find<NotificationList>();
  @override
  Widget build(BuildContext context) {
    ApiHelper apiHelper = ApiHelper();
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBodyBackgroundColor,
        appBar: AppBar(
          title: Text("Notification "),
        ),
        body: Obx(
          () => notificationList.notificationList.length > 0
              ? ListView.builder(
                  itemCount: notificationList.notificationList.length,
                  itemBuilder: (context, index) => ListTile(
                    onTap: () {
                      loading(context);
                      notificationList.markSeen(
                          notificationList.notificationList[0].id,
                          notificationList.notificationList[0].sendEvent);
                    },
                    tileColor: Colors.white,
                    title: Text(notificationList.notificationList[0].message),
                    leading: Icon(
                      Icons.notifications,
                      color: kSecondaryColor,
                    ),
                  ),
                )
              : Center(
                  child: Text(
                    "No new notification",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
        ),
      ),
    );
  }
}
