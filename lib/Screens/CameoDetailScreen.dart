import 'package:cached_network_image/cached_network_image.dart';
import 'package:cameo/Network/networkHelper.dart';
import 'package:cameo/Network/userSesionHelper.dart';
import 'package:cameo/Screens/ChatScreen.dart';
import 'package:cameo/Screens/EditCameoScreen.dart';
import 'package:cameo/Widgets/CameoInfoCardContainer.dart';
import 'package:cameo/Widgets/Popups%20and%20Dialogs/PaymentPopup.dart';

import 'package:cameo/constants.dart';
import 'package:cameo/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vimeoplayer/vimeoplayer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CameoDetailScreen extends StatefulWidget {
  final int id;

  CameoDetailScreen({Key key, this.id}) : super(key: key);

  @override
  _CameoDetailScreenState createState() => _CameoDetailScreenState();
}

class _CameoDetailScreenState extends State<CameoDetailScreen> {
  final GlobalKey scaffold = GlobalKey<ScaffoldState>();
  final ApiHelper apiHelper = ApiHelper();
  UserSession userSession = UserSession();
  String currentUserId;
  YoutubePlayerController _controller;

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
                    0) {
                  Uri youtubeVideoId =
                      Uri.parse('https://www.youtube.com/watch?v=i74Lxs9Zjhg');

                  _controller = YoutubePlayerController(
                    initialVideoId: youtubeVideoId.queryParameters["v"],
                    flags: YoutubePlayerFlags(
                      autoPlay: false,
                      mute: false,
                    ),
                  );
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
                                      backgroundImage: CachedNetworkImageProvider(
                                          '$domainUrl/${snapshot.data["data"][0]["gigs_details"]["image"]}'),
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
                            child: FutureBuilder(
                                future: UserSession().getCurrentUserId(),
                                builder: (context, userSnapshot) {
                                  if (userSnapshot.hasData) {
                                    currentUserId =
                                        userSnapshot.data.toString();
                                    if (userSnapshot.data.toString() ==
                                        snapshot.data["data"][0]["gigs_details"]
                                            ["user_id"]) {
                                      return FlatButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) =>
                                                  EditCameoScreen(
                                                cameoDetail:
                                                    snapshot.data["data"][0]
                                                        ["gigs_details"],
                                                videos: snapshot.data["data"][0]
                                                    ["video_path"],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          'Edit Cameo',
                                          style: kAuthTitleStyle.copyWith(
                                              color: Colors.white,
                                              fontSize: 24),
                                        ),
                                        color: Color(0xffff037c),
                                      );
                                    } else {
                                      return FlatButton(
                                        onPressed: () {
                                          return showDialog(
                                            context: context,
                                            builder: (context) => PaymentPopup(
                                              price: double.parse(
                                                  snapshot.data["data"][0]
                                                          ["gigs_details"]
                                                      ["gig_price"]),
                                              paymentTo: int.parse(
                                                  snapshot.data["data"][0]
                                                      ["gigs_details"]["id"]),
                                              paymentFrom: 10,
                                            ),
                                          );
                                        },
                                        child: Text(
                                          'Request ${snapshot.data["data"][0]["gigs_details"]["currency_sign"]}${snapshot.data["data"][0]["gigs_details"]["gig_price"]}',
                                          style: kAuthTitleStyle.copyWith(
                                              color: Colors.white,
                                              fontSize: 24),
                                        ),
                                        color: Color(0xffff037c),
                                      );
                                    }
                                  } else {
                                    return FlatButton(
                                      onPressed: () {
                                        return showDialog(
                                          context: context,
                                          builder: (context) => PaymentPopup(
                                            price: double.parse(snapshot
                                                    .data["data"][0]
                                                ["gigs_details"]["gig_price"]),
                                            paymentTo: int.parse(
                                                snapshot.data["data"][0]
                                                    ["gigs_details"]["id"]),
                                            paymentFrom: 10,
                                          ),
                                        );
                                      },
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation(
                                            Colors.white),
                                      ),
                                      color: Color(0xffff037c),
                                    );
                                  }
                                }),
                          ),
                        ),
                        FutureBuilder(
                          future: UserSession().getCurrentUserId(),
                          builder: (context, userSnapshot) {
                            if (userSnapshot.hasData) {
                              if (userSnapshot.data !=
                                  snapshot.data["data"][0]["gigs_details"]
                                      ["user_id"]) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18.0, vertical: 10),
                                  child: Container(
                                      width: double.infinity,
                                      height: 60,
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      child: FlatButton(
                                        onPressed: () async {
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) => ChatScreen(
                                                userId: int.parse(
                                                    snapshot.data["data"][0]
                                                            ["gigs_details"]
                                                        ["user_id"]),
                                                username: snapshot.data["data"]
                                                        [0]["gigs_details"]
                                                    ["title"],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          'Chat ',
                                          style: kAuthTitleStyle.copyWith(
                                              color: Colors.white,
                                              fontSize: 24),
                                        ),
                                        color: Color(0xffff037c),
                                      )),
                                );
                              } else {
                                return height(0.0);
                              }
                            } else {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                        height(30.0),
                        Text(
                          "LATEST CAMEOS",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: kSecondaryColor,
                            fontSize: 25,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Row(
                                children: [
                                  SvgPicture.asset('assets/images/youtube.svg'),
                                  width(10.0),
                                  Text(
                                    "Youtube",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                child: YoutubePlayer(
                                    controller: _controller,
                                    showVideoProgressIndicator: true,
                                    progressColors: ProgressBarColors(
                                      playedColor: kSecondaryColor,
                                      handleColor: kSecondaryColor,
                                    )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/vimeo.svg',
                                    width: 40,
                                  ),
                                  width(10.0),
                                  Text(
                                    "Vimeo",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 300,
                              child:
                                  VimeoPlayer(id: '395212534', autoPlay: false),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                } else {
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
                  // return CameoDetailShimmer();
                  return Center(
                    child: CircularProgressIndicator(),
                  );
              }),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }
}
