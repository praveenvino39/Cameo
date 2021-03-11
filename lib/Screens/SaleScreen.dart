import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cameo/Network/networkHelper.dart';
import 'package:cameo/Widgets/FilterDropDown.dart';
import 'package:cameo/Widgets/Loading%20Indicators/LoadingIndicator.dart';
import 'package:cameo/constants.dart';
import 'package:cameo/utils.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class SaleScreen extends StatefulWidget {
  @override
  _SaleScreenState createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<DateTime> dateRange;

  String from, to;
  List<String> dropDownItems = [
    'New',
    'Pending',
    'Processing',
    'Refunded',
    'Decline',
    'Completed'
  ];

  FilePickerResult pickedFileResult;
  Uint8List pickedFile;
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
          key: _scaffoldKey,
          backgroundColor: kBodyBackgroundColor,
          appBar: AppBar(
            title: Text('My Sales'),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FlatButton(
                color: Colors.pinkAccent,
                onPressed: () async {
                  dateRange = await DateRangePicker.showDatePicker(
                    context: context,
                    initialFirstDate: DateTime.now(),
                    initialLastDate: DateTime.now(),
                    firstDate: DateTime(2020, 1),
                    lastDate: DateTime.now(),
                  );
                  setState(() {
                    from = DateFormat('yMMMd').format(dateRange[0]);
                    to = DateFormat('yMMMd').format(dateRange[1]);
                  });
                },
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(
                    Icons.date_range,
                    color: Colors.white,
                  ),
                  width(10.0),
                  Text(
                    "Select date range",
                    style: TextStyle(color: Colors.white),
                  )
                ]),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  to != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "From: $from",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "To: $to",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            "All",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                  FilterDropDown(
                    items: dropDownItems,
                    onChanged: (val) => {},
                  )
                ],
              ),
              Expanded(
                child: FutureBuilder(
                  future: ApiHelper().activities(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data["my_sale"].length,
                        itemBuilder: (context, index) => ListTile(
                          tileColor: Colors.white,
                          title: Text(snapshot.data["my_sale"][index]["title"]),
                          leading:
                              Text(snapshot.data["my_sale"][index]["order_id"]),
                          trailing: Text(
                              "${snapshot.data["my_sale"][index]['currency_sign']}${snapshot.data["my_sale"][index]['amount']}"),
                          onTap: () {
                            bool isFinished = false;
                            String value = snapshot.data["my_sale"][index]
                                ["seller_status"];
                            if (value == "6") {
                              value = "7";
                              isFinished = true;
                            }
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => StatefulBuilder(
                                builder: (context, newSetState) => BottomSheet(
                                  onClosing: () => Navigator.pop(context),
                                  builder: (context) => Padding(
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
                                                    'https://cameo.deliveryventure.com/${snapshot.data["my_sale"][index]["gig_image_thumb"]}'),
                                          ),
                                          height(12.0),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '#${snapshot.data["my_sale"][index]["order_id"]}',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  height(5.0),
                                                  Text(snapshot.data["my_sale"]
                                                      [index]["created_date"])
                                                ],
                                              ),
                                              if (value == "1")
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    color: Colors.blue,
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4),
                                                  child: Text(
                                                    "New",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                )
                                              else if (value == "2")
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    color:
                                                        Colors.yellow.shade800,
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4),
                                                  child: Text(
                                                    "Pending",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                )
                                              else if (value == "3")
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    color: Colors.blueAccent,
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4),
                                                  child: Text(
                                                    "Processing",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                )
                                              else if (value == "7" &&
                                                  !isFinished)
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    color: Colors.green,
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4),
                                                  child: Text(
                                                    "Completed Request",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                )
                                              else if (isFinished)
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    color: Colors.green,
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4),
                                                  child: Text(
                                                    "Completed",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                )
                                              else if (value == "5")
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    color: Colors.red,
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4),
                                                  child: Text(
                                                    "Declined",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                )
                                              else if (snapshot.data["my_sale"]
                                                          [index]
                                                      ["seller_status"] ==
                                                  "7")
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    color: Colors.green,
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4),
                                                  child: Text(
                                                    "Completed",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                )
                                            ],
                                          ),
                                          height(12.0),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Payment Method",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color:
                                                          Colors.grey.shade800,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                  snapshot.data["my_sale"]
                                                      [index]["source"],
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          ),
                                          height(12.0),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Product Name",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color:
                                                          Colors.grey.shade800,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                  snapshot.data["my_sale"]
                                                      [index]["title"],
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          ),
                                          height(12.0),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Grand Total",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color:
                                                          Colors.grey.shade800,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                  '${snapshot.data["my_sale"][index]["currency_sign"]}${snapshot.data["my_sale"][index]["amount"]}',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          ),
                                          Container(
                                            width: double.infinity,
                                            child: FlatButton(
                                              color: kSecondaryColor,
                                              onPressed: () async {
                                                loading(context);
                                                pickedFileResult =
                                                    await FilePicker.platform
                                                        .pickFiles(
                                                            onFileLoading:
                                                                (status) =>
                                                                    print(status
                                                                        .index),
                                                            type:
                                                                FileType.custom,
                                                            allowedExtensions: [
                                                      'zip'
                                                    ]);

                                                var file = pickedFileResult
                                                    .files.first;
                                                Map data = await ApiHelper().uploadProduct(
                                                    file: file,
                                                    gigId:
                                                        snapshot.data["my_sale"]
                                                            [index]["gigs_id"],
                                                    orderId:
                                                        snapshot.data["my_sale"]
                                                            [index]["order_id"],
                                                    sellerId: snapshot
                                                            .data["my_sale"]
                                                        [index]["seller_id"],
                                                    buyerId:
                                                        snapshot.data["my_sale"]
                                                            [index]["user_id"]);
                                                if (data["message"]
                                                        .toString() ==
                                                    "success") {
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).pop();
                                                  // FocusScope.of(context)
                                                  //     .requestFocus(FocusNode());
                                                  _scaffoldKey.currentState
                                                      .removeCurrentSnackBar();
                                                  _scaffoldKey.currentState
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        "File uploaded successfully",
                                                        style: TextStyle(
                                                            color:
                                                                kSecondaryColor),
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).pop();
                                                  _scaffoldKey.currentState
                                                      .removeCurrentSnackBar();
                                                  _scaffoldKey.currentState
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        "Something went wrong",
                                                        style: TextStyle(
                                                            color:
                                                                kSecondaryColor),
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                              child: Text(
                                                "Upload",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          Text(
                                              '(Maximum file upload size 5MB)*'),
                                          value == "7" || value == "6"
                                              ? height(10.0)
                                              : DropdownButton(
                                                  onChanged: value == "6" ||
                                                          value == "5" ||
                                                          value == "7" ||
                                                          isFinished
                                                      ? null
                                                      : (val) async {
                                                          loading(context);
                                                          print(snapshot.data[
                                                                      "my_sale"]
                                                                  [index]
                                                              ["order_id"]);
                                                          Map res = await ApiHelper()
                                                              .changeOrderStatus(
                                                                  orderId: snapshot
                                                                              .data["my_sale"]
                                                                          [
                                                                          index]
                                                                      [
                                                                      "order_id"],
                                                                  orderStatus:
                                                                      val);
                                                          if (res["code"] ==
                                                              200) {
                                                            snapshot.data[
                                                                        "my_sale"]
                                                                    [index][
                                                                "seller_status"] = val;
                                                            newSetState(() {
                                                              value = val;
                                                            });

                                                            Navigator.pop(
                                                                context);
                                                          }
                                                        },
                                                  hint: Text("Status"),
                                                  value: value,
                                                  items: [
                                                      DropdownMenuItem(
                                                        child: Text("New"),
                                                        value: "1",
                                                      ),
                                                      DropdownMenuItem(
                                                        child: Text("Pending"),
                                                        value: "2",
                                                      ),
                                                      DropdownMenuItem(
                                                        child:
                                                            Text("Processing"),
                                                        value: "3",
                                                      ),
                                                      DropdownMenuItem(
                                                        child: Text("Declined"),
                                                        value: "5",
                                                      ),
                                                      DropdownMenuItem(
                                                        child:
                                                            Text("Completed"),
                                                        value: "7",
                                                      ),
                                                    ]),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // builder: (context) => Text("Hello"),
                                ),
                              ),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
