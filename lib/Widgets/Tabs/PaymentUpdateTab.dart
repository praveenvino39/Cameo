import 'dart:developer';

import 'package:cameo/Network/networkHelper.dart';
import 'package:cameo/Widgets/Loading%20Indicators/LoadingIndicator.dart';
import 'package:cameo/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants.dart';

// ignore: must_be_immutable
class PaymentUpdateTab extends StatefulWidget {
  GlobalKey<ScaffoldState> scaffoldKey;
  PaymentUpdateTab({Key key, this.scaffoldKey}) : super(key: key);

  @override
  _PaymentUpdateTabState createState() => _PaymentUpdateTabState();
}

class _PaymentUpdateTabState extends State<PaymentUpdateTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  String paypalEmail;

  String accountHoldersName;

  String accountNumber;

  String iban;

  String bankName;

  String bankAddress;

  String shortCode;

  String routingNumber;

  String ifsc;

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ApiHelper().getPaymentDetail(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            log(snapshot.data[1].toString());
            if (snapshot.data[0] != null) {
              accountHoldersName = snapshot.data[0][0]["account_holder_name"];
              accountNumber = snapshot.data[0][0]["account_number"];
              iban = snapshot.data[0][0]["account_iban"];
              bankName = snapshot.data[0][0]["bank_name"];
              bankAddress = snapshot.data[0][0]["bank_address"];
              shortCode = snapshot.data[0][0]["sort_code"];
              routingNumber = snapshot.data[0][0]["routing_number"];
              ifsc = snapshot.data[0][0]["account_ifsc"];
            } else {
              accountHoldersName = "";
              accountNumber = "";
              iban = "";
              bankName = "";
              bankAddress = "";
              shortCode = "";
              routingNumber = "";
              ifsc = "";
            }
            if (snapshot.data[1] != null) {
              paypalEmail = snapshot.data[1][0]["paypal_email"];
            } else {
              paypalEmail = "";
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/paypal.svg',
                            width: 30,
                          ),
                          width(15.0),
                          Text(
                            "Paypal Account Details",
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          ),
                        ],
                      ),
                    ),
                    Theme(
                      data: ThemeData(primaryColor: Colors.pinkAccent),
                      child: TextFormField(
                        onChanged: (value) => {paypalEmail = value},
                        initialValue: paypalEmail,
                        decoration: kEditFieldDecoration.copyWith(
                            labelText: "Paypal Email ID"),
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset('assets/images/stripe.svg'),
                              width(15.0),
                              Text(
                                "Stripe Account Details",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 22),
                              ),
                            ],
                          ),
                          Theme(
                            data: ThemeData(primaryColor: Colors.pinkAccent),
                            child: TextFormField(
                              onChanged: (value) => accountHoldersName = value,
                              initialValue: accountHoldersName,
                              decoration: kEditFieldDecoration.copyWith(
                                  labelText: "Account Holders Name"),
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          Theme(
                            data: ThemeData(primaryColor: Colors.pinkAccent),
                            child: TextFormField(
                              onChanged: (value) => accountNumber = value,
                              initialValue: accountNumber,
                              decoration: kEditFieldDecoration.copyWith(
                                  labelText: "Account Number"),
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          Theme(
                            data: ThemeData(primaryColor: Colors.pinkAccent),
                            child: TextFormField(
                              onChanged: (value) => iban = value,
                              initialValue: iban,
                              decoration: kEditFieldDecoration.copyWith(
                                  labelText: "IBAN"),
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          Theme(
                            data: ThemeData(primaryColor: Colors.pinkAccent),
                            child: TextFormField(
                              onChanged: (value) => bankName = value,
                              initialValue: bankName,
                              decoration: kEditFieldDecoration.copyWith(
                                  labelText: "Bank Name"),
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          Theme(
                            data: ThemeData(primaryColor: Colors.pinkAccent),
                            child: TextFormField(
                              onChanged: (value) => bankAddress = value,
                              initialValue: bankAddress,
                              decoration: kEditFieldDecoration.copyWith(
                                  labelText: "Bank Address"),
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          Theme(
                            data: ThemeData(primaryColor: Colors.pinkAccent),
                            child: TextFormField(
                              onChanged: (value) => shortCode = value,
                              initialValue: shortCode,
                              decoration: kEditFieldDecoration.copyWith(
                                  labelText: "Sort Code(UK)"),
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          Theme(
                            data: ThemeData(primaryColor: Colors.pinkAccent),
                            child: TextFormField(
                              onChanged: (value) => routingNumber = value,
                              initialValue: routingNumber,
                              decoration: kEditFieldDecoration.copyWith(
                                  labelText: "Routing Number(US)"),
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          Theme(
                            data: ThemeData(primaryColor: Colors.pinkAccent),
                            child: TextFormField(
                              onChanged: (value) => ifsc = value,
                              initialValue: ifsc,
                              decoration: kEditFieldDecoration.copyWith(
                                  labelText: "IFSC Code(Indian)"),
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10.0, bottom: 15.0),
                          child: FlatButton(
                            onPressed: () async {
                              loading(context);
                              Map data = await ApiHelper().updatePayment(
                                  paypalEmail: paypalEmail,
                                  accountHoldersName: accountHoldersName,
                                  accountNumber: accountNumber,
                                  iban: iban,
                                  bankName: bankName,
                                  bankAddress: bankAddress,
                                  shortCode: shortCode,
                                  routingNumber: routingNumber,
                                  ifsc: ifsc);
                              if (data["code"] == 200) {
                                Navigator.pop(context);
                                forceHideKeyboard(context);
                                widget.scaffoldKey.currentState
                                    .removeCurrentSnackBar();
                                widget.scaffoldKey.currentState
                                    .showSnackBar(SnackBar(
                                  backgroundColor: Colors.white,
                                  content: Text(
                                    "Payment details updated successfully.",
                                    style: TextStyle(color: kSecondaryColor),
                                  ),
                                ));
                              }
                            },
                            child: Text(
                              'Save',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.pinkAccent,
                          ),
                        ),
                        width(MediaQuery.of(context).size.width)
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
