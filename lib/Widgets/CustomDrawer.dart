import 'package:cameo/Screens/MyCameoScreen.dart';
import 'package:cameo/Screens/EditUserProfileScreen.dart';
import 'package:cameo/Screens/MyPaymentScreen.dart';
import 'package:cameo/Screens/MyPurchaseScreen.dart';
import 'package:cameo/Screens/SaleScreen.dart';
import 'package:cameo/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:getwidget/getwidget.dart';

import '../constants.dart';

class CustomDrawer extends StatelessWidget {
  final storage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GFDrawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            GFDrawerHeader(
              otherAccountsPictures: [
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 23,
                  ),
                  tooltip: 'Edit Profile',
                  onPressed: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => EditUserProfileScreen(),
                    ),
                  ),
                ),
              ],
              closeButton: SizedBox(),
              currentAccountPicture: GFAvatar(
                radius: 80.0,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(
                    'https://d31wcbk3iidrjq.cloudfront.net/UFtPf1TjL_avatar-5N0uIMgaL.jpg?h=332&w=332&q=100'),
              ),
              decoration: BoxDecoration(
                  color: Color(0xff101010),
                  gradient: LinearGradient(
                      colors: [Colors.pink.shade300, Colors.blue.shade300])),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Username",
                    style: kCardName,
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
              onTap: () async => {},
            ),
            ListTile(
              leading: Icon(Icons.video_call),
              title: Text('My Cameo'),
              onTap: () => {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => MyCameoScreen()))
              },
            ),
            ListTile(
              leading: Icon(Icons.money),
              title: Text('My Purchase'),
              onTap: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => MyPurchaseScreen(),
                  )),
            ),
            ListTile(
              leading: Icon(Icons.monetization_on),
              title: Text('Sales'),
              onTap: () => Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => SaleScreen())),
            ),
            ListTile(
              leading: Icon(Icons.payment),
              title: Text('Payments'),
              onTap: () => Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => MyPaymentScreen(),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () => {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => EditUserProfileScreen())),
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Logout'),
              onTap: () async => {
                Navigator.popAndPushNamed(context, '/login'),
                await storage.delete(key: "user_id")
              },
            ),
          ],
        ),
      ),
    );
  }
}
