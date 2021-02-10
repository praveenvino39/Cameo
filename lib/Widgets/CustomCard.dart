import 'package:cameo/Screens/CameoDetailScreen.dart';
import 'package:cameo/constants.dart';
import 'package:cameo/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;
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
    dom.Document document = parse(position);
    this.position = document.getElementsByTagName('strong')[0].innerHtml;
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
          onTap: () => {
            print(widget.id.toString()),
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => CameoDetailScreen(id: widget.id)))
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
                        child: FadeInImage.memoryNetwork(
                          fadeInDuration: Duration(milliseconds: 200),
                          placeholder: kTransparentImage,
                          height: 200,
                          image: widget.url,
                          fit: BoxFit.cover,
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
                    Text(widget.name, style: kCardName),
                    height(6.0),
                    Text(
                      widget.position,
                      style: kSubText,
                      overflow: TextOverflow.ellipsis,
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
