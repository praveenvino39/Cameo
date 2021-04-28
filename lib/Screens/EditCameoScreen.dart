import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cameo/Network/networkHelper.dart';
import 'package:cameo/Screens/EditVideoScreen.dart';
import 'package:cameo/Widgets/Loading%20Indicators/LoadingIndicator.dart';
import 'package:cameo/constants.dart';
import 'package:cameo/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

PickedFile pickedImage, pckvid;
Uint8List pickedImageList;

class EditCameoScreen extends StatefulWidget {
  final Map cameoDetail;

  List videos;

  EditCameoScreen({Key key, this.cameoDetail, this.videos}) : super(key: key);
  @override
  _EditCameoScreenState createState() => _EditCameoScreenState();
}

class _EditCameoScreenState extends State<EditCameoScreen> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  List videos = [];
  var value = true;
  bool isRemote = false;
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
      gig_id,
      needDescription;
  List videoList = [];
  bool closeYoutube = false;
  bool closeVimeo = false;
  bool closeImage = false;
  bool imageSelected = false;
  String image;
  String imageArray;

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    title = amount = duration = widget.cameoDetail["title"];
    tag = widget.cameoDetail["gig_tags"];
    videoUrl = widget.cameoDetail["youtube_url"];
    vimeoUrl = widget.cameoDetail["vimeo_url"];
    description = widget.cameoDetail["gig_details"];
    duration = widget.cameoDetail["delivering_days"];
    amount = widget.cameoDetail["gig_price"];
    videoList = widget.videos;
    image = widget.cameoDetail["image"];
    imageArray = widget.cameoDetail["image"];
    gig_id = widget.cameoDetail["id"];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: scaffoldState,
      backgroundColor: kBodyBackgroundColor,
      appBar: AppBar(
        title: Text('Edit Cameo'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            children: [
              Theme(
                data: ThemeData(primaryColor: Colors.pinkAccent),
                child: TextFormField(
                  initialValue: title,
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
                  initialValue: amount,
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
                  initialValue: duration,
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
                  initialValue: tag,
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
                          imageSelected = await pickImage(
                              context: context, scaffoldKey: scaffoldState);
                          if (imageSelected) {
                            imageArray = pickedImage.path;
                            int splitIndex = imageArray.lastIndexOf('/');
                            imageArray = imageArray.substring(splitIndex + 1);
                            setState(() {
                              image = pickedImage.path;
                            });
                          } else {
                            Navigator.pop(context);
                          }
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
                        onTap: () {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => AlertDialog(
                                    actions: [
                                      RaisedButton(
                                        onPressed: () {
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
              height(10.0),
              height(10.0),
              Container(
                child: Column(
                  children: [
                    Text(
                      "Image",
                      style: TextStyle(color: Colors.white),
                    ),
                    height(10.0),
                    image.length > 0
                        ? Stack(children: [
                            !imageSelected
                                ? CachedNetworkImage(
                                    imageUrl: '$domainUrl/$image',
                                  )
                                : Image(
                                    height: 100,
                                    fit: BoxFit.cover,
                                    image: MemoryImage(pickedImageList),
                                  ),
                            CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.white,
                              child: Center(
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      image = "";
                                    });
                                  },
                                  splashRadius: 15,
                                  icon: Icon(Icons.close,
                                      size: 15, color: Colors.red),
                                ),
                              ),
                            )
                          ])
                        : width(0.0)
                    // ListTile(title: Text(widget.cameoDetail["image"])),
                  ],
                ),
              ),
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
                  initialValue: description,
                  focusNode: fnDescripition,
                  onChanged: (value) => description = value,
                  maxLines: 3,
                  minLines: 1,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  decoration: kEditFieldDecoration.copyWith(
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    labelText: 'Provide more details about your cameo',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How are you planning to work with the Buyer? ',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Row(
                      children: [
                        Theme(
                          data: ThemeData.dark()
                              .copyWith(unselectedWidgetColor: kSecondaryColor),
                          child: Radio(
                              value: isRemote,
                              activeColor: kSecondaryColor,
                              groupValue: true,
                              onChanged: (value) =>
                                  {setState(() => isRemote = true)}),
                        ),
                        Text(
                          "Remotely",
                          style: TextStyle(color: Colors.pinkAccent),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Theme(
                          data: ThemeData.dark()
                              .copyWith(unselectedWidgetColor: kSecondaryColor),
                          child: Radio(
                              value: !isRemote,
                              activeColor: kSecondaryColor,
                              groupValue: true,
                              onChanged: (value) =>
                                  {setState(() => isRemote = false)}),
                        ),
                        Text(
                          'On-site',
                          style: TextStyle(color: Colors.pinkAccent),
                        )
                      ],
                    ),
                  ],
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
              height(20.0),
              Container(
                width: 125,
                child: RaisedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EditVideoScreen(videoList, gig_id)));
                  },
                  child: Text(
                    "Edit Videos",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: kSecondaryColor,
                ),
              ),
              FlatButton(
                color: Colors.pinkAccent,
                disabledColor: Colors.grey,
                onPressed: () async {
                  if (tag != null &&
                      title != null &&
                      amount != null &&
                      duration != null &&
                      description != null &&
                      videoUrl != null &&
                      vimeoUrl != null) {
                    loading(context);
                    var data = await ApiHelper().updateCameo(
                        tags: tag,
                        title: title,
                        gigPrice: int.parse(amount),
                        deliveryTime: int.parse(duration),
                        categoryId: 4,
                        img: pickedImage,
                        gigDetails: description,
                        // youtubeUrl: "https://www.youtube.com/watch?v=3gNd1Ma",
                        youtubeUrl: videoUrl,
                        // vimeoUrl: "https://vimeo.com/76979871",
                        vimeoUrl: vimeoUrl,
                        imageArray: imageArray,
                        gigId: gig_id);
                    if (data != null) if (data["message"] == "success") {
                      Get.offNamedUntil('/detail', (route) => route.isFirst,
                          arguments: {"cameo_id": gig_id});
                    }
                  } else {
                    print(
                        "$tag, $title, $amount, $duration, $pickedImage $description $videoUrl $vimeoUrl");
                    scaffoldState.currentState.removeCurrentSnackBar();
                    scaffoldState.currentState.showSnackBar(
                        SnackBar(content: Text("Fill all the fields")));
                  }
                },
                child: Text(
                  'Update Cameo',
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

Future<bool> pickImage({context, GlobalKey<ScaffoldState> scaffoldKey}) async {
  loading(context);
  PickedFile pckimg = await ImagePicker().getImage(source: ImageSource.gallery);
  if (pckimg != null) {
    var decodedImage = await decodeImageFromList(await pckimg.readAsBytes());
    if (decodedImage.height <= 480 && decodedImage.width <= 640) {
      Navigator.pop(context);
      pickedImage = pckimg;
      pickedImageList = await pickedImage.readAsBytes();
      return true;
    } else {
      // FocusScope.of(context).requestFocus(FocusNode());
      // Navigator.pop(context);
      scaffoldKey.currentState.removeCurrentSnackBar();
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          'Image should\'be in size of 640*480',
          style: TextStyle(color: kSecondaryColor),
        ),
        backgroundColor: Colors.white,
      ));
      return false;
    }
  } else {
    return false;
  }
}

// void pickVideo({GlobalKey<ScaffoldState> scaffoldKey}) async {
//   pckvid = await ImagePicker().getVideo(source: ImageSource.gallery);
// }
