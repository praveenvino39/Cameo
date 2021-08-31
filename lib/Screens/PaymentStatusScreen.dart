import 'package:cameo/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class PaymentStatusScreen extends StatelessWidget {
  final bool paymentStatus = Get.arguments["payment_status"];
  @override
  Widget build(BuildContext context) {
    if (paymentStatus) {
      return Scaffold(
        backgroundColor: kBodyBackgroundColor,
        body: Center(
          child: Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: successWidgets),
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: kBodyBackgroundColor,
        body: Center(
          child: Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: unsuccessWidgets),
          ),
        ),
      );
    }
  }
}

List<Widget> successWidgets = [
  Lottie.asset('assets/animations/payment_success.json', repeat: false),
  // height(10.0),
  // Text("Your payment completed successfully")
];

List<Widget> unsuccessWidgets = [
  Lottie.asset('assets/animations/payment_failed.json', repeat: false),
  // height(10.0),
  // Text("Your payment was cancelled")
];
