import 'package:cameo/utils.dart';
import 'package:flutter/material.dart';

popBottomSheet({BuildContext context}) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) => BottomSheet(
      backgroundColor: Colors.transparent,
      onClosing: () => {},
      builder: (context) => Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 6,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.red,
                    child: Center(
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  height(10.0),
                  Container(
                    width: 70,
                    child: Text(
                      "Remove photo",
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.red,
                    child: Center(
                      child: Icon(
                        Icons.photo,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  height(10.0),
                  Text("Gallery")
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
