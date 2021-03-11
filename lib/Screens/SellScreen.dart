import 'dart:typed_data';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:cameo/Network/networkHelper.dart';
import 'package:cameo/Widgets/Loading%20Indicators/LoadingIndicator.dart';
import 'package:cameo/constants.dart';
import 'package:cameo/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';

PickedFile pickedImage, pckvid;
Uint8List pickedImageInt8List, pckvidInt8List;

class SellScreen extends StatefulWidget {
  @override
  _SellScreenState createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  var value = true;
  bool isRemote = false;
  bool isAgreed = false;
  bool is3rdParty = false;
  bool isSuperFast = false;

  String title,
      amount,
      duration,
      tag,
      videoUrl,
      vimeoUrl,
      spTitle,
      spAmout,
      spDuration,
      description,
      needDescription;

  FocusNode fnTitle = FocusNode();
  FocusNode fnAmout = FocusNode();
  FocusNode fnDuration = FocusNode();
  FocusNode fnTag = FocusNode();
  FocusNode fnVideoUrl = FocusNode();
  FocusNode fnVimeoUrl = FocusNode();
  FocusNode fnSpTitle = FocusNode();
  FocusNode fnSpAmount = FocusNode();
  FocusNode fnSpDuration = FocusNode();
  FocusNode fnDescripition = FocusNode();
  FocusNode fnNeedDescription = FocusNode();
  bool showPick = false;
  bool imageSelected = false;
  bool videoSelected = false;

  @override
  void dispose() {
    // TODO: implement dispose
    pckvid = null;
    pickedImage = null;
    pickedImageInt8List = null;
    pckvidInt8List = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: scaffoldState,
      backgroundColor: kBodyBackgroundColor,
      appBar: AppBar(
        title: Text('Post a Cameo'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            children: [
              Theme(
                data: ThemeData(primaryColor: Colors.pinkAccent),
                child: TextFormField(
                  focusNode: fnTitle,
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(fnAmout),
                  onChanged: (value) => title = value,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  decoration: kEditFieldDecoration.copyWith(labelText: "I can"),
                ),
              ),
              Theme(
                data: ThemeData(primaryColor: Colors.pinkAccent),
                child: TextFormField(
                  focusNode: fnAmout,
                  onChanged: (value) => amount = value,
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(fnDuration),
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  decoration: kEditFieldDecoration.copyWith(
                      labelText: "For",
                      hintText: "\$",
                      hintStyle: kTextFieldHintStyle.copyWith(fontSize: 16)),
                ),
              ),
              Theme(
                data: ThemeData(primaryColor: Colors.pinkAccent),
                child: TextFormField(
                  keyboardType: TextInputType.numberWithOptions(),
                  focusNode: fnDuration,
                  onChanged: (value) => duration = value,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  decoration: kEditFieldDecoration.copyWith(
                      labelText: "Delivery duration"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: DropdownButton(
                    hint: DropdownMenuItem(
                      child: Text(
                        'Cateogory',
                        style: kDropDownTextStyle.copyWith(fontSize: 16),
                      ),
                    ),
                    elevation: 2,
                    isExpanded: true,
                    items: [
                      DropdownMenuItem(
                        child: Text(
                          'Musician',
                          style: kDropDownTextStyle.copyWith(fontSize: 16),
                        ),
                      ),
                      DropdownMenuItem(
                        child: Text(
                          'Notes and Net Worthy',
                          style: kDropDownTextStyle.copyWith(fontSize: 16),
                        ),
                      ),
                      DropdownMenuItem(
                        child: Text(
                          'Comedian',
                          style: kDropDownTextStyle.copyWith(fontSize: 16),
                        ),
                      )
                    ],
                    onChanged: (value) =>
                        {FocusScope.of(context).requestFocus(fnTag)}),
              ),
              Theme(
                data: ThemeData(
                  primaryColor: Colors.pinkAccent,
                ),
                child: TextFormField(
                  focusNode: fnTag,
                  onChanged: (value) => tag = value,
                  maxLines: 3,
                  minLines: 1,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  decoration: kEditFieldDecoration.copyWith(
                      labelText: 'Tags',
                      hintText: ' Use comma to seperate',
                      hintStyle: kTextFieldHintStyle.copyWith(
                          fontSize: 16, color: Colors.pinkAccent[300])),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                width: MediaQuery.of(context).size.width,
                height: 100,
                decoration: BoxDecoration(
                  color: Color(0xff4d4d5d),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          var isSelected = await pickImage(
                              context: context, scaffoldKey: scaffoldState);
                          isSelected
                              ? setState(() => {imageSelected = true})
                              : Navigator.of(context).pop();
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.photo, size: 36, color: Colors.white),
                            Text(
                              "Upload photo",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          var data = await pickVideo(
                              scaffoldKey: scaffoldState, context: context);
                          if (data) {
                            setState(() {
                              videoSelected = true;
                            });
                          }
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.video_collection,
                                size: 36, color: Colors.white),
                            Text(
                              "Upload Video",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => AlertDialog(
                                    actions: [
                                      RaisedButton(
                                        onPressed: () {
                                          scaffoldState.currentState
                                              .removeCurrentSnackBar();
                                          Navigator.pop(context);
                                        },
                                        child: Text("Submit"),
                                        textColor: Colors.white,
                                        color: kSecondaryColor,
                                      ),
                                      RaisedButton(
                                        onPressed: () {
                                          videoUrl = null;
                                          vimeoUrl = null;
                                          Navigator.pop(context);
                                        },
                                        child: Text("Cancel"),
                                        textColor: Colors.white,
                                        color: kSecondaryColor,
                                      )
                                    ],
                                    content: Container(
                                      height: 140,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Theme(
                                              data: ThemeData(
                                                  primaryColor:
                                                      kSecondaryColor),
                                              child: TextFormField(
                                                initialValue: videoUrl,
                                                focusNode: fnVideoUrl,
                                                onChanged: (value) =>
                                                    videoUrl = value,
                                                keyboardType: TextInputType.url,
                                                decoration: InputDecoration(
                                                    hintText: 'Video URL'),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Theme(
                                              data: ThemeData(
                                                  primaryColor:
                                                      kSecondaryColor),
                                              child: TextFormField(
                                                initialValue: vimeoUrl,
                                                focusNode: fnVimeoUrl,
                                                onChanged: (value) =>
                                                    vimeoUrl = value,
                                                keyboardType: TextInputType.url,
                                                decoration: InputDecoration(
                                                    hintText: 'Vimeo URL'),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.videocam,
                                size: 36,
                                color: is3rdParty
                                    ? kSecondaryColor
                                    : Colors.white),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                "from 3rd party website.",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              height(20.0),
              imageSelected || videoSelected
                  ? imageSelected
                      ? FutureBuilder(
                          future: pickedImage.readAsBytes(),
                          builder: (context, snapshot) => snapshot.hasData
                              ? Row(
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          child: Image(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.5,
                                            image: MemoryImage(snapshot.data),
                                          ),
                                        ),
                                        CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 15,
                                          child: Center(
                                            child: IconButton(
                                              splashRadius: 15,
                                              iconSize: 15,
                                              onPressed: () {
                                                pickedImage = null;
                                                setState(() {
                                                  imageSelected = false;
                                                });
                                              },
                                              icon: Icon(
                                                Icons.close,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    videoSelected
                                        ? Stack(
                                            children: [
                                              Container(
                                                child: Image(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2.5,
                                                  image: MemoryImage(
                                                      pckvidInt8List),
                                                ),
                                              ),
                                              CircleAvatar(
                                                backgroundColor: Colors.white,
                                                radius: 15,
                                                child: Center(
                                                  child: IconButton(
                                                    splashRadius: 15,
                                                    iconSize: 15,
                                                    onPressed: () {
                                                      pckvid = null;
                                                      setState(() {
                                                        videoSelected = false;
                                                      });
                                                    },
                                                    icon: Icon(
                                                      Icons.close,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        : height(0.0)
                                    // Expanded(),
                                  ],
                                )
                              : CircularProgressIndicator(),
                        )
                      : height(0.0)
                  : height(0.0),
              height(20.0),
              Row(
                children: [
                  Checkbox(
                      value: isSuperFast,
                      activeColor: kSecondaryColor,
                      onChanged: (value) =>
                          {setState(() => isSuperFast = value)}),
                  Text(
                    "Superfast",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
              !isSuperFast
                  ? width(0.0)
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 1.8,
                            child: Theme(
                              data: ThemeData(primaryColor: Colors.pinkAccent),
                              child: TextFormField(
                                onEditingComplete: () => FocusScope.of(context)
                                    .requestFocus(fnSpAmount),
                                focusNode: fnSpTitle,
                                onChanged: (value) => spTitle = value,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                                decoration: kEditFieldDecoration.copyWith(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                  labelText: 'I can',
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 5,
                            child: Theme(
                              data: ThemeData(primaryColor: Colors.pinkAccent),
                              child: TextFormField(
                                onEditingComplete: () => FocusScope.of(context)
                                    .requestFocus(fnSpDuration),
                                focusNode: fnSpAmount,
                                onChanged: (value) => spAmout = value,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                                decoration: kEditFieldDecoration.copyWith(
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.auto,
                                    labelText: 'For \$'),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 7,
                            child: Theme(
                              data: ThemeData(primaryColor: Colors.pinkAccent),
                              child: TextFormField(
                                onEditingComplete: () => FocusScope.of(context)
                                    .requestFocus(fnDescripition),
                                focusNode: fnSpDuration,
                                onChanged: (value) => spDuration = value,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                                decoration: kEditFieldDecoration.copyWith(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                  labelText: 'In day',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              height(20.0),
              Theme(
                data: ThemeData(primaryColor: Colors.pinkAccent),
                child: TextFormField(
                  focusNode: fnDescripition,
                  onChanged: (value) => description = value,
                  maxLines: 3,
                  minLines: 1,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  decoration: kEditFieldDecoration.copyWith(
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    labelText: 'Provide more details about your cameo',
                    // hintText: 'Provide more details about your cameo',
                    // hintStyle: kTextFieldHintStyle.copyWith(
                    //     fontSize: 16, color: Colors.pinkAccent[100]),
                  ),
                ),
              ),
              Theme(
                data: ThemeData(primaryColor: Colors.pinkAccent),
                child: TextFormField(
                  focusNode: fnNeedDescription,
                  onChanged: (value) => needDescription = value,
                  maxLines: 3,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  decoration: kEditFieldDecoration.copyWith(
                      hintText: 'What you need from the buyer?',
                      hintStyle: kTextFieldHintStyle.copyWith(
                          fontSize: 16, color: Colors.pinkAccent)),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                        value: isAgreed,
                        activeColor: kSecondaryColor,
                        onChanged: (value) =>
                            {setState(() => isAgreed = value)}),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.3,
                      // height: 300,
                      child: Text(
                        ''' I confirm that I am able to deliver this service to Buyers within the delivery time specified.
I will update or pause my Cameo if I can no longer meet this delivery time.
I understand that late delivery will adversely affect my rankings onCameos And will entitle the buyer to a refund. See Terms and Conditions''',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    )
                  ],
                ),
              ),
              FlatButton(
                color: Colors.pinkAccent,
                disabledColor: Colors.grey,
                onPressed: !isAgreed
                    ? null
                    : () async {
                        if (tag != null &&
                            title != null &&
                            amount != null &&
                            duration != null &&
                            pckvid != null &&
                            pickedImage != null &&
                            description != null &&
                            videoUrl != null &&
                            vimeoUrl != null) {
                          loading(context);
                          var data = await ApiHelper().postCameo(
                            context,
                            scaffoldState,
                            tags: tag,
                            title: title,
                            gigPrice: int.parse(amount),
                            deliveryTime: int.parse(duration),
                            categoryId: 4,
                            vid: pckvid,
                            img: pickedImage,
                            gigDetails: description,
                            // youtubeUrl: "https://www.youtube.com/watch?v=3gNd1Ma",
                            youtubeUrl: videoUrl,
                            // vimeoUrl: "https://vimeo.com/76979871",
                            vimeoUrl: vimeoUrl,
                          );
                          if (data != null) if (data["message"] == "success") {
                            FocusScope.of(context).requestFocus(FocusNode());
                            Navigator.pop(context);
                            scaffoldState.currentState.removeCurrentSnackBar();
                            scaffoldState.currentState.showSnackBar(
                              SnackBar(
                                content: Text(
                                    "Your cameo posted successfully and waiting for admin approval"),
                              ),
                            );
                          } else {}
                        } else {
                          scaffoldState.currentState.removeCurrentSnackBar();
                          if (title == null) {
                            scaffoldState.currentState.showSnackBar(
                              SnackBar(
                                content: Text("Title field is required"),
                              ),
                            );
                          } else if (tag == null) {
                            scaffoldState.currentState.showSnackBar(
                              SnackBar(
                                content: Text("Tag field is required"),
                              ),
                            );
                          } else if (amount == null) {
                            scaffoldState.currentState.showSnackBar(
                              SnackBar(
                                content: Text("Price field is required"),
                              ),
                            );
                          } else if (description == null) {
                            scaffoldState.currentState.showSnackBar(
                              SnackBar(
                                content: Text("Detail field is required"),
                              ),
                            );
                          } else if (duration == null) {
                            scaffoldState.currentState.showSnackBar(
                              SnackBar(
                                content: Text("Duration field is required"),
                              ),
                            );
                          } else if (pckvid == null) {
                            scaffoldState.currentState.showSnackBar(
                              SnackBar(
                                content: Text("Video is required"),
                              ),
                            );
                          } else if (pickedImage == null) {
                            scaffoldState.currentState.showSnackBar(
                              SnackBar(
                                content: Text("Image is required"),
                              ),
                            );
                          } else if (pickedImage == null) {
                            scaffoldState.currentState.showSnackBar(
                              SnackBar(
                                content: Text("Image is required"),
                              ),
                            );
                          } else if (videoUrl == null) {
                            scaffoldState.currentState.showSnackBar(
                              SnackBar(
                                content: Text("Video url is required"),
                              ),
                            );
                          } else if (vimeoUrl == null) {
                            scaffoldState.currentState.showSnackBar(
                              SnackBar(
                                content: Text("Vimeo url is required"),
                              ),
                            );
                          }
                        }
                      },
                child: Text(
                  'Post Your AD',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              height(10.0)
            ],
          ),
        ),
      ),
    ));
  }
}

Future pickImage({context, GlobalKey<ScaffoldState> scaffoldKey}) async {
  loading(context);
  PickedFile pckimg = await ImagePicker().getImage(source: ImageSource.gallery);
  if (pckimg != null) {
    var decodedImage = await decodeImageFromList(await pckimg.readAsBytes());
    // 680
    // 460
    print(decodedImage.height);
    print(decodedImage.width);
    if (decodedImage.height <= 480 && decodedImage.width <= 640) {
      FocusScope.of(context).requestFocus(FocusNode());
      Navigator.pop(context);
      pickedImage = pckimg;
      pickedImageInt8List = await pickedImage.readAsBytes();
      scaffoldKey.currentState.removeCurrentSnackBar();
      return true;
    } else {
      FocusScope.of(context).requestFocus(FocusNode());
      Navigator.pop(context);
      scaffoldKey.currentState.removeCurrentSnackBar();
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          'Image should\'be in size of 640*480',
          style: TextStyle(color: kSecondaryColor),
        ),
        backgroundColor: Colors.white,
      ));
    }
  } else {
    return false;
  }
}

Future pickVideo({GlobalKey<ScaffoldState> scaffoldKey, context}) async {
  pckvid = await ImagePicker().getVideo(source: ImageSource.gallery);
  pckvidInt8List = await VideoThumbnail.thumbnailData(
    video: pckvid.path,
    imageFormat: ImageFormat.JPEG,
    maxWidth: 300,
    quality: 25,
  );
  return true;
}
