import 'dart:convert';
import 'package:cameo/Network/userSesionHelper.dart';
import 'package:cameo/Widgets/Loading%20Indicators/LoadingIndicator.dart';
import 'package:cameo/providers/user_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cameo/utils.dart';
import 'package:flutter/material.dart';
import 'package:cameo/constants.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:cameo/Network/networkHelper.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final UserSession userSession = UserSession();
  final storage = new FlutterSecureStorage();
  String email;
  String password;
  FormState form;

  //Focus Node
  FocusNode fnUsername = FocusNode();
  FocusNode fnPassword = FocusNode();
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Welcome back to Cameo',
                  style:
                      kAuthTitleStyle.copyWith(color: Colors.yellow.shade800),
                  textAlign: TextAlign.center,
                  textWidthBasis: TextWidthBasis.parent,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Theme(
                    data: ThemeData(primaryColor: Colors.yellow.shade800),
                    child: TextFormField(
                      focusNode: fnUsername,
                      onEditingComplete: () =>
                          FocusScope.of(context).requestFocus(fnPassword),
                      validator: MinLengthValidator(1,
                          errorText: "Username should not be empty"),
                      onChanged: (value) => setState(() => email = value),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(hintText: 'Username'),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Theme(
                    data: ThemeData(primaryColor: Colors.yellow.shade800),
                    child: TextFormField(
                      focusNode: fnPassword,
                      validator:
                          RequiredValidator(errorText: "Password is required"),
                      onChanged: (value) => setState(() => password = value),
                      obscureText: true,
                      decoration: InputDecoration(hintText: 'Password'),
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () =>
                      validateAndLogin(email, password, userProvider),
                  child: Text(
                    'Login',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        color: Colors.white),
                  ),
                  color: Colors.yellow.shade800,
                ),
                height(20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Do not have an account '),
                    GestureDetector(
                      child: Text(
                        'just create one',
                        style: TextStyle(color: Colors.yellow.shade800),
                      ),
                      onTap: () =>
                          Navigator.popAndPushNamed(context, '/signup'),
                    )
                  ],
                ),
                //Invisble Sized Box for Cross Axis Center alignment
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  validateAndLogin(
      String email, String password, UserProvider userProvider) async {
    bool isValid = _formKey.currentState.validate();
    if (isValid) {
      loading(context);
      ApiHelper apiHelper = ApiHelper();
      http.Response res =
          await apiHelper.login({"username": email, "password": password});
      Map data = jsonDecode(res.body);
      switch (data["code"]) {
        case 200:
          userSession.presistUser(
              token: data["data"][0]["userid"],
              username: data["data"][0]["username"]);
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          break;
        case 404:
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Container(
                height: 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.warning,
                          color: Colors.red,
                        ),
                        width(10.0),
                        Text(data["message"]),
                      ],
                    ),
                    FlatButton(
                      onPressed: () async => {Navigator.pop(context)},
                      child: Text(
                        'Try again',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                            color: Colors.white),
                      ),
                      color: Colors.yellow.shade800,
                    ),
                  ],
                ),
              ),
            ),
          );
          break;
        default:
      }
    }
  }
}
