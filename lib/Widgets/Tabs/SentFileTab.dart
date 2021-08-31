import 'package:cameo/Network/networkHelper.dart';
import 'package:cameo/Widgets/FileTile.dart';
import 'package:flutter/material.dart';

class SentFileTab extends StatefulWidget {
  @override
  _SentFileTabState createState() => _SentFileTabState();
}

class _SentFileTabState extends State<SentFileTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ApiHelper().getFiles(getby: 'seller_id'),
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
