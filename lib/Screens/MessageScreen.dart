import 'package:cameo/Network/networkHelper.dart';
import 'package:cameo/Screens/ChatScreen.dart';
import 'package:cameo/constants.dart';
import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Messages", style: TextStyle(color: Colors.white)),
        ),
        backgroundColor: kBodyBackgroundColor,
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: FutureBuilder(
                future: ApiHelper().getConversation(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) => ListTile(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              userId:
                                  int.parse(snapshot.data[index]["chat_from"]),
                              username:
                                  snapshot.data[index]["from_user"].toString(),
                            ),
                          ),
                        ),
                        leading: CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        title: Text(
                          snapshot.data[index]["from_user"].toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Something went wrong"));
                  } else {
                    return Center(
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation(kSecondaryColor)));
                  }
                }),
          ),
        ),
      ),
    );
  }
}
