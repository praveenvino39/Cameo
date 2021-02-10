import 'package:cameo/constants.dart';
import 'package:cameo/utils.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ChatScreen extends StatefulWidget {
  int userId;
  String username;
  ChatScreen({this.userId, this.username});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titleCase(string: widget.username)),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () => {},
            splashRadius: 23,
          ),
          PopupMenuButton(itemBuilder: (context)=>[PopupMenuItem(child: Text('Request'),),
            PopupMenuItem(child: Text('Report'),)]),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            width: MediaQuery.of(context).size.width,
            // color: kBodyBackgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Icon(Icons.emoji_emotions),
                Expanded(
                  child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      // width: MediaQuery.of(context).size.width / 1.8,
                      // constraints: BoxConstraints(maxHeight: 100),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: TextField(
                        maxLines: 3,
                        minLines: 1,
                        decoration: InputDecoration(
                          prefixIcon: IconButton(
                            splashRadius: 20,
                            icon: Icon(Icons.emoji_emotions),
                            onPressed: () => {},
                          ),
                          hintText: 'Start a conversation...',
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, color: Colors.transparent),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 0, color: Colors.transparent),
                              borderRadius: BorderRadius.circular(100)),
                        ),
                      )),
                ),
                CircleAvatar(
                  backgroundColor: Colors.black,
                  child: IconButton(
                      splashRadius: 20,
                      icon: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      onPressed: () => {},
                      color: kSecondaryColor),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
