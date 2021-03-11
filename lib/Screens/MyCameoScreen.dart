import 'package:cached_network_image/cached_network_image.dart';
import 'package:cameo/Network/networkHelper.dart';
import 'package:cameo/constants.dart';
import 'package:cameo/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:flutter/src/material/refresh_indicator.dart' as baseRefresh;

class MyCameoScreen extends StatefulWidget {
  @override
  _MyCameoScreenState createState() => _MyCameoScreenState();
}

final GlobalKey<baseRefresh.RefreshIndicatorState> _refreshIndicatorKey =
    new GlobalKey<baseRefresh.RefreshIndicatorState>();
List data = [];

class _MyCameoScreenState extends State<MyCameoScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Cameos"),
        ),
        backgroundColor: kBodyBackgroundColor,
        body: baseRefresh.RefreshIndicator(
          color: kSecondaryColor,
          backgroundColor: Colors.white,
          onRefresh: () async {
            List tempData = await ApiHelper().myCameo();
            setState(() {
              data = tempData;
            });
          },
          key: _refreshIndicatorKey,
          child: FutureBuilder(
            future: ApiHelper().myCameo(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                data = snapshot.data;
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 7,
                        crossAxisSpacing: 7),
                    itemCount: data.length,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () => {},
                      child: GridTile(
                        child: Container(
                          height: 100,
                          child: Stack(children: [
                            ShaderMask(
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
                                      'https://cameo.deliveryventure.com/${data[index]["image"]}',
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
                            Positioned(
                                bottom: 10,
                                left: 10,
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width / 2.8,
                                  child: Text(
                                    titleCase(string: data[index]["title"]),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                )),
                            Positioned(
                              bottom: 10,
                              right: 10,
                              child: Text(
                                '\$${data[index]["gig_price"]}',
                                style: kCardName,
                              ),
                            )
                          ]),
                        ),
                      ),
                    ),
                  ),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Something went wrong",
                    style: TextStyle(color: Colors.white),
                  ),
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
