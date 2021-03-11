import 'package:cameo/Widgets/Tabs/MyFileTab.dart';
import 'package:cameo/Widgets/Tabs/SentFileTab.dart';
import 'package:cameo/constants.dart';
import 'package:flutter/material.dart';

class FileScreen extends StatefulWidget {
  @override
  _FileScreenState createState() => _FileScreenState();
}

class _FileScreenState extends State<FileScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: kBodyBackgroundColor,
        appBar: AppBar(
          title: Text("Files"),
          bottom: TabBar(tabs: [
            Tab(
              child: Text("My files"),
            ),
            Tab(
              child: Text("Sent files"),
            ),
          ]),
        ),
        body: TabBarView(children: [
          MyFileTab(),
          SentFileTab(),
        ]),
      ),
    );
  }
}
