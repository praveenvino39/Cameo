import 'dart:core';
import 'dart:developer';
import 'package:cameo/Screens/PaymentStatusScreen.dart';
import 'package:cameo/constants.dart';
import 'package:cameo/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../utils.dart';
import 'PaypalServices.dart';

class PaypalPayment extends StatefulWidget {
  final Function onFinish;
  final String itemName;
  final String currency;
  final String itemNumber;
  final String itemPrice;

  PaypalPayment(
      {this.onFinish,
      this.itemName,
      this.itemPrice,
      this.currency,
      this.itemNumber});

  @override
  State<StatefulWidget> createState() {
    return PaypalPaymentState();
  }
}

class PaypalPaymentState extends State<PaypalPayment> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String checkoutUrl;
  String executeUrl;
  String accessToken;
  PaypalServices services = PaypalServices();
  User currentUser = Get.find<User>();

  // you can change default currency according to your need
  Map<dynamic, dynamic> defaultCurrency = {
    "symbol": "USD ",
    "decimalDigits": 2,
    "symbolBeforeTheNumber": true,
    "currency": "USD"
  };

  bool isEnableShipping = false;
  bool isEnableAddress = false;

  String returnURL = 'return.example.com';
  String cancelURL = 'cancel.example.com';

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      try {
        accessToken = await services.getAccessToken();
        print(accessToken);
        final transactions = getOrderParams();
        final res =
            await services.createPaypalPayment(transactions, accessToken);
        if (res != null) {
          setState(() {
            checkoutUrl = res["approvalUrl"];
            executeUrl = res["executeUrl"];
          });
        }
      } catch (e) {
        print('exception: ' + e.toString());
        final snackBar = SnackBar(
          content: Text(e.toString()),
          duration: Duration(seconds: 10),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    });
  }

  // item name, price and quantity

  int quantity = 1;

  Map<String, dynamic> getOrderParams() {
    List items = [
      {
        // "custom_id": "141",
        "name": widget.itemName,
        "quantity": quantity,
        "price": widget.itemPrice,
        "currency": widget.currency
      }
    ];

    // checkout invoice details
    String totalAmount = widget.itemPrice;
    String subTotalAmount = widget.itemPrice;
    String shippingCost = '0';
    int shippingDiscountCost = 0;
    String userFirstName = currentUser.fullname;
    String userLastName = currentUser.fullname;
    String addressCity = currentUser.city;
    String addressStreet = currentUser.address;
    String addressZipCode = currentUser.zipcode;
    String addressCountry = currentUser.countryName;
    String addressState = currentUser.stateName;
    String addressPhoneNumber = currentUser.country;

    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": totalAmount,
            "currency": defaultCurrency["currency"],
            "details": {
              "subtotal": subTotalAmount,
              "shipping": shippingCost,
              "shipping_discount": ((-1.0) * shippingDiscountCost).toString()
            }
          },
          "description": "The payment transaction description.",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },
          "item_list": {
            "items": items,
            if (isEnableShipping && isEnableAddress)
              "shipping_address": {
                "recipient_name": userFirstName + " " + userLastName,
                "line1": addressStreet,
                "line2": "",
                "city": addressCity,
                "country_code": addressCountry,
                "postal_code": addressZipCode,
                "phone": addressPhoneNumber,
                "state": addressState
              },
          }
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL}
    };
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    print(checkoutUrl);

    if (checkoutUrl != null) {
      return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Container(
                width: 15,
                height: 15,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
              width(10.0),
              Text(
                "Don\'t press back button...",
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
          leading: GestureDetector(
            child: Icon(Icons.arrow_back_ios),
            onTap: () => Navigator.pop(context),
          ),
        ),
        body: Container(
          height: Get.height - 30,
          child: WebView(
            initialUrl: checkoutUrl,
            javascriptMode: JavascriptMode.unrestricted,
            navigationDelegate: (NavigationRequest request) {
              log(request.url);
              if (request.url.contains(returnURL)) {
                final uri = Uri.parse(request.url);
                final payerID = uri.queryParameters['PayerID'];
                if (payerID != null) {
                  services
                      .executePayment(executeUrl, payerID, accessToken)
                      .then((serverResponse) {
                    widget.onFinish(serverResponse);
                  });
                } else {
                  Navigator.of(context).pop();
                }
                Navigator.of(context).pop();
              }
              if (request.url.contains(cancelURL)) {
                Navigator.of(context).pop();
                Get.back();
                Get.to(() => PaymentStatusScreen(),
                    arguments: {"payment_status": false});
              }
              return NavigationDecision.navigate;
            },
          ),
        ),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          title: Text(
            "Your payment is processing...",
            style: TextStyle(fontSize: 15),
          ),
          elevation: 0.0,
        ),
        body: Center(
            child: Container(
                child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(kSecondaryColor),
        ))),
      );
    }
  }
}
