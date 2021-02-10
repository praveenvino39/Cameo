import 'dart:convert';

import 'package:flutter/material.dart';

import '../constants.dart';
import 'CustomCard.dart';

class CustomSection extends StatefulWidget {
  CustomSection({Key key, String title, var cardItems}) {
    this.title = title;
    this.cardItems = cardItems;
  }
  String title;
  var cardItems = [];
  @override
  _CustomSectionState createState() => _CustomSectionState();
}

class _CustomSectionState extends State<CustomSection> {
  HtmlEscape santizer = HtmlEscape(HtmlEscapeMode.unknown);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 1.5,
                child: Text(
                  widget.title,
                  style: kSeactionTitle,
                ),
              ),
              Text("see all", style: kSeeAllStyle),
            ],
          ),
        ),
        Container(
            margin: EdgeInsets.only(top: 10),
            height: 280,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount:
                    widget.cardItems != null ? widget.cardItems.length : 0,
                itemBuilder: (context, index) => CustomCard(
                      name: widget.cardItems[index]["title"],
                      position: widget.cardItems[index]["gig_details"],
                      url:
                          'https://cameo.deliveryventure.com/${widget.cardItems[index]["gig_image"]}',
                      price: widget.cardItems[index]["gig_price"],
                      id: widget.cardItems[index]["id"],
                    )))
      ],
    );
  }
}
