import 'package:cameo/Network/networkHelper.dart';
import 'package:cameo/Screens/CameoDetailScreen.dart';
import 'package:cameo/Screens/ChatScreen.dart';
import 'package:get/get.dart';
import 'package:cameo/Screens/EditCameoScreen.dart';
import 'package:cameo/Widgets/SvgButton.dart';
import 'package:cameo/models/cameo_model.dart';
import 'package:cameo/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../utils.dart';

Widget callToActionButtons({Cameo cameo, User user}) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Container(
          width: double.infinity,
          height: 40,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
          child: user.userid == cameo.gigsDetails.userId
              ? CustomButton(
                  buttonText: "Edit",
                  onPressed: () => Get.to(
                      () => EditCameoScreen(
                            cameoDetail: cameo.gigsDetails.toJson(),
                            videos: cameo.videoPath,
                          ),
                      transition: Transition.rightToLeft,
                      duration: Duration(milliseconds: 300)),
                )
              : CustomButton(
                  onPressed: () => Get.defaultDialog(
                      radius: 5,
                      title: "Continue with",
                      content: Center(
                        child: Container(
                          padding: EdgeInsets.all(5),
                          width: Get.width / 1.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                          ),
                          child: Column(children: [
                            SvgButton(
                                onPressed: () async {
                                  // ApiHelper().updatePaypalPaymentSuccess();
                                  ApiHelper().createOrder(
                                      cameo: cameo, source: "paypal");
                                },
                                assetPath: 'assets/images/paypal.svg',
                                backgroundColor: Colors.white,
                                svgSize: 20,
                                title: 'Paypal'),
                            SvgButton(
                              onPressed: () async {
                                ApiHelper().createOrder(
                                    cameo: cameo, source: "stripe");
                              },
                              assetPath: 'assets/images/stripe.svg',
                              backgroundColor: Colors.white,
                              svgSize: 20,
                              title: 'Stripe',
                            ),
                            // Container(
                            //   width: 190,
                            //   child: OutlineButton(
                            //     onPressed: () {
                            //       Get.to(() => HelpScreen());
                            //     },
                            //     highlightColor: Colors.transparent,
                            //     shape: new RoundedRectangleBorder(
                            //         borderRadius:
                            //             new BorderRadius.circular(30.0)),
                            //     child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.center,
                            //       children: [
                            //         Image(
                            //           width: 20,
                            //           image: AssetImage(
                            //               'assets/images/paytabs.png'),
                            //         ),
                            //         width(4.0),
                            //         Text("Paytabs")
                            //       ],
                            //     ),
                            //   ),
                            // )
                          ]),
                        ),
                      )),
                  buttonText:
                      'Request ${cameo.gigsDetails.currencySign}${cameo.gigsDetails.gigPrice}'),
        ),
      ),
      user.userid != cameo.gigsDetails.userId
          ? Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
              child: Container(
                width: double.infinity,
                height: 40,
                clipBehavior: Clip.hardEdge,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
                child: FlatButton(
                  onPressed: () async {
                    Get.to(() => ChatScreen(), arguments: {
                      "username": cameo.gigsDetails.username,
                      "user_id": cameo.gigsDetails.userId
                    });
                  },
                  child: Text(
                    'Chat ',
                    style: kAuthTitleStyle.copyWith(
                        color: Colors.white, fontSize: 16),
                  ),
                  color: Color(0xffff037c),
                ),
              ),
            )
          : width(10.0),
      height(30.0),
    ],
  );
}
