import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cameo/Network/networkHelper.dart';
import 'package:cameo/Network/userSesionHelper.dart';
import 'package:cameo/Widgets/Loading%20Indicators/LoadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../constants.dart';
import '../../utils.dart';
import '../Popups and Dialogs/ProfilePictureSheet.dart';

class GeneralDetailTab extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  GeneralDetailTab({
    Key key,
    this.scaffoldKey,
  }) : super(key: key);

  @override
  _GeneralDetailTabState createState() => _GeneralDetailTabState();
}

class _GeneralDetailTabState extends State<GeneralDetailTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserSession().getCurrentUserId().then((value) => userId = value);
  }

  String userId;
  final FocusNode fnName = FocusNode();

  final FocusNode fnProfession = FocusNode();

  final FocusNode fnDecription = FocusNode();

  final FocusNode fnPhone = FocusNode();

  final FocusNode fnState = FocusNode();

  final FocusNode fnEmail = FocusNode();

  final FocusNode fnLanguage = FocusNode();

  final FocusNode fnCountry = FocusNode();

  final FocusNode fnZipcode = FocusNode();

  final FocusNode fnCity = FocusNode();

  final FocusNode fnAdress = FocusNode();

  ApiHelper _apiHelper = ApiHelper();

  String fullname;

  String profession;

  String description;

  String phone;

  String language;

  dynamic country;

  String zipcode;
  dynamic state;

  List stateList = [];

  String city;

  String address;

  dynamic professionDropDownValue;
  bool isCountryChanged = false;
  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserSession().getCurrentUserId(),
      builder: (context, snapshot) => snapshot.hasData
          ? FutureBuilder(
              future: _apiHelper.userDetiail(userId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 56,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.black.withAlpha(170),
                                      borderRadius: BorderRadius.circular(500)),
                                  child: Center(
                                    child: IconButton(
                                        splashRadius: 30,
                                        onPressed: () =>
                                            popBottomSheet(context: context),
                                        icon: Icon(Icons.edit)),
                                  ),
                                ),
                                backgroundImage: CachedNetworkImageProvider(
                                    'https://d31wcbk3iidrjq.cloudfront.net/UFtPf1TjL_avatar-5N0uIMgaL.jpg?h=332&w=332&q=100'),
                              ),
                              width(20.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: Theme(
                                      data: ThemeData(
                                        primaryColor: Colors.pinkAccent,
                                      ),
                                      child: TextFormField(
                                        focusNode: fnName,
                                        onEditingComplete: () =>
                                            FocusScope.of(context)
                                                .requestFocus(fnProfession),
                                        initialValue: snapshot.data[0]
                                            ["fullname"],
                                        onChanged: (value) => fullname = value,
                                        decoration: kEditFieldDecoration
                                            .copyWith(labelText: "Name"),
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                        textCapitalization:
                                            TextCapitalization.words,
                                      ),
                                    ),
                                  ),
                                  height(8.0),
                                  Container(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: DropdownButton(
                                          value: professionDropDownValue,
                                          isExpanded: true,
                                          hint: snapshot.data[0]
                                                      ["profession"] ==
                                                  null
                                              ? Text(
                                                  "Profession",
                                                  style: kDropDownTextStyle,
                                                )
                                              : Text(
                                                  snapshot.data[0]
                                                      ["profession_name"],
                                                  style: kDropDownTextStyle,
                                                ),
                                          items: snapshot.data[1]
                                              .map<DropdownMenuItem>(
                                                (element) => DropdownMenuItem(
                                                  value: element["id"],
                                                  child: Text(
                                                    element["profession_name"],
                                                    style: kDropDownTextStyle
                                                        .copyWith(fontSize: 16),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                          onChanged: (value) => {
                                                setState(() =>
                                                    professionDropDownValue =
                                                        value),
                                                profession = value,
                                              }))
                                ],
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Container(
                            child: Theme(
                              data: ThemeData(primaryColor: Colors.pinkAccent),
                              child: TextFormField(
                                onChanged: (value) => description = value,
                                onEditingComplete: () => FocusScope.of(context)
                                    .requestFocus(fnPhone),
                                focusNode: fnDecription,
                                decoration: kEditFieldDecoration.copyWith(
                                    labelText: "Description"),
                                maxLines: 4,
                                minLines: 1,
                                initialValue: snapshot.data[0]["description"],
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Container(
                            child: Theme(
                              data: ThemeData(primaryColor: Colors.pinkAccent),
                              child: TextFormField(
                                onChanged: (value) => phone = value,
                                initialValue: snapshot.data[0]["contact"],
                                onEditingComplete: () => FocusScope.of(context)
                                    .requestFocus(fnEmail),
                                focusNode: fnPhone,
                                decoration: kEditFieldDecoration.copyWith(
                                    labelText: "Phone"),
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Container(
                            child: Theme(
                              data: ThemeData(primaryColor: Colors.pinkAccent),
                              child: TextFormField(
                                readOnly: true,
                                initialValue: snapshot.data[0]["email"],
                                onEditingComplete: () => FocusScope.of(context)
                                    .requestFocus(fnLanguage),
                                focusNode: fnEmail,
                                decoration: kEditFieldDecoration.copyWith(
                                    labelText: "Email"),
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                ),
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: DropdownButton(
                            onTap: () =>
                                FocusScope.of(context).requestFocus(fnCountry),
                            focusNode: fnLanguage,
                            isExpanded: true,
                            value: language,
                            hint: language != null
                                ? Text(
                                    "Speaking Language",
                                    style: kDropDownTextStyle.copyWith(
                                        fontSize: 16),
                                  )
                                : Text(
                                    snapshot.data[0]["lang_speaks"],
                                    style: kDropDownTextStyle.copyWith(
                                        fontSize: 16),
                                  ),
                            elevation: 1,
                            items: [
                              DropdownMenuItem(
                                child: Text("English",
                                    style: kDropDownTextStyle.copyWith(
                                        fontSize: 16)),
                                value: 'English',
                              ),
                            ],
                            onChanged: (value) =>
                                setState(() => language = value),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: DropdownButton(
                            focusNode: fnCountry,
                            hint: snapshot.data[0]["country_name"] == null
                                ? Text("Country",
                                    style: kDropDownTextStyle.copyWith(
                                      fontSize: 16,
                                    ))
                                : Text(snapshot.data[0]["country_name"],
                                    style: kDropDownTextStyle.copyWith(
                                      fontSize: 16,
                                    )),
                            value: country,
                            isExpanded: true,
                            elevation: 1,
                            items: snapshot.data[2]
                                .map<DropdownMenuItem>(
                                  (element) => DropdownMenuItem(
                                    value: element["id"],
                                    child: Text(
                                      element["country"],
                                      style: kDropDownTextStyle.copyWith(
                                          fontSize: 16),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) async {
                              loading(context);
                              setState(() => {country = value});
                              Response response =
                                  await _apiHelper.state(int.parse(country));
                              List data = jsonDecode(response.body);
                              snapshot.data[0]["state_name"] = null;
                              setState(() {
                                stateList = data;
                                isCountryChanged = true;
                              });
                              Navigator.of(context).pop();
                              FocusScope.of(context).requestFocus(fnState);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: DropdownButton(
                            focusNode: fnState,
                            hint: snapshot.data[0]["state_name"] == null ||
                                    isCountryChanged
                                ? Text("State",
                                    style: kDropDownTextStyle.copyWith(
                                      fontSize: 16,
                                    ))
                                : Text(snapshot.data[0]["state_name"],
                                    style: kDropDownTextStyle.copyWith(
                                      fontSize: 16,
                                    )),
                            value: state,
                            isExpanded: true,
                            elevation: 1,
                            items: stateList
                                .map<DropdownMenuItem>(
                                  (element) => DropdownMenuItem(
                                    value: element["state_id"],
                                    child: Text(
                                      element["state_name"],
                                      style: kDropDownTextStyle.copyWith(
                                          fontSize: 16),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) => {
                              setState(() => state = value),
                              FocusScope.of(context).requestFocus(fnZipcode)
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Container(
                            child: Theme(
                              data: ThemeData(primaryColor: Colors.pinkAccent),
                              child: TextFormField(
                                onChanged: (value) => zipcode = value,
                                initialValue: snapshot.data[0]["zipcode"],
                                focusNode: fnZipcode,
                                onEditingComplete: () =>
                                    FocusScope.of(context).requestFocus(fnCity),
                                decoration: kEditFieldDecoration.copyWith(
                                    labelText: "Zip code"),
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Container(
                            child: Theme(
                              data: ThemeData(primaryColor: Colors.pinkAccent),
                              child: TextFormField(
                                onChanged: (value) => city = value,
                                initialValue: snapshot.data[0]["city"],
                                focusNode: fnCity,
                                onEditingComplete: () => FocusScope.of(context)
                                    .requestFocus(fnAdress),
                                decoration: kEditFieldDecoration.copyWith(
                                    labelText: "City"),
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Container(
                            child: Theme(
                              data: ThemeData(primaryColor: Colors.pinkAccent),
                              child: TextFormField(
                                onChanged: (value) => address = value,
                                initialValue: snapshot.data[0]["address"],
                                focusNode: fnAdress,
                                maxLines: 3,
                                minLines: 1,
                                decoration: kEditFieldDecoration.copyWith(
                                    labelText: "Address"),
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                ),
                                keyboardType: TextInputType.streetAddress,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: FlatButton(
                            onPressed: () async {
                              loading(context);
                              bool isUpdated =
                                  await _apiHelper.updateUserDetail(
                                      scaffoldKey: widget.scaffoldKey,
                                      id: await UserSession()
                                          .getCurrentUserId(),
                                      fullname: fullname != null
                                          ? fullname
                                          : snapshot.data[0]["fullname"],
                                      profession: profession != null
                                          ? profession
                                          : snapshot.data[0]["profession"],
                                      city: city != null
                                          ? city
                                          : snapshot.data[0]["city"],
                                      description: description != null
                                          ? description
                                          : snapshot.data[0]["description"],
                                      phone: phone != null
                                          ? phone
                                          : snapshot.data[0]['contact'],
                                      address: address != null
                                          ? address
                                          : snapshot.data[0]["address"],
                                      zipcode: zipcode != null
                                          ? zipcode
                                          : snapshot.data[0]["zipcode"],
                                      language: language != null
                                          ? language
                                          : snapshot.data[0]["lang_speaks"],
                                      country: country != null
                                          ? country
                                          : snapshot.data[0]["country"],
                                      state: state != null
                                          ? state
                                          : snapshot.data[0]["state_id"]);
                              if (isUpdated) {
                                Navigator.pop(context);
                                forceHideKeyboard(context);
                                widget.scaffoldKey.currentState
                                    .removeCurrentSnackBar();
                                widget.scaffoldKey.currentState
                                    .showSnackBar(SnackBar(
                                  backgroundColor: Colors.white,
                                  content: Text(
                                    "Profile updated successfully",
                                    style: TextStyle(color: kSecondaryColor),
                                  ),
                                ));
                              }
                            },
                            child: Text(
                              'Update',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.pinkAccent,
                          ),
                        )
                      ],
                    ),
                  );
                }
                if (snapshot.hasError) {
                  print(snapshot.toString());
                  return Text("Something went wrong");
                } else
                  return Center(child: CircularProgressIndicator());
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
