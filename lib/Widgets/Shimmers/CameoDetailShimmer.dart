import 'package:cameo/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CameoDetailShimmer extends StatefulWidget {
  CameoDetailShimmer({Key key}) : super(key: key);

  @override
  _CameoDetailShimmerState createState() => _CameoDetailShimmerState();
}

class _CameoDetailShimmerState extends State<CameoDetailShimmer> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (Navigator.of(context).userGestureInProgress)
            return false;
          else
            return true;
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 20, left: 10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.grey.shade900,
                            highlightColor: Colors.grey.shade800,
                            period: Duration(milliseconds: 700),
                            child: CircleAvatar(
                              radius: 56,
                              child: Container(),
                            ),
                          ),
                          width(20.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width / 2.2,
                                  child: Shimmer.fromColors(
                                      period: Duration(milliseconds: 700),
                                      baseColor: Colors.grey.shade900,
                                      highlightColor: Colors.grey.shade800,
                                      child: Container(
                                        width: 200,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.white,
                                        ),
                                      ))),
                              height(8.0),
                              Container(
                                width: MediaQuery.of(context).size.width / 1.8,
                                child: Shimmer.fromColors(
                                  period: Duration(milliseconds: 700),
                                  baseColor: Colors.grey.shade900,
                                  highlightColor: Colors.grey.shade800,
                                  child: Container(
                                    width: 200,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(child: Container()),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container()),
            ],
          ),
        ));
  }
}
