import 'package:cached_network_image/cached_network_image.dart';
import 'package:cameo/Network/networkHelper.dart';
import 'package:cameo/Screens/CameoDetailScreen.dart';
import 'package:cameo/Screens/SearchResult.dart';
import 'package:cameo/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';

class BuyScreen extends StatelessWidget {
  TextEditingController searchController = TextEditingController();
  ApiHelper _apiHelper = ApiHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBodyBackgroundColor,
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          autofocus: false,
          style: TextStyle(
            color: Colors.white,
          ),
          keyboardAppearance: Brightness.light,
          textInputAction: TextInputAction.search,
          onEditingComplete: () {
            Get.to(() => SearchResult(searchQuery: searchController.text));
          },
          decoration: InputDecoration(
              hintText: "Search you cameos...",
              suffixIcon: IconButton(
                onPressed: () {},
                icon: Icon(Icons.search),
                color: kSecondaryColor,
                iconSize: 17,
                splashRadius: 20,
              ),
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey)),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: Get.height - 56,
          child: FutureBuilder(
            future: _apiHelper.buyCameo(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                    itemCount: snapshot.data.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5),
                    itemBuilder: (context, index) => Stack(children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(() => CameoDetailScreen(), arguments: {
                                "cameo_id": snapshot.data[index]["id"]
                              });
                            },
                            child: ShaderMask(
                              shaderCallback: (rect) {
                                return LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.grey, Colors.transparent],
                                ).createShader(Rect.fromLTRB(
                                    0, 0, rect.width, rect.height + 50));
                              },
                              blendMode: BlendMode.dstIn,
                              child: Container(
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: CachedNetworkImage(
                                  height: 200,
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      '$domainUrl/${snapshot.data[index]["gig_image"]}',
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          Center(
                                    child: CircularProgressIndicator(
                                        value: downloadProgress.progress),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                              bottom: 10,
                              left: 10,
                              child: Container(
                                width: MediaQuery.of(context).size.width / 2.8,
                                child: Text(
                                  titleCase(
                                    string: snapshot.data[index]["title"],
                                  ),
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              )),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: Text(
                              '\$${snapshot.data[index]["gig_price"]}',
                              style: kCardName,
                            ),
                          )
                        ]));
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text("Something went wrorng"),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
