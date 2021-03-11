import 'package:cameo/Network/networkHelper.dart';
import 'package:cameo/constants.dart';
import 'package:cameo/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';

// ignore: must_be_immutable
class ChatScreen extends StatefulWidget {
  int userId;
  String username;
  ChatScreen({this.userId, this.username});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _message = TextEditingController();
  ScrollController _controller = ScrollController();
  List messages = [];

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
          PopupMenuButton(
              itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text('Request'),
                    ),
                    PopupMenuItem(
                      child: Text('Report'),
                    )
                  ]),
        ],
      ),
      body: Stack(
        children: [
          FutureBuilder(
            future: ApiHelper().getMessages(id: widget.userId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                messages = snapshot.data["data"];
                return Container(
                  margin: EdgeInsets.only(bottom: 100),
                  padding: EdgeInsets.symmetric(horizontal: 7),
                  height: double.infinity,
                  width: double.infinity,
                  child: ListView.builder(
                    reverse: true,
                    controller: _controller,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => ChatBubble(
                      clipper: ChatBubbleClipper1(
                          type: messages[index]["chat_from"] ==
                                  snapshot.data["current_user_id"]
                              ? BubbleType.sendBubble
                              : BubbleType.receiverBubble),
                      alignment: messages[index]["chat_from"] ==
                              snapshot.data["current_user_id"]
                          ? Alignment.topRight
                          : Alignment.topLeft,
                      margin: EdgeInsets.only(top: 20),
                      backGroundColor: messages[index]["chat_from"] ==
                              snapshot.data["current_user_id"]
                          ? kSecondaryColor.withOpacity(0.8)
                          : kSecondaryColor,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        child: Column(
                          crossAxisAlignment: messages[index]["chat_from"] ==
                                  snapshot.data["current_user_id"]
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(
                              messages[index]["content"],
                              style: TextStyle(color: Colors.white),
                            ),
                            height(7.0),
                            Text(
                              messages[index]["date_time"].substring(11, 16),
                              style: TextStyle(
                                  color: Colors.grey[300], fontSize: 13),
                            )
                          ],
                        ),
                      ),
                    ),
                    itemCount: messages.length,
                  ),
                );
              }
              if (snapshot.hasError) {
                return Center(
                    child: Text(
                  'Something went wrong',
                  style: TextStyle(color: Colors.white),
                ));
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(kSecondaryColor),
                  ),
                );
              }
            },
          ),
          Positioned(
            bottom: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
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
                          controller: _message,
                          onChanged: (value) => _message.text,
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
                              borderSide: BorderSide(
                                  width: 0, color: Colors.transparent),
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
                        onPressed: () async {
                          if (_message.text.length > 0) {
                            var data = await ApiHelper().sendMessage(
                                receiverId: widget.userId,
                                message: _message.text);
                            if (data != null) {
                              if (data["status"]) {
                                var temp = await ApiHelper()
                                    .getMessages(id: widget.userId);
                                setState(() {
                                  messages = temp["data"];
                                });
                                _message.clear();
                              }
                            }
                          }
                        },
                        color: kSecondaryColor),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
