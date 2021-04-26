import 'dart:convert';
import 'package:cameo/Network/networkHelper.dart';
import 'package:cameo/Widgets/Loading%20Indicators/LoadingIndicator.dart';
import 'package:cameo/constants.dart';
import 'package:cameo/utils.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:rich_alert/rich_alert.dart';
import 'package:http/http.dart' as http;

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ApiHelper apiHelper = ApiHelper();
  String fullname;
  String username;
  String email;
  String password;
  int countryId;
  int stateId;
  var countries = [];
  String selectedCountry = 'Country';
  String selectedState = 'State';
  var states = [];

  //Validators for email and password
  final emailValidator =
      MultiValidator([EmailValidator(errorText: "Please provide valid email")]);
  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'password is required'),
    MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: 'passwords must have at least one special character')
  ]);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: FutureBuilder(
              future: apiHelper.country(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  countries = jsonDecode(snapshot.data.body);
                  return Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        height(70.0),
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Welcome to Cameo',
                                style: kAuthTitleStyle.copyWith(
                                    color: Colors.yellow.shade800),
                                textAlign: TextAlign.center,
                                textWidthBasis: TextWidthBasis.parent,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                child: Theme(
                                  data: ThemeData(
                                      primaryColor: Colors.yellow.shade800),
                                  child: TextFormField(
                                    validator: MinLengthValidator(1,
                                        errorText:
                                            "Fullname should not be empty"),
                                    onChanged: (value) =>
                                        setState(() => {fullname = value}),
                                    keyboardType: TextInputType.name,
                                    decoration:
                                        InputDecoration(hintText: 'Fullname'),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                child: Theme(
                                  data: ThemeData(
                                      primaryColor: Colors.yellow.shade800),
                                  child: TextFormField(
                                    validator: MinLengthValidator(1,
                                        errorText:
                                            "Username should not be empty"),
                                    onChanged: (value) =>
                                        setState(() => {username = value}),
                                    keyboardType: TextInputType.emailAddress,
                                    decoration:
                                        InputDecoration(hintText: 'Username'),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                child: Theme(
                                  data: ThemeData(
                                      primaryColor: Colors.yellow.shade800),
                                  child: TextFormField(
                                    validator: emailValidator,
                                    onChanged: (value) =>
                                        setState(() => {email = value}),
                                    keyboardType: TextInputType.emailAddress,
                                    decoration:
                                        InputDecoration(hintText: 'Email'),
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                child: Theme(
                                  data: ThemeData(
                                      primaryColor: Colors.yellow.shade800),
                                  child: TextFormField(
                                    validator: passwordValidator,
                                    onChanged: (value) =>
                                        setState(() => {password = value}),
                                    obscureText: true,
                                    decoration:
                                        InputDecoration(hintText: 'Password'),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                child: DropdownButton(
                                  isExpanded: true,
                                  hint: Text(selectedCountry),
                                  items: countries.map((value) {
                                    return new DropdownMenuItem<String>(
                                      value: value["id"],
                                      child: Text(value["country"]),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCountry =
                                          countries[int.parse(value) - 1]
                                              ["country"];
                                      countryId = int.parse(value);
                                      getState();
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                child: DropdownButton(
                                  isExpanded: true,
                                  hint: Text(selectedState),
                                  items: states.map((value) {
                                    return DropdownMenuItem<String>(
                                      value: value["state_id"],
                                      child: Text(value["state_name"]),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      var e = states.firstWhere((element) =>
                                          element["state_id"] == value);
                                      selectedState = e["state_name"];
                                      stateId = int.parse(e["state_id"]);
                                    });
                                  },
                                ),
                              ),

                              FlatButton(
                                onPressed: () => validateAndSignup(),
                                child: Text(
                                  'Signup',
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
                                  Text('Already have an account '),
                                  GestureDetector(
                                    child: Text(
                                      'just login',
                                      style: TextStyle(
                                          color: Colors.yellow.shade800),
                                    ),
                                    onTap: () => Navigator.popAndPushNamed(
                                        context, '/login'),
                                  )
                                ],
                              ),
                              //Invisble Sized Box for Cross Axis Center alignment
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                              )
                            ],
                          ),
                        ),
                        height(200.0),
                        Text(
                            "By signing up you're accepting our terms and conditions"),
                      ],
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                      child: Text("Error fetching countries from server"));
                } else {
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation(Colors.yellow.shade800),
                          ),
                        ),
                        height(10.0),
                        Text("Fetching available countries")
                      ],
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }

  //signupHandler Function
  void validateAndSignup() async {
    bool isValid = _formKey.currentState.validate();
    if (isValid && countryId != null && stateId != null) {
      loading(context);
      http.Response res = await apiHelper.registration({
        "fullname": fullname,
        "username": username,
        "email": email,
        "country": countryId.toString(),
        "state": stateId.toString()
      });
      Map data = jsonDecode(res.body);
      switch (data["code"]) {
        case 200:
          //Show emailAlert popup with login button
          // Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          // showDialog(
          //   context: context,
          //   builder: (context) => RichAlertDialog(
          //     //uses the custom alert dialo
          //     alertTitle: richTitle("Success"),
          //     alertSubtitle: richSubtitle(data["message"]),
          //     alertType: RichAlertType.SUCCESS,
          //     actions: [
          //       FlatButton(
          //         child: Text("Login", style: TextStyle(color: Colors.white)),
          //         color: Colors.green,
          //         onPressed: () => Navigator.popAndPushNamed(context, '/login'),
          //       )
          //     ],
          //   ),
          // );
          Navigator.pop(context);
          Navigator.pop(context);
          Get.defaultDialog(
            middleText: data["message"],
            titleStyle: TextStyle(color: Colors.yellow.shade800),
          );
          break;
        case 404:
          //Show Http Error message and try button
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (context) => RichAlertDialog(
              //uses the custom alert dialog
              alertTitle: richTitle("Alert title"),
              alertSubtitle: richSubtitle(data["message"]),
              alertType: RichAlertType.ERROR,
              actions: [
                FlatButton(
                    child: Text("Try again",
                        style: TextStyle(color: Colors.white)),
                    color: Colors.red,
                    onPressed: () => {
                          Navigator.popUntil(
                              context, ModalRoute.withName('/signup'))
                        })
              ],
            ),
          );
          break;
        default:
      }
    }
  }

  void getState() async {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.yellow.shade800),
        ),
      ),
    );
    http.Response res = await apiHelper.state(countryId);
    setState(() {
      states = jsonDecode(res.body);
      Navigator.pop(context);
    });
  }
}
