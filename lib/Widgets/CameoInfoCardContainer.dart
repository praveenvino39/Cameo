import 'package:cameo/Widgets/CameoInfo.dart';
import 'package:flutter/material.dart';

class CaemoInfoCardContainer extends StatelessWidget {
  final responseIn;
  const CaemoInfoCardContainer({Key key, this.responseIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Container(
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(
          color: Color(0xff4d4d4d),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            CameoInfo(
              title: "Responds in",
              value: "$responseIn Days",
              leadingIcon: Icons.timelapse,
              iconColor: Colors.white,
            ),
            CameoInfo(
              title: "Reviews (11)",
              value: "5.0",
              leadingIcon: Icons.star,
              iconColor: Colors.yellow.shade600,
            ),
            CameoInfo(
              title: "Fan Club",
              value: "627",
              leadingIcon: Icons.favorite,
              iconColor: Color(0xffff037c),
            ),
          ],
        ),
      ),
    );
  }
}
