import 'package:cameo/constants.dart';
import 'package:flutter/material.dart';

class PasswordUpdateTab extends StatelessWidget {
  PasswordUpdateTab({
    Key key,
  }) : super(key: key);
  final FocusNode fnCurrentPassword = FocusNode();
  final FocusNode fnNewPassword = FocusNode();
  final FocusNode fnRepeatPassword = FocusNode();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Theme(
            data: ThemeData(primaryColor: Colors.pinkAccent),
            child: TextFormField(
              initialValue: "demo@sample.com",
              readOnly: true,
              decoration: kEditFieldDecoration.copyWith(labelText: "Email"),
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
              initialValue: "demouser",
              readOnly: true,
              decoration: kEditFieldDecoration.copyWith(labelText: "Username"),
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
              focusNode: fnCurrentPassword,
              onEditingComplete: () =>
                  FocusScope.of(context).requestFocus(fnNewPassword),
              obscureText: true,
              decoration:
                  kEditFieldDecoration.copyWith(labelText: "Current password"),
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
              focusNode: fnNewPassword,
              onEditingComplete: () =>
                  FocusScope.of(context).requestFocus(fnRepeatPassword),
              obscureText: true,
              decoration:
                  kEditFieldDecoration.copyWith(labelText: "New password"),
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
              focusNode: fnRepeatPassword,
              obscureText: true,
              decoration:
                  kEditFieldDecoration.copyWith(labelText: "Re-enter password"),
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
                'Change Password',
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
