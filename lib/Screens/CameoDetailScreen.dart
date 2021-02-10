import 'package:cameo/Network/networkHelper.dart';
import 'package:cameo/Network/userSesionHelper.dart';
import 'package:cameo/Screens/ChatScreen.dart';
import 'package:cameo/Widgets/CameoInfoCardContainer.dart';
import 'package:cameo/Widgets/Popups%20and%20Dialogs/PaymentPopup.dart';
import 'package:cameo/Widgets/SvgButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:cameo/constants.dart';
import 'package:cameo/utils.dart';
import 'package:flutter/material.dart';

class CameoDetailScreen extends StatefulWidget {
  final int id;

  CameoDetailScreen({Key key, this.id}) : super(key: key);

  @override
  _CameoDetailScreenState createState() => _CameoDetailScreenState();
}

class _CameoDetailScreenState extends State<CameoDetailScreen> {
  final GlobalKey scaffold = GlobalKey<ScaffoldState>();
  final ApiHelper apiHelper = ApiHelper();
  final String imageBaseUrl = 'https://cameo.deliveryventure.com/';
  UserSession userSession = UserSession();
  int currentUserId;

  @override
  void initState() {
    super.initState();
    userSession.getCurrentUserId().then((value) => setState(() {
          currentUserId = int.parse(value);
        }));
  }

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
          body: FutureBuilder(
              future: apiHelper.cameoDetail(widget.id),
              builder: (context, snapshot) {
                if (snapshot.hasData) if (snapshot
                        .data["data"][0]["gigs_details"].length >
                    0)
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 30.0, bottom: 20, left: 10),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 56,
                                      backgroundImage: NetworkImage(
                                          '$imageBaseUrl${snapshot.data["data"][0]["gigs_details"]["image"]}'),
                                    ),
                                    width(20.0),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.2,
                                          child: Text(
                                            titleCase(
                                                string: snapshot.data["data"][0]
                                                    ["gigs_details"]["title"]),
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                        height(8.0),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.8,
                                          child: Text(
                                            snapshot.data["data"][0]
                                                ["gigs_details"]["gig_details"],
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.white70,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Container(
                            child: Text(
                              snapshot.data["data"][0]["gigs_details"]
                                  ["gig_details"],
                              style: TextStyle(
                                  letterSpacing: 1.5,
                                  fontSize: 17,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: CaemoInfoCardContainer(
                            responseIn: snapshot.data["data"][0]["gigs_details"]
                                ["delivering_days"],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Container(
                            width: double.infinity,
                            height: 60,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100)),
                            child: FlatButton(
                              onPressed: () {
                                return showDialog(
                                  context: context,
                                  builder: (context) => PaymentPopup(
                                    price: double.parse(snapshot.data["data"][0]
                                        ["gigs_details"]["gig_price"]),
                                    paymentTo: int.parse(snapshot.data["data"]
                                        [0]["gigs_details"]["id"]),
                                    paymentFrom: 10,
                                  ),
                                );
                              },
                              child: Text(
                                'Request ${snapshot.data["data"][0]["gigs_details"]["currency_sign"]}${snapshot.data["data"][0]["gigs_details"]["gig_price"]}',
                                style: kAuthTitleStyle.copyWith(
                                    color: Colors.white, fontSize: 24),
                              ),
                              color: Color(0xffff037c),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18.0, vertical: 10),
                          child: Container(
                            width: double.infinity,
                            height: 60,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100)),
                            child: FlatButton(
                              onPressed: () => Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => ChatScreen(
                                    userId: int.parse(snapshot.data["data"][0]
                                        ["gigs_details"]["user_id"]),
                                    username: snapshot.data["data"][0]
                                        ["gigs_details"]["title"],
                                  ),
                                ),
                              ),
                              child: Text(
                                'Chat ',
                                style: kAuthTitleStyle.copyWith(
                                    color: Colors.white, fontSize: 24),
                              ),
                              color: Color(0xffff037c),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                else {
                  return Center(
                    child: ListTile(
                      leading: Icon(
                        Icons.error,
                        color: Colors.white,
                        size: 30,
                      ),
                      title: Text(
                          "Something went wrong, try again after sometime",
                          style: TextStyle(fontSize: 24, color: Colors.white)),
                    ),
                  );
                }

                if (snapshot.hasError)
                  return Center(
                    child: ListTile(
                      leading: Icon(
                        Icons.error,
                        color: Colors.white,
                        size: 30,
                      ),
                      title: Text(
                          "Something went wrong, Please make sure that you're connected to the internet.",
                          style: TextStyle(fontSize: 24, color: Colors.white)),
                    ),
                  );
                else
                  return Center(child: CircularProgressIndicator());
              }),
        ),
      ),
    );
  }
}
