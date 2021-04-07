import 'package:cached_network_image/cached_network_image.dart';
import 'package:cameo/Network/networkHelper.dart';
import 'package:cameo/Widgets/CallToActionButtons.dart';
import 'package:cameo/Widgets/CameoInfoCardContainer.dart';
import 'package:cameo/Widgets/VideoPlayerWidget.dart';
import 'package:cameo/constants.dart';
import 'package:cameo/controller/cameo_controller.dart';
import 'package:cameo/models/cameo_model.dart';
import 'package:cameo/models/user_model.dart';
import 'package:cameo/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:vimeoplayer/vimeoplayer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CameoDetailScreen extends StatefulWidget {
  CameoDetailScreen({Key key}) : super(key: key);

  @override
  _CameoDetailScreenState createState() => _CameoDetailScreenState();
}

class _CameoDetailScreenState extends State<CameoDetailScreen> {
  final GlobalKey scaffold = GlobalKey<ScaffoldState>();
  final ApiHelper apiHelper = ApiHelper();
  User currentUser = Get.find<User>();
  YoutubePlayerController _controller;
  CameoController cameoController = CameoController();
  Cameo cameo;
  final String cameoId = Get.arguments["cameo_id"];
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
              future: cameoController.getCameobyId(gigId: cameoId),
              builder: (context, snapshot) {
                cameo = snapshot.data;
                if (snapshot.hasData) {
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
                                          '$domainUrl/${cameo.gigsDetails.image}'),
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
                                                string:
                                                    cameo.gigsDetails.title),
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
                                          child: cameo.gigsDetails.gigDetails
                                                      .length >
                                                  20
                                              ? Text(
                                                  cameo.gigsDetails.gigDetails
                                                      .substring(0, 20),
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      color: Colors.white70,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                )
                                              : Text(
                                                  cameo.gigsDetails.gigDetails,
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      color: Colors.white70,
                                                      fontWeight:
                                                          FontWeight.w300),
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
                              cameo.gigsDetails.gigDetails,
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: CaemoInfoCardContainer(
                              responseIn: cameo.gigsDetails.deliveringDays),
                        ),
                        callToActionButtons(cameo: cameo, user: currentUser),
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
                            Container(
                              height: 200,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: cameo.videoPath.length,
                                itemBuilder: (context, index) => Container(
                                  padding: EdgeInsets.only(right: 10),
                                  width: 300,
                                  height: 200,
                                  child: VideoExample(
                                    videoUrl: cameo.videoPath[index]
                                        ["video_path"],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
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
    if (_controller != null) {
      _controller.dispose();
    }

    super.dispose();
  }
}

class CustomButton extends StatelessWidget {
  CustomButton({
    Key key,
    @required this.onPressed,
    @required this.buttonText,
  }) : super(key: key);

  final String buttonText;
  Function onPressed;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: kAuthTitleStyle.copyWith(color: Colors.white, fontSize: 16),
      ),
      color: Color(0xffff037c),
    );
  }
}
