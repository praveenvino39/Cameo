import 'package:cameo/Network/networkHelper.dart';
import 'package:cameo/Widgets/Loading%20Indicators/LoadingIndicator.dart';
import 'package:cameo/constants.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../utils.dart';

// ignore: must_be_immutable
class PasswordUpdateTab extends StatelessWidget {
  GlobalKey<ScaffoldState> scaffoldKey;
  PasswordUpdateTab({Key key, this.scaffoldKey}) : super(key: key);
  final FocusNode fnCurrentPassword = FocusNode();
  final FocusNode fnNewPassword = FocusNode();
  final FocusNode fnRepeatPassword = FocusNode();
  String currentPassword;
  String newPassword;
  String confirmPassword;
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Form(
        key: _formkey,
        child: Column(
          children: [
            Theme(
              data: ThemeData(primaryColor: Colors.pinkAccent),
              child: TextFormField(
                onChanged: (value) => currentPassword = value,
                validator:
                    RequiredValidator(errorText: "This field is required."),
                focusNode: fnCurrentPassword,
                onEditingComplete: () =>
                    FocusScope.of(context).requestFocus(fnNewPassword),
                obscureText: true,
                decoration: kEditFieldDecoration.copyWith(
                    labelText: "Current password"),
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
                validator: MultiValidator([
                  MinLengthValidator(8,
                      errorText: "Password must be greater that 8 character."),
                  PatternValidator(r'(?=.*?[#?!@$%^&*-])',
                      errorText:
                          'passwords must have at least one special character'),
                  RequiredValidator(errorText: 'password is required')
                ]),
                focusNode: fnNewPassword,
                onChanged: (value) => newPassword = value,
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
                validator: MultiValidator([
                  MinLengthValidator(8,
                      errorText: "Password must be greater that 8 character."),
                  PatternValidator(r'(?=.*?[#?!@$%^&*-])',
                      errorText:
                          'passwords must have at least one special character'),
                  RequiredValidator(errorText: 'password is required'),
                ]),
                onChanged: (value) => confirmPassword = value,
                focusNode: fnRepeatPassword,
                obscureText: true,
                decoration: kEditFieldDecoration.copyWith(
                    labelText: "Re-enter password"),
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
                onPressed: () async {
                  if (_formkey.currentState.validate() &&
                      newPassword == confirmPassword) {
                    loading(context);
                    Map data = await ApiHelper().updatePassword(
                        currentPassword: currentPassword,
                        newPassword: newPassword);
                    Navigator.of(context).pop();
                    forceHideKeyboard(context);
                    if (data["code"] == 200) {
                      scaffoldKey.currentState.removeCurrentSnackBar();
                      scaffoldKey.currentState.showSnackBar(SnackBar(
                          backgroundColor: Colors.white,
                          content: Text(
                            data["message"],
                            style: TextStyle(color: Color(0xffff037c)),
                          )));
                    } else {
                      scaffoldKey.currentState.removeCurrentSnackBar();
                      scaffoldKey.currentState.showSnackBar(SnackBar(
                          backgroundColor: Colors.white,
                          content: Text(data["message"],
                              style: TextStyle(color: Color(0xffff037c)))));
                    }
                  } else {
                    scaffoldKey.currentState.removeCurrentSnackBar();
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        backgroundColor: Colors.white,
                        content: Text("Password mismatch.",
                            style: TextStyle(color: Color(0xffff037c)))));
                  }
                },
                child: Text(
                  'Change Password',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.pinkAccent,
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
