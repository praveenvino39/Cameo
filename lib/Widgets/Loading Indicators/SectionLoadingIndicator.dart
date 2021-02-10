import 'package:cameo/utils.dart';
import 'package:flutter/material.dart';

class SectionLoadingIndicator extends StatelessWidget {
  const SectionLoadingIndicator({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 40),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        Text(
          "Popular Cameos",
          style: TextStyle(fontSize: 22, color: Colors.white),
        )
      ],
    );
  }
}
