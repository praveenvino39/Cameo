import 'package:cached_network_image/cached_network_image.dart';
import 'package:cameo/Network/networkHelper.dart';
import 'package:cameo/Screens/CameoDetailScreen.dart';
import 'package:cameo/constants.dart';
import 'package:cameo/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class SearchResult extends StatefulWidget {
  final String searchQuery;

  const SearchResult({Key key, this.searchQuery}) : super(key: key);
  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Search"),
        ),
        backgroundColor: kBodyBackgroundColor,
        body: FutureBuilder(
          future: ApiHelper().searchCameo(searchQuery: widget.searchQuery),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                itemCount: snapshot.data.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, crossAxisSpacing: 5, mainAxisSpacing: 5),
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => Get.to(() => CameoDetailScreen(),
                      arguments: {"cameo_id": snapshot.data[index]["id"]}),
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
                                  '$domainUrl/${snapshot.data[index]["gig_image"]}',
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => Center(
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
                      ]),
                    ),
                  ),
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(
                  child: Text(snapshot.error,
                      style: TextStyle(color: Colors.white, fontSize: 20)));
            } else {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, mainAxisSpacing: 5, crossAxisSpacing: 5),
                itemBuilder: (context, index) => GridTile(
                  child: Shimmer.fromColors(
                      child: Container(
                        height: 200,
                        width: 300,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      baseColor: Colors.white,
                      highlightColor: Colors.grey[200]),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
