import 'package:cached_network_image/cached_network_image.dart';
import 'package:cameo/Screens/CameoDetailScreen.dart';
import 'package:cameo/constants.dart';
import 'package:cameo/controller/cameo_controller.dart';
import 'package:cameo/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;
import 'package:shimmer/shimmer.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatefulWidget {
  String name;
  String position;
  String url;
  double price;
  int id;
  CustomCard(
      {Key key, String name, String position, String url, var price, var id}) {
    this.name = name;
    // this.position = document.getElementsByTagName('strong')[0].innerHtml;
    this.position = position;
    this.url = url;
    this.price = double.parse(price);
    this.id = int.parse(id);
  }
  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        child: GestureDetector(
          onTap: () {
            Get.to(
              () => CameoDetailScreen(),
              arguments: {"cameo_id": widget.id.toString()},
              transition: Transition.rightToLeft,
              duration: Duration(milliseconds: 300),
            );
          },
          child: Container(
            width: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Stack(children: [
                    ShaderMask(
                      shaderCallback: (rect) {
                        return LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.grey, Colors.transparent],
                        ).createShader(
                            Rect.fromLTRB(0, 0, rect.width, rect.height + 50));
                      },
                      blendMode: BlendMode.dstIn,
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: CachedNetworkImage(
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                          imageUrl: widget.url,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Center(
                            child: Shimmer.fromColors(
                                child: Container(
                                  width: 200,
                                  height: 200,
                                ),
                                baseColor: Colors.grey.shade800,
                                highlightColor: Colors.grey),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Text(
                        '\$${widget.price.toInt()}',
                        style: kCardName,
                      ),
                    )
                  ]),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(titleCase(string: widget.name), style: kCardName),
                    height(6.0),
                    Container(
                      height: 30,
                      child: Text(
                        parseHtml2String(string: widget.position),
                        style: kSubText,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String parseHtml2String({String string}) {
  final document = parse(string);
  final String parsedString = parse(document.body.text).documentElement.text;

  return parsedString;
}
