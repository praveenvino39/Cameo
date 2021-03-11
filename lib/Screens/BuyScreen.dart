import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cameo/Network/networkHelper.dart';
import 'package:cameo/Widgets/CustomCard.dart';
import 'package:cameo/constants.dart';
import 'package:cameo/utils.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class BuyScreen extends StatefulWidget {
  @override
  _BuyScreenState createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {
  ApiHelper _apiHelper = ApiHelper();
  List states = [];
  int countryId;
  Map selectedCountryID = {"country": "", "id": ""};
  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        backgroundColor: kBodyBackgroundColor,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Stack(children: [
                Column(
                  children: [
                    // height(70.00),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Filters",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              FutureBuilder(
                                  future: _apiHelper.countryJson(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData)
                                      return DropdownButton(
                                          // value: selectedCountryID["id"],
                                          hint: Text(
                                            "Country",
                                            style: kDropDownTextStyle.copyWith(
                                                fontSize: 14),
                                          ),
                                          items: snapshot.data
                                              .map<DropdownMenuItem>((d) =>
                                                  DropdownMenuItem(
                                                    value: d["id"],
                                                    child: Text(
                                                      d["country"],
                                                      style: kDropDownTextStyle
                                                          .copyWith(
                                                              fontSize: 14),
                                                    ),
                                                  ))
                                              .toList(),
                                          onChanged: (value) async {
                                            countryId = int.parse(value);
                                            var response = await _apiHelper
                                                .state(countryId);
                                            var data =
                                                jsonDecode(response.body);
                                            setState(() {
                                              states = data;
                                              var e = snapshot.data.firstWhere(
                                                  (e) =>
                                                      e["id"] ==
                                                      value.toString());

                                              selectedCountryID = e;
                                            });
                                          });
                                    else
                                      return Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Center(
                                            child: CircularProgressIndicator()),
                                      );
                                  }),
                              DropdownButton(
                                  hint: Text(
                                    "State",
                                    style: kDropDownTextStyle.copyWith(
                                        fontSize: 14),
                                  ),
                                  // value: selectedStateID["state_id"],
                                  items: states
                                      .map<DropdownMenuItem>(
                                          (e) => DropdownMenuItem(
                                                value: e["state_id"],
                                                child: Text(
                                                  e["state_name"],
                                                  style: kDropDownTextStyle
                                                      .copyWith(fontSize: 14),
                                                ),
                                              ))
                                      .toList(),
                                  onChanged: (value) {
                                    var e = states.firstWhere((element) =>
                                        element["state_id"] == value);
                                    // selectedStateID = e;
                                  }),
                              DropdownButton(
                                  value: "Heloo",
                                  items: [
                                    DropdownMenuItem(
                                      value: "Heloo",
                                      child: Text(
                                        'Comedian',
                                        style: kDropDownTextStyle.copyWith(
                                            fontSize: 14),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      child: Text(
                                        'Notes and Networthy',
                                        style: kDropDownTextStyle.copyWith(
                                            fontSize: 14),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      child: Text(
                                        'Musician ',
                                        style: kDropDownTextStyle.copyWith(
                                            fontSize: 14),
                                      ),
                                    ),
                                  ],
                                  onChanged: (value) => {
                                        // print(
                                        //     "Selected Country ${selectedCountryID.toString()}"),
                                        // print(
                                        //     "Selected State ${selectedStateID.toString()}")
                                      }),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // height(15.0),
                        // Text('Results',
                        //     style:
                        //         TextStyle(color: Colors.white, fontSize: 16)),
                        height(20.0),
                        Container(
                          height: MediaQuery.of(context).size.height / 1.201,
                          // height: 554,
                          child: FutureBuilder(
                            future: _apiHelper.buyCameo(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return GridView.builder(
                                    itemCount: snapshot.data.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            mainAxisSpacing: 5,
                                            crossAxisSpacing: 5),
                                    itemBuilder: (context, index) =>
                                        Stack(children: [
                                          ShaderMask(
                                            shaderCallback: (rect) {
                                              return LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Colors.grey,
                                                  Colors.transparent
                                                ],
                                              ).createShader(Rect.fromLTRB(
                                                  0,
                                                  0,
                                                  rect.width,
                                                  rect.height + 50));
                                            },
                                            blendMode: BlendMode.dstIn,
                                            child: Container(
                                              clipBehavior: Clip.hardEdge,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: CachedNetworkImage(
                                                height: 200,
                                                fit: BoxFit.cover,
                                                imageUrl:
                                                    'https://cameo.deliveryventure.com/${snapshot.data[index]["gig_image"]}',
                                                progressIndicatorBuilder:
                                                    (context, url,
                                                            downloadProgress) =>
                                                        Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                          value:
                                                              downloadProgress
                                                                  .progress),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                              bottom: 10,
                                              left: 10,
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2.8,
                                                child: Text(
                                                  titleCase(
                                                    string: snapshot.data[index]
                                                        ["title"],
                                                  ),
                                                  overflow: TextOverflow.fade,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18),
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
                      ],
                    ),
                  ],
                ),
                // Container(
                //   height: 60,
                //   child: FloatingSearchBar(
                //     onFocusChanged: (value) => {},
                //     onSubmitted: (value) => print(value),
                //     elevation: 2,
                //     hint: 'Search...',
                //     toolbarOptions: ToolbarOptions(
                //         copy: true, paste: true, selectAll: true),
                //     scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
                //     transitionDuration: const Duration(milliseconds: 800),
                //     transitionCurve: Curves.easeInOut,
                //     physics: const BouncingScrollPhysics(),
                //     axisAlignment: isPortrait ? 0.0 : -1.0,
                //     openAxisAlignment: 0.0,
                //     maxWidth: isPortrait ? 600 : 500,
                //     transition: CircularFloatingSearchBarTransition(),
                //     actions: [
                //       FloatingSearchBarAction(
                //         showIfOpened: false,
                //         child: CircularButton(
                //           icon: const Icon(Icons.place),
                //           onPressed: () {},
                //         ),
                //       ),
                //       FloatingSearchBarAction.searchToClear(
                //         showIfClosed: false,
                //       ),
                //     ],
                //     builder: (context, transition) {
                //       return Container();
                //     },
                //   ),
                // ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
