import 'package:flutter/material.dart';
import '../constants.dart';

class Teaser extends StatelessWidget {
  const Teaser({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.08,
      height: 238,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          color: Colors.red, borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Stack(children: [
        Image(
          image: AssetImage('assets/images/teaser.gif'),
          fit: BoxFit.cover,
        ),
        Center(
          child: Text(
            'Personalized videos feat. your favorite stars',
            textAlign: TextAlign.center,
            style: kTeaseTextStyle,
          ),
        )
      ]),
    );
  }
}
