import 'package:flutter/material.dart';
import '../../constants.dart';

class PaymentUpdateTab extends StatelessWidget {
  const PaymentUpdateTab({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          Theme(
            data: ThemeData(primaryColor: Colors.pinkAccent),
            child: TextFormField(
              initialValue: "demo@sample.com",
              decoration:
                  kEditFieldDecoration.copyWith(labelText: "Paypal Email ID"),
              style: TextStyle(
                fontSize: 17,
                color: Colors.white,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: FlatButton(
              onPressed: () => {},
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.pinkAccent,
            ),
          ),
        ],
      ),
    ));
  }
}
