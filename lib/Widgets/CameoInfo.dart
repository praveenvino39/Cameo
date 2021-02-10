// ignore: must_be_immutable
import 'package:cameo/utils.dart';
import 'package:flutter/material.dart';

class CameoInfo extends StatelessWidget {
  String title;
  String value;
  IconData icon;
  Color iconColor;
  CameoInfo(
      {Key key,
      String title,
      String value,
      IconData leadingIcon,
      Color iconColor}) {
    this.title = title;
    this.value = value;
    this.iconColor = iconColor;
    this.icon = leadingIcon;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                right: BorderSide(
          width: 1,
        ))),
        width: MediaQuery.of(context).size.width * 0.25,
        height: double.infinity,
        // decoration: BoxDecoration(color: Colors.red),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            height(5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: iconColor,
                ),
                width(5.0),
                Text(
                  value,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
