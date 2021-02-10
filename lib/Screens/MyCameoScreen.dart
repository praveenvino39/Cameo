import 'package:cameo/Widgets/CustomCard.dart';
import 'package:cameo/constants.dart';
import 'package:cameo/utils.dart';
import 'package:flutter/material.dart';

class MyCameoScreen extends StatefulWidget {
  @override
  _MyCameoScreenState createState() => _MyCameoScreenState();
}

class _MyCameoScreenState extends State<MyCameoScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Cameos"),
        ),
        backgroundColor: kBodyBackgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SingleChildScrollView(
                  child: GridView.count(
                    physics: ScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                    shrinkWrap: true,
                    children: List.generate(
                      20,
                      (index) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                    'https://d31wcbk3iidrjq.cloudfront.net/UFtPf1TjL_avatar-5N0uIMgaL.jpg?h=332&w=332&q=100'),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                width(MediaQuery.of(context).size.width)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
