import 'package:cameo/Network/stripe/StripePaymentService.dart';
import 'package:cameo/constants.dart';
import 'package:cameo/models/cameo_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:stripe_payment/stripe_payment.dart';

// ignore: must_be_immutable
class StripeCardScreen extends StatelessWidget {
  String itemNumber = Get.arguments["item_number"];
  Cameo cameo = Get.arguments["cameo"];
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var cardNumber = "".obs;
  var expireDate = "".obs;
  var cvc = "".obs;
  var cardName = "".obs;
  var showBack = false.obs;
  CreditCardModel data;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Obx(
              //   () => CreditCardWidget(
              //     animationDuration: Duration(milliseconds: 300),
              //     cardBgColor: Colors.transparent,
              //     cardNumber: cardNumber.value,
              //     expiryDate: expireDate.value,
              //     obscureCardNumber: false,
              //     cardHolderName: cardName.value,
              //     cvvCode: cvc.value,
              //     showBackView: showBack
              //         .value, //true when you want to show cvv(back) view
              //   ),
              // ),
              Center(
                child: CreditCardForm(
                  formKey: formKey, // Required
                  onCreditCardModelChange: (CreditCardModel data) {
                    data = data;
                    cardNumber.value = data.cardNumber;
                    expireDate.value = data.expiryDate;
                    cvc.value = data.cvvCode;
                    cardName.value = data.cardHolderName;
                    showBack.value = data.cvvCode.length > 0 ? true : false;
                    if (data.cvvCode.length >= 3) {
                      showBack.value = false;
                    }
                    // showBack.value = data.cardHolderName.length > 0 ? false : "";
                  },
                  // Required
                  themeColor: Colors.red,
                  obscureCvv: false,
                  obscureNumber: false,
                  cardNumberDecoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Number',
                    hintText: 'XXXX XXXX XXXX XXXX',
                  ),
                  expiryDateDecoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Expired Date',
                    hintText: 'XX/XX',
                  ),
                  cvvCodeDecoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'CVV',
                    hintText: 'XXX',
                  ),
                  cardHolderDecoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Card Holder',
                  ),
                ),
              ),
              Container(
                width: Get.width / 1.1,
                child: RaisedButton(
                  onPressed: () async {
                    if (formKey.currentState.validate()) {
                      Get.defaultDialog(
                        title: "Please wait",
                        barrierDismissible: false,
                        content: Center(
                            child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(kSecondaryColor),
                        )),
                      );
                      StripeService stripeService = StripeService(
                          amount: cameo.gigsDetails.gigPrice,
                          currency: cameo.gigsDetails.currencyType,
                          serviceName: cameo.gigsDetails.title);
                      CreditCard card = stripeService.createCreditCard(
                          cardHolderName: cardName.value,
                          cardNumber: cardNumber.value,
                          expDate: expireDate.value,
                          cvc: cvc.value);
                      PaymentIntent paymentIntent = await stripeService
                          .createPaymentMethodWithCardForm(creditCard: card);
                      stripeService.confirmPayment(
                          intent: paymentIntent, itemNumber: itemNumber);
                    }
                  },
                  color: kSecondaryColor,
                  child: Text(
                    "Proceed",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
