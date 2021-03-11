import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatelessWidget {
  final RxString counter = ''.obs;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Obx(() => Text("Notification ${counter.value}")),
        ),
        body: Column(
          children: [
            TextFormField(
              onChanged: (value) => counter.value = value,
            )
          ],
        ),
      ),
    );
  }
}
