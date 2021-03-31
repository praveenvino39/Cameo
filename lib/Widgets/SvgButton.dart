import 'package:cameo/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgButton extends StatelessWidget {
  final String assetPath;
  final Color backgroundColor;
  final double svgSize;
  final String title;
  final Function onPressed;
  const SvgButton({
    Key key,
    this.onPressed,
    this.assetPath,
    this.backgroundColor,
    this.svgSize,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      child: OutlineButton(
        onPressed: onPressed,
        highlightColor: Colors.transparent,
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              assetPath,
              width: svgSize,
            ),
            width(10.0),
            Text(title)
          ],
        ),
      ),
    );
  }
}
