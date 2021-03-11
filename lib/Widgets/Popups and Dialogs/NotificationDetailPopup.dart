import 'package:flutter/material.dart';

void popUpNotificationDetial(context) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) => BottomSheet(
      backgroundColor: Colors.transparent,
      onClosing: () => {},
      builder: (context) => Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('New Notificaton lorem ipsum..')],
          )),
    ),
  );
}
