import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cameo/Network/networkHelper.dart';
import '../constants.dart';

// ignore: must_be_immutable
class FileTile extends StatefulWidget {
  String orderId;

  String fileName;
  FileTile({Key key, this.orderId, this.fileName}) : super(key: key);

  @override
  _FileTileState createState() => _FileTileState();
}

class _FileTileState extends State<FileTile>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  double progress = 0.0;
  var dioInstance = Dio();
  bool isDownloading = false;
  bool isFinished = false;
  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            tileColor: Colors.white,
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Order ID",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(widget.orderId),
              ],
            ),
            // tileColor: Colors.white,
            title: Text(widget.fileName),
            trailing: !isDownloading
                ? IconButton(
                    splashRadius: 20,
                    splashColor: kSecondaryColor,
                    icon: Icon(Icons.download_rounded),
                    color: kSecondaryColor,
                    onPressed: () async {
                      setState(() {
                        isDownloading = true;
                      });
                      PermissionStatus permissionState =
                          await Permission.storage.request();
                      if (permissionState.isGranted) {
                        String downloadPath;
                        if (Platform.isIOS) {
                          Directory temp =
                              await getApplicationDocumentsDirectory();
                          downloadPath = "${temp.path}/";
                        } else {
                          downloadPath = '/storage/emulated/0/Bigup/';
                        }
                        try {
                          Response response = await dioInstance.download(
                              "$domainUrl/uploads/digital/${widget.fileName}",
                              "$downloadPath${widget.fileName}",
                              // Listen the download progress.

                              onReceiveProgress: (received, total) {
                            var val = received / total * 100;
                            setState(() {
                              progress = val * 5;
                            });
                          });
                          setState(() {
                            isFinished = true;
                          });
                        } catch (e) {
                          print(e);
                        }
                      }
                    },
                  )
                : !isFinished
                    ? Container(
                        width: 20,
                        height: 20,
                        margin: EdgeInsets.only(right: 15),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(kSecondaryColor),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Icon(
                          Icons.check,
                          color: kSecondaryColor,
                        ),
                      ),
          ),
          Container(
            height: 5,
            color: kSecondaryColor,
            width: progress,
          )
        ],
      ),
    );
  }
}
