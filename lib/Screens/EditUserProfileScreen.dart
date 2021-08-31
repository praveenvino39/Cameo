import 'package:cameo/Widgets/Tabs/GeneralDetailTab.dart';
import 'package:cameo/Widgets/Tabs/PasswordUpdateTab.dart';
import 'package:cameo/Widgets/Tabs/PaymentUpdateTab.dart';
import 'package:cameo/constants.dart';
import 'package:flutter/material.dart';

class EditUserProfileScreen extends StatefulWidget {
  @override
  _EditUserProfileScreenState createState() => _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends State<EditUserProfileScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  //Focus Node
  FocusNode fnName = FocusNode();

  FocusNode fnProfession = FocusNode();

  FocusNode fnDecription = FocusNode();

  FocusNode fnEmail = FocusNode();

  FocusNode fnPhone = FocusNode();

  FocusNode fnLanguage = FocusNode();

  FocusNode fnCountry = FocusNode();

  FocusNode fnAdress = FocusNode();

  FocusNode fnZipcode = FocusNode();

  FocusNode fnCity = FocusNode();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress)
          return false;
        else
          return true;
      },
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: kBodyBackgroundColor,
          appBar: AppBar(
            elevation: 2,
            title: Text("My Profile"),
            bottom: TabBar(
              indicatorColor: Colors.pinkAccent,
              labelColor: Colors.pinkAccent,
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.person,
                  ),
                ),
                Tab(icon: Icon(Icons.security_rounded)),
                Tab(icon: Icon(Icons.monetization_on)),
              ],
            ),
          ),
          body: TabBarView(children: [
            GeneralDetailTab(
              scaffoldKey: scaffoldKey,
            ),
            PasswordUpdateTab(
              scaffoldKey: scaffoldKey,
            ),
            PaymentUpdateTab(
              scaffoldKey: scaffoldKey,
            )
          ]),
        ),
      ),
    );
  }
}
