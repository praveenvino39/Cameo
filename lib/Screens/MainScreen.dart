import 'package:cameo/MockData/data.dart';
import 'package:cameo/Widgets/CustomAppBar.dart';
import 'package:cameo/Widgets/CustomDrawer.dart';
import 'package:cameo/Widgets/CustomSection.dart';
import 'SearchResult.dart';
import 'package:cameo/Widgets/Teaser.dart';
import 'package:cameo/constants.dart';
// ignore: implementation_imports
import 'package:flutter/src/material/refresh_indicator.dart' as baseRefresh;
import 'package:cameo/utils.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cameo/Network/networkHelper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List popularCameo;
  ApiHelper apiHelper = ApiHelper();
  TextEditingController searchController = TextEditingController();
  bool showSearch = false;
  List latestCameo;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  FlutterSecureStorage _storage = FlutterSecureStorage();
  final GlobalKey<baseRefresh.RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<baseRefresh.RefreshIndicatorState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DataConnectionChecker().hasConnection.then((value) => {
          if (value)
            scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text("Updating contents"),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ))
          else
            scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text("No internet connection"),
              backgroundColor: Colors.red,
            ))
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent,
        onPressed: () async => {
          setState(() => showSearch = !showSearch),
          // showDialog(
          //   context: context,
          //   builder: (context) => SearchAlertDialog(),
          // )
        },
        child: Icon(
          Icons.search,
          color: Colors.white,
          size: 25,
        ),
        elevation: 3,
      ),
      drawer: CustomDrawer(),
      key: scaffoldKey,
      appBar: !showSearch
          ? PreferredSize(
              preferredSize: kPrefredSize,
              child: CustomAppBar(
                scaffoldKey: scaffoldKey,
              ),
            )
          : AppBar(
              title: TextField(
                controller: searchController,
                autofocus: true,
                style: TextStyle(
                  color: Colors.white,
                ),
                keyboardAppearance: Brightness.light,
                textInputAction: TextInputAction.search,
                onEditingComplete: () {
                  Get.to(
                      () => SearchResult(searchQuery: searchController.text));
                },
                decoration: InputDecoration(
                    hintText: "Search you cameos...",
                    suffixIcon: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => setState(() => showSearch = !showSearch),
                      color: kSecondaryColor,
                      iconSize: 17,
                      splashRadius: 20,
                    ),
                    hintStyle: TextStyle(color: Colors.grey)),
              ),
            ),
      backgroundColor: kBodyBackgroundColor,
      body: baseRefresh.RefreshIndicator(
        color: kSecondaryColor,
        backgroundColor: Colors.white,
        onRefresh: () async {
          await apiHelper.popularCameos();
          setState(() {});
        },
        key: _refreshIndicatorKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Teaser()),
              //To Render Popular Cameos
              FutureBuilder(
                  future: apiHelper.popularCameos(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return CustomSection(
                        title: 'Popular',
                        cardItems: snapshot.data,
                      );
                    }
                    if (snapshot.hasError) {
                      print(snapshot.error);
                      return Center(
                        child: ListTile(
                          leading: Icon(Icons.error),
                          title: Text(
                            "Something went wrong",
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          ),
                        ),
                      );
                    } else
                      return Container(
                        height: 280,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                  }),
              //To Render Latest Cameos
              FutureBuilder(
                  future: apiHelper.latestCameo(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return CustomSection(
                        title: 'Latest',
                        cardItems: snapshot.data,
                      );
                    }
                    if (snapshot.hasError) {
                      print(snapshot.error);
                      return Center(
                        child: ListTile(
                          leading: Icon(Icons.error),
                          title: Text(
                            "Something went wrong",
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          ),
                        ),
                      );
                    } else
                      return Column(
                        children: [
                          Container(
                            height: 280,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ],
                      );
                  }),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 13),
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: Text(
                        "Categories",
                        style: kSeactionTitle,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      height: 100,
                      child: ListView.builder(
                          itemCount: categories.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                width: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Stack(children: [
                                  Container(
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Image(
                                      image: NetworkImage(
                                          categories[index]["url"]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Container(
                                    width: 200,
                                    height: 150,
                                    color: Color.fromARGB(70, 19, 20, 49),
                                  ),
                                  Positioned(
                                      top: 10,
                                      left: 10,
                                      child: Text(
                                        categories[index]["title"],
                                        style: kCategoryTitle,
                                      )),
                                ]),
                              )),
                    )
                  ],
                ),
              ),
              //Invisible sizedbox to align main axis element
              width(MediaQuery.of(context).size.width)
            ],
          ),
        ),
      ),
    );
  }
}
