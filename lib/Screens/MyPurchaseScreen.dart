import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cameo/Network/networkHelper.dart';
import 'package:cameo/Widgets/Loading%20Indicators/LoadingIndicator.dart';
import 'package:cameo/constants.dart';
import 'package:cameo/utils.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

class MyPurchaseScreen extends StatefulWidget {
  @override
  _MyPurchaseScreenState createState() => _MyPurchaseScreenState();
}

class _MyPurchaseScreenState extends State<MyPurchaseScreen> {
  List<DateTime> dateRange;
  String from, to;
  TextEditingController rejectTextController = TextEditingController();
  bool isFinished = false;
  bool isRejected = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<String> dropDownItems = [
    'New',
    'Pending',
    'Processing',
    'Refunded',
    'Decline',
    'Completed'
  ];
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
        child: RefreshIndicator(
          color: kSecondaryColor,
          onRefresh: () async => ApiHelper().activities(),
          child: Scaffold(
            backgroundColor: kBodyBackgroundColor,
            appBar: AppBar(
              title: Text('My Purchase'),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // FlatButton(
                //   color: Colors.pinkAccent,
                //   onPressed: () async {
                //     dateRange = await DateRangePicker.showDatePicker(
                //       context: context,
                //       initialFirstDate: DateTime.now(),
                //       initialLastDate: DateTime.now(),
                //       firstDate: DateTime(2020, 1),
                //       lastDate: DateTime.now(),
                //     );
                //     setState(() {
                //       from = DateFormat('yMMMd').format(dateRange[0]);
                //       to = DateFormat('yMMMd').format(dateRange[1]);
                //     });
                //   },
                //   child:
                //       Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                //     Icon(
                //       Icons.date_range,
                //       color: Colors.white,
                //     ),
                //     width(10.0),
                //     Text(
                //       "Select date range",
                //       style: TextStyle(color: Colors.white),
                //     )
                //   ]),
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     to != null
                //         ? Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Padding(
                //                 padding: const EdgeInsets.all(8.0),
                //                 child: Text(
                //                   "From: $from",
                //                   style: TextStyle(
                //                       color: Colors.white, fontSize: 15),
                //                 ),
                //               ),
                //               Padding(
                //                 padding: const EdgeInsets.all(8.0),
                //                 child: Text(
                //                   "To: $to",
                //                   style: TextStyle(
                //                       color: Colors.white, fontSize: 15),
                //                 ),
                //               ),
                //             ],
                //           )
                //         : Padding(
                //             padding: const EdgeInsets.only(left: 20.0),
                //             child: Text(
                //               "All",
                //               style: TextStyle(color: Colors.white, fontSize: 15),
                //             ),
                //           ),
                //     FilterDropDown(
                //       items: dropDownItems,
                //       onChanged: (value) => {print(value)},
                //     )
                //   ],
                // ),
                Expanded(
                  child: Container(
                    child: FutureBuilder(
                      future: ApiHelper().activities(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data["my_purchases"].length,
                            itemBuilder: (context, index) => ListTile(
                              tileColor: Colors.white,
                              title: Text(snapshot.data["my_purchases"][index]
                                  ["title"]),
                              leading: Text(snapshot.data["my_purchases"][index]
                                  ["order_id"]),
                              trailing: Text(
                                  "${snapshot.data["my_purchases"][index]['currency_sign']}${snapshot.data["my_purchases"][index]['amount']}"),
                              onTap: () {
                                log(snapshot.data["my_purchases"][index]
                                    ["seller_status"]);
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return StatefulBuilder(
                                      builder: (context, newSetState) =>
                                          BottomSheet(
                                        onClosing: () => Navigator.pop(context),
                                        builder: (context) {
                                          String dropDownValue;
                                          var value =
                                              snapshot.data["my_purchases"]
                                                  [index]["seller_status"];
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CircleAvatar(
                                                    radius: 25,
                                                    backgroundImage:
                                                        CachedNetworkImageProvider(
                                                            '$domainUrl/${snapshot.data["my_purchases"][index]["gig_image_thumb"]}'),
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
                                                            '#${snapshot.data["my_purchases"][index]["order_id"]}',
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          height(5.0),
                                                          Text(snapshot.data[
                                                                      "my_purchases"]
                                                                  [index]
                                                              ["created_date"])
                                                        ],
                                                      ),
                                                      if (value == "1")
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                            color: Colors.blue,
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 4),
                                                          child: Text(
                                                            "New",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        )
                                                      else if (value == "2")
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                            color: Colors.yellow
                                                                .shade800,
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 4),
                                                          child: Text(
                                                            "Pending",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        )
                                                      else if (value == "3")
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                            color: Colors
                                                                .blueAccent,
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 4),
                                                          child: Text(
                                                            "Processing",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        )
                                                      else if (value == "7" &&
                                                          !isFinished)
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                            color: Colors.green,
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 4),
                                                          child: Text(
                                                            "Completed Request",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        )
                                                      else if (isFinished ||
                                                          value == "6")
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                            color: Colors.green,
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 4),
                                                          child: Text(
                                                            "Completed",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        )
                                                      else if (value == "5")
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                            color: Colors.red,
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 4),
                                                          child: Text(
                                                            "Declined",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        )
                                                      else if (value == "9" ||
                                                          snapshot.data["my_purchases"]
                                                                      [index][
                                                                  "reject_count"] ==
                                                              "1" ||
                                                          isRejected)
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                            color: Colors.red,
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 4),
                                                          child: Text(
                                                            "Rejected",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        )
                                                      else if (snapshot.data[
                                                                          "my_purchases"]
                                                                      [index][
                                                                  "seller_status"] ==
                                                              "7" ||
                                                          snapshot.data["my_purchases"]
                                                                      [index][
                                                                  "seller_status"] ==
                                                              "8")
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                            color: Colors.green,
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 4),
                                                          child: Text(
                                                            "Completed",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        )
                                                    ],
                                                  ),
                                                  height(12.0),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text("Payment Method",
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: Colors.grey
                                                                  .shade800,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      Text(
                                                          snapshot.data[
                                                                  "my_purchases"]
                                                              [index]["source"],
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
                                                      Text("Product Name",
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: Colors.grey
                                                                  .shade800,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      Text(
                                                          snapshot.data[
                                                                  "my_purchases"]
                                                              [index]["title"],
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
                                                          '${snapshot.data["my_purchases"][index]["currency_sign"]}${snapshot.data["my_purchases"][index]["amount"]}',
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      // value == '7'
                                                      //     ? DropdownButton(
                                                      //         onChanged: value ==
                                                      //                 "6"
                                                      //             ? null
                                                      //             : (val) async {
                                                      //                 if (val ==
                                                      //                     "6") {

                                                      //                   } else {
                                                      //                     Navigator.pop(
                                                      //                         context);
                                                      //                     Navigator.pop(
                                                      //                         context);
                                                      //                     log("rejecting");
                                                      //                   }
                                                      //                 }
                                                      //               },
                                                      //         hint: Text("Status"),
                                                      //         value: dropDownValue,
                                                      //         items: [
                                                      //             DropdownMenuItem(
                                                      //               onTap: () => {
                                                      //                 print(value)
                                                      //               },
                                                      //               child: Text(
                                                      //                   "Completed"),
                                                      //               value: "6",
                                                      //             ),
                                                      //             DropdownMenuItem(
                                                      //               child: Text(
                                                      //                   "Rejected"),
                                                      //               value: "8",
                                                      //             ),
                                                      //           ])
                                                      //     : height(10.0),
                                                      value == "7"
                                                          ? Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                RaisedButton(
                                                                  onPressed:
                                                                      () async {
                                                                    loading(
                                                                        context);
                                                                    Map res = await ApiHelper().changeOrderStatusBuyer(
                                                                        orderId: snapshot.data["my_purchases"][index]
                                                                            [
                                                                            "order_id"],
                                                                        orderStatus:
                                                                            "6");

                                                                    if (res !=
                                                                        null) {
                                                                      newSetState(
                                                                          () {
                                                                        isFinished =
                                                                            true;
                                                                        value =
                                                                            "6";
                                                                      });
                                                                      setState(
                                                                          () {
                                                                        snapshot.data["my_purchases"][index]["seller_status"] =
                                                                            "6";
                                                                      });
                                                                      Navigator.pop(
                                                                          context);
                                                                    }
                                                                  },
                                                                  child: Text(
                                                                    "Accept",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                  color: Colors
                                                                      .green
                                                                      .shade400,
                                                                ),
                                                                width(20.0),
                                                                Form(
                                                                  key: _formKey,
                                                                  child:
                                                                      RaisedButton(
                                                                    onPressed:
                                                                        () {
                                                                      Get.defaultDialog(
                                                                          actions: [
                                                                            RaisedButton(
                                                                              color: Colors.red.shade400,
                                                                              onPressed: () async {
                                                                                if (_formKey.currentState.validate()) {
                                                                                  if (rejectTextController.text.length <= 0) {
                                                                                    Get.snackbar("Alert", "Reject reason shouldn\'t be empty", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.yellow.shade800, margin: EdgeInsets.all(0), borderRadius: 0);
                                                                                  } else {
                                                                                    loading(context);
                                                                                    print(snapshot.data["my_purchases"][index]["gigs_id"]);
                                                                                    var data = await ApiHelper().rejectCameo(order_id: snapshot.data["my_purchases"][index]["order_id"], seller_id: snapshot.data["my_purchases"][index]["seller_id"], gig_id: snapshot.data["my_purchases"][index]["gigs_id"], reject_reason: rejectTextController.text);
                                                                                    if (data) {
                                                                                      Get.back();
                                                                                      Get.back();
                                                                                      Get.back();
                                                                                      Get.back();
                                                                                      Get.to(() => MyPurchaseScreen());
                                                                                      newSetState(() {
                                                                                        isRejected = true;
                                                                                        value = "9";
                                                                                        snapshot.data["my_purchases"][index]["reject_count"] = "1";
                                                                                      });
                                                                                    }
                                                                                  }
                                                                                }
                                                                              },
                                                                              child: Text(
                                                                                "Reject",
                                                                                style: TextStyle(color: Colors.white),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                          title: "Reject reason",
                                                                          middleText: "",
                                                                          content: TextFormField(
                                                                            validator:
                                                                                RequiredValidator(errorText: "Reject reason is required"),
                                                                            controller:
                                                                                rejectTextController,
                                                                            maxLines:
                                                                                3,
                                                                            decoration:
                                                                                InputDecoration(
                                                                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: kSecondaryColor)),
                                                                              border: OutlineInputBorder(
                                                                                borderSide: BorderSide(color: kSecondaryColor),
                                                                              ),
                                                                            ),
                                                                          ));
                                                                    },
                                                                    child: Text(
                                                                      "Reject",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                    color: Colors
                                                                        .red
                                                                        .shade400,
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          : width(0.0),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          return Text("Something went wrong");
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
