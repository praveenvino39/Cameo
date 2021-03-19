import 'dart:typed_data';

import 'package:cameo/Network/networkHelper.dart';
import 'package:cameo/Widgets/Loading%20Indicators/LoadingIndicator.dart';
import 'package:cameo/Widgets/VideoPlayerWidget.dart';
import 'package:cameo/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/src/material/refresh_indicator.dart' as baseRefresh;
import 'package:path_provider/path_provider.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class EditVideoScreen extends StatefulWidget {
  final List videoList;
  final gig_id;
  EditVideoScreen(this.videoList, this.gig_id);
  @override
  _EditVideoScreenState createState() => _EditVideoScreenState();
}

class _EditVideoScreenState extends State<EditVideoScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // uploadVideo
            // PickedFile pckVideo =
            //     await ImagePicker().getVideo(source: ImageSource.gallery);
            FilePickerResult pckVideo = await FilePicker.platform
                .pickFiles(allowMultiple: false, type: FileType.video);
            if (pckVideo != null) {
              loading(context);
              var data = await ApiHelper()
                  .uploadVideo(gigId: widget.gig_id, vid: pckVideo);
              Navigator.pop(context);
            }
          },
          backgroundColor: kSecondaryColor,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        appBar: AppBar(
          title: Text("My Cameos"),
        ),
        backgroundColor: kBodyBackgroundColor,
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: widget.videoList.length > 0
              ? GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 7,
                      crossAxisSpacing: 7),
                  itemCount: widget.videoList.length,
                  itemBuilder: (context, index) => Container(
                    height: 100,
                    width: 100,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Container(
                        height: 100,
                        width: 100,
                        child: Stack(
                          children: [
                            VideoExample(
                              videoUrl: widget.videoList[index]["video_path"],
                            ),
                            Positioned(
                              right: 2,
                              top: 2,
                              child: FittedBox(
                                child: Container(
                                    width: 17,
                                    height: 17,
                                    child: Container(
                                        width: 20.0,
                                        height: 20.0,
                                        child: RawMaterialButton(
                                          shape: new CircleBorder(),
                                          elevation: 0.0,
                                          fillColor: kSecondaryColor,
                                          child: Icon(
                                            Icons.close,
                                            size: 10,
                                            color: Colors.white,
                                          ),
                                          onPressed: () async {
                                            loading(context);
                                            await ApiHelper().deleteVideo(
                                                videoPath:
                                                    widget.videoList[index]
                                                        ["video_path"],
                                                gig_id: widget.gig_id);
                                            setState(() {
                                              widget.videoList.removeAt(index);
                                            });
                                            Navigator.pop(context);
                                          },
                                        ))),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : Center(
                  child: Text(
                    "You don\'t have any video, Click the + button to add one!",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
        ),
      ),
    );
  }
}
