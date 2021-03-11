import 'package:cameo/Screens/NotificationScreen.dart';
import 'package:cameo/constants.dart';
import 'package:cameo/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatefulWidget {
  GlobalKey<ScaffoldState> scaffoldKey;
  CustomAppBar({Key key, GlobalKey<ScaffoldState> scaffoldKey}) {
    this.scaffoldKey = scaffoldKey;
  }

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            child: Stack(
              children: [
                Center(
                  child: IconButton(
                      splashRadius: 22,
                      icon: Icon(Icons.notifications),
                      onPressed: () => Get.to(() => NotificationScreen())
                      // Navigator.pushNamed(context, '/notification'),
                      ),
                ),
                Positioned(
                  child: Container(
                    padding: EdgeInsets.all(3.5),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(1000)),
                    child: Text(
                      "12",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            child: Center(
              child: IconButton(
                splashRadius: 22,
                icon: Icon(Icons.message),
                onPressed: () => Navigator.pushNamed(context, '/messages'),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            child: Center(
              child: IconButton(
                splashRadius: 22,
                icon: Icon(Icons.person),
                onPressed: () async =>
                    {widget.scaffoldKey.currentState.openDrawer()},
              ),
            ),
          ),
        )
      ],
      elevation: 0.0,
      flexibleSpace: height(70.0),
      automaticallyImplyLeading: false,
      title: SingleChildScrollView(
        child: Row(
          children: [
            Image(
              image: AssetImage('assets/images/logo.png'),
              width: 70,
            ),
            width(15.0),
            // Container(
            //   width: 100,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(100),
            //     color: Color(0xff252525),
            //   ),
            //   child: Padding(
            //     padding: const EdgeInsets.only(right: 20),
            //     child: Center(
            //       child: TextField(
            //         style: kTextFieldStyle,
            //         decoration: InputDecoration(
            //           border: InputBorder.none,
            //           focusedBorder: InputBorder.none,
            //           enabledBorder: InputBorder.none,
            //           errorBorder: InputBorder.none,
            //           disabledBorder: InputBorder.none,
            //           focusColor: Colors.transparent,
            //           hintText: 'Search',
            //           hintStyle: kTextFieldHintStyle,
            //           prefixIcon: Icon(
            //             Icons.search,
            //             color: Colors.white,
            //           ),
            //         ),
            //         cursorColor: Colors.white,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
