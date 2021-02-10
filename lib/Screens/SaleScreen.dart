import 'package:cameo/Widgets/FilterDropDown.dart';
import 'package:cameo/constants.dart';
import 'package:cameo/utils.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SaleScreen extends StatefulWidget {
  @override
  _SaleScreenState createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
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
                child: Container(
                  child: ListView.builder(
                      itemBuilder: (context, index) => ListTile(
                          tileColor: Colors.white,
                          title: Text("New Sale"),
                          leading: Icon(Icons.monetization_on),
                          trailing: Text("\$50"),
                          onTap: () => showModalBottomSheet(
                              context: context,
                              builder: (context) => BottomSheet(
                                    onClosing: () => Navigator.pop(context),
                                    builder: (context) => Center(
                                      child: Text("New Sales"),
                                    ),
                                  )))),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
