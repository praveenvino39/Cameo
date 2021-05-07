import 'dart:convert';
import 'dart:developer';

import 'package:cameo/Network/networkHelper.dart';
import 'package:cameo/Screens/PaymentStatusScreen.dart';
import 'package:cameo/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:http/http.dart' as http;

import '../../utils.dart';

class StripeService {
  PaymentMethod paymentMethod;
  PaymentIntent paymentIntent;
  final String amount;
  final String currency;
  User currentUser;
  final String serviceName;

  StripeService({
    this.amount,
    this.currency,
    this.serviceName,
  }) {
    currentUser = Get.find<User>();
    StripePayment.setOptions(
      StripeOptions(
          publishableKey: "pk_test_O3nXobAT7RUl9hg0QfYWBQff00LSWeB9IE",
          merchantId: "Test",
          androidPayMode: 'test'),
    );
  }

  CreditCard createCreditCard(
      {String cardNumber, String cardHolderName, String expDate, String cvc}) {
    CreditCard creditCard = CreditCard(
      number: cardNumber,
      cvc: cvc,
      expMonth: int.parse(expDate.split('/')[0]),
      expYear: int.parse(expDate.split('/')[1]),
      name: cardHolderName,
    );
    return creditCard;
  }

  Future<PaymentIntent> createPaymentMethodWithCardForm(
      {CreditCard creditCard}) async {
    paymentMethod =
        await StripePayment.createPaymentMethod(PaymentMethodRequest(
      card: creditCard,
    ));
    if (paymentMethod.id != null) {
      PaymentIntent intent = await this.createPaymentIntentWithPaymentMethod(
          paymentMethodId: paymentMethod.id);
      return intent;
    } else {
      return null;
    }
  }

  Future<PaymentIntent> createPaymentIntentWithPaymentMethod(
      {@required String paymentMethodId}) async {
    http.Response response =
        await http.post('https://api.stripe.com/v1/payment_intents', headers: {
      "Authorization": "Bearer sk_test_InNmafpyVmRe0re1YqIYvHEm006Sztmcf0",
    }, body: {
      "payment_method_types[]": "card",
      "amount": "${this.amount}00",
      "currency": this.currency,
      "description": serviceName,
      "shipping[name]": "${titleCase(string: currentUser.username)}",
      "shipping[address][line1]": currentUser.address,
      "shipping[address][postal_code]": currentUser.zipcode,
      "shipping[address][city]": currentUser.city,
      "shipping[address][state]": currentUser.stateName,
      "shipping[address][country]": currentUser.countryName,
    });
    log("${currentUser.address}");
    if (response.statusCode == 200) {
      Map paymentIntentResponse = jsonDecode(response.body);
      paymentIntent = PaymentIntent(
        clientSecret: paymentIntentResponse["client_secret"],
        paymentMethodId: paymentMethodId,
      );
    }
    return paymentIntent;
  }

  void confirmPayment({PaymentIntent intent, String itemNumber}) async {
    try {
      PaymentIntentResult paymentIntentResult =
          await StripePayment.confirmPaymentIntent(intent);
      log(jsonEncode(paymentIntentResult));
      if (paymentIntentResult.status == "succeeded") {
        http.Response response = await http.post(
            "https://api.stripe.com/v1/payment_intents/${paymentIntentResult.paymentIntentId}",
            headers: {
              "Authorization":
                  "Bearer sk_test_InNmafpyVmRe0re1YqIYvHEm006Sztmcf0"
            });
        if (response.statusCode == 200) {
          var paymentResponseParams = jsonDecode(response.body);
          log(jsonEncode(paymentResponseParams));
          ApiHelper().updateStripePaymentSuccess(
              itemNumber: itemNumber,
              serverResponse: jsonEncode(paymentResponseParams));
        }
      }
      //
    } on PlatformException catch (error) {
      if (error.code == "cancelled") {
        Get.back();
        Get.off(() => PaymentStatusScreen(),
            arguments: {"payment_status": false});
      }
      if (error.code == "failed") {
        Get.back();
        Get.off(() => PaymentStatusScreen(),
            arguments: {"payment_status": false});
      }
    } catch (e) {
      throw e;
    }
  }
}
