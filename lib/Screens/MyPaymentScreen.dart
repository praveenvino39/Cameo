import 'package:cached_network_image/cached_network_image.dart';
import 'package:cameo/Network/networkHelper.dart';
import 'package:cameo/Widgets/FilterDropDown.dart';
import 'package:cameo/Widgets/Loading%20Indicators/LoadingIndicator.dart';
import 'package:cameo/constants.dart';
import 'package:cameo/utils.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cameo/Network/networkHelper.dart';
import 'package:intl/intl.dart';

class MyPaymentScreen extends StatefulWidget {
  @override
  _MyPaymentScreenState createState() => _MyPaymentScreenState();
}

class _MyPaymentScreenState extends State<MyPaymentScreen> {
  List<DateTime> dateRange;
  String from, to;
  List<String> dropDownItems = ['Request sent', 'Payment received'];
  ApiHelper apiHelper = ApiHelper();
  List data = [].obs;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress)
          return false;
        else
          return true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: kBodyBackgroundColor,
          appBar: AppBar(
            title: Text('My Payments'),
          ),
          body: FutureBuilder(
              future: apiHelper.activities(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  data = snapshot.data["my_payments"];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) => ListTile(
                                tileColor: Colors.white,
                                title: Text(
                                    titleCase(string: data[index]["title"])),
                                leading: Icon(Icons.monetization_on),
                                trailing: Text(
                                    "${data[index]["currency_sign"]}${data[index]["amount"]}"),
                                onTap: () => showModalBottomSheet(
                                    context: context,
                                    builder: (context) => StatefulBuilder(
                                          builder: (context, newSetState) =>
                                              BottomSheet(
                                            onClosing: () =>
                                                Navigator.pop(context),
                                            builder: (context) => Container(
                                              height: Get.height / 2.5,
                                              padding: EdgeInsets.all(16.0),
                                              color: Colors.white,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CircleAvatar(
                                                    radius: 25,
                                                    backgroundImage:
                                                        CachedNetworkImageProvider(
                                                            "$domainUrl/${data[index]["gig_image_thumb"]}"),
                                                  ),
                                                  height(12.0),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '#${data[index]["order_id"]}',
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          height(5.0),
                                                          Text(data[index]
                                                              ["created_date"])
                                                        ],
                                                      ),
                                                      data[index]["payment_status"] !=
                                                              "0"
                                                          ? Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100),
                                                                color:
                                                                    Colors.blue,
                                                              ),
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          4),
                                                              child: Text(
                                                                data[index][
                                                                    "withdraw_message"],
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            )
                                                          : RaisedButton(
                                                              onPressed:
                                                                  () async {
                                                                loading(
                                                                    context);
                                                                var resData = await apiHelper
                                                                    .withdrawRequest(
                                                                        order_id:
                                                                            data[index]["order_id"]);
                                                                data[index][
                                                                        "withdraw_message"] =
                                                                    resData["data"]
                                                                        ["msg"];
                                                                if (resData[
                                                                        "status"] ==
                                                                    true)
                                                                  newSetState(
                                                                      () => {
                                                                            data[index]["withdraw_message"] =
                                                                                "Request Sent",
                                                                            data[index]["payment_status"] =
                                                                                "1",
                                                                          });

                                                                Get.back();
                                                              },
                                                              child: Text(
                                                                "Withdraw",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                              color:
                                                                  kSecondaryColor,
                                                            ),
                                                    ],
                                                  ),
                                                  height(12.0),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text("Product Name",
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: Colors.grey
                                                                  .shade800,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      Text(data[index]["title"],
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ],
                                                  ),
                                                  height(12.0),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text("Grand Total",
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: Colors.grey
                                                                  .shade800,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      Text(
                                                          '${data[index]["currency_sign"]}${data[index]["amount"]}',
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ))),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
      ),
    );
  }
}
