import 'package:cameo/Widgets/SvgButton.dart';
import 'package:cameo/utils.dart';
import 'package:flutter/material.dart';

class PaymentPopup extends StatelessWidget {
  final double price;
  final int paymentTo;
  final int paymentFrom;
  PaymentPopup({
    Key key,
    this.price,
    this.paymentTo,
    this.paymentFrom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Paying $price to $paymentTo from the user $paymentFrom');
    return Center(
        child: AlertDialog(
      backgroundColor: Colors.white,
      content: Container(
        height: 190,
        child: Column(
          children: [
            Text(
              "Continue with",
              style: TextStyle(fontSize: 22),
            ),
            height(7.0),
            SvgButton(
                assetPath: 'assets/images/paypal.svg',
                backgroundColor: Colors.white,
                svgSize: 20,
                title: 'Paypal'),
            SvgButton(
              assetPath: 'assets/images/stripe.svg',
              backgroundColor: Colors.white,
              svgSize: 20,
              title: 'Stripe',
            ),
            Container(
              width: 190,
              child: OutlineButton(
                onPressed: () => {},
                highlightColor: Colors.transparent,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      width: 20,
                      image: AssetImage('assets/images/paytabs.png'),
                    ),
                    width(4.0),
                    Text("Paytabs")
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
