import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:cameo/Network/networkHelper.dart';

class ViewVideoScreen extends StatefulWidget {
  @override
  _ViewVideoScreenState createState() => _ViewVideoScreenState();
}

class _ViewVideoScreenState extends State<ViewVideoScreen> {
  ChewieController chewieController;
  VideoPlayerController videoPlayerController;
  String videoUrl = Get.arguments["video_url"];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoPlayerController =
        VideoPlayerController.network("$domainUrl/$videoUrl");
    videoPlayerController.initialize();
    chewieController = ChewieController(
      aspectRatio: videoPlayerController.value.aspectRatio,
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Hero(
          tag: videoUrl,
          child: Chewie(
            controller: chewieController,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }
}
