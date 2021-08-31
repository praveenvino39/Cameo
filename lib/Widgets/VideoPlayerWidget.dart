// ignore: unused_import
import 'package:cameo/Screens/ViewVideoScreen.dart';
import 'package:cameo/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:cameo/Network/networkHelper.dart';

class VideoExample extends StatefulWidget {
  final String videoUrl;
  VideoExample({this.videoUrl});
  @override
  VideoState createState() => VideoState();
}

class VideoState extends State<VideoExample> {
  VideoPlayerController playerController;
  VoidCallback listener;
  bool isPlaying = false;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    listener = () {
      setState(() {});
    };
    createVideo();
  }

  void createVideo() {
    if (playerController == null) {
      print(widget.videoUrl);
      playerController = VideoPlayerController.network(
          "$domainUrl/${widget.videoUrl}")
        // VideoPlayerController.network(
        //     "https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_480_1_5MG.mp4")
        ..addListener(listener)
        ..initialize()
        ..pause()
        ..setVolume(1.0).then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return !playerController.value.initialized
        ? Container(
            width: 100,
            height: 100,
            child: Center(
              child: Container(
                  width: 20,
                  height: 20,
                  child: Center(
                      child: CircularProgressIndicator(
                    strokeWidth: 1.0,
                  ))),
            ),
          )
        : Stack(
            children: [
              Container(
                child: playerController != null
                    ? Hero(
                        tag: widget.videoUrl,
                        child: VideoPlayer(
                          playerController,
                        ),
                      )
                    : Container(
                        width: 10,
                        height: 10,
                        child: Center(child: CircularProgressIndicator())),
              ),
              Center(
                child: IconButton(
                  icon: isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
                  onPressed: () async {
                    Get.to(() => ViewVideoScreen(),
                        arguments: {"video_url": widget.videoUrl});
                    // if (playerController.value.isPlaying) {
                    //   setState(() {
                    //     playerController.pause();
                    //     isPlaying = false;
                    //   });
                    // } else {
                    //   if (playerController.value.position ==
                    //       playerController.value.duration) {
                    //     await playerController.seekTo(Duration.zero);
                    //     setState(() {
                    //       playerController.play();

                    //       isPlaying = true;
                    //     });
                    //   } else {
                    //     playerController.play();
                    //     isPlaying = true;
                    //   }
                    // }
                  },
                  color: Colors.white,
                ),
              ),
            ],
          );
  }

  @override
  void dispose() {
    super.dispose();
    playerController.dispose();
  }
}
