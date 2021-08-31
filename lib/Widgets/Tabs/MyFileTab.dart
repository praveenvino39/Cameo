import 'package:cameo/Network/networkHelper.dart';
import 'package:cameo/Widgets/FileTile.dart';
import 'package:flutter/material.dart';

class MyFileTab extends StatefulWidget {
  @override
  _MyFileTabState createState() => _MyFileTabState();
}

class _MyFileTabState extends State<MyFileTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  int progress = 0;
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ApiHelper().getFiles(getby: 'buyer_id'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) => FileTile(
                fileName: snapshot.data[index]["filename"],
                orderId: snapshot.data[index]["order_id"],
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
