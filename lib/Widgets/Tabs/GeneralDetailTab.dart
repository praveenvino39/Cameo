import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../utils.dart';
import '../Popups and Dialogs/ProfilePictureSheet.dart';

class GeneralDetailTab extends StatelessWidget {
  GeneralDetailTab({
    Key key,
  }) : super(key: key);

  final FocusNode fnName = FocusNode();
  final FocusNode fnProfession = FocusNode();
  final FocusNode fnDecription = FocusNode();
  final FocusNode fnPhone = FocusNode();
  final FocusNode fnEmail = FocusNode();
  final FocusNode fnLanguage = FocusNode();
  final FocusNode fnCountry = FocusNode();
  final FocusNode fnZipcode = FocusNode();
  final FocusNode fnCity = FocusNode();
  final FocusNode fnAdress = FocusNode();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
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
                          onPressed: () => popBottomSheet(context: context),
                          icon: Icon(Icons.edit)),
                    ),
                  ),
                  backgroundImage: NetworkImage(
                      'https://d31wcbk3iidrjq.cloudfront.net/UFtPf1TjL_avatar-5N0uIMgaL.jpg?h=332&w=332&q=100'),
                ),
                width(20.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Theme(
                        data: ThemeData(primaryColor: Colors.pinkAccent),
                        child: TextFormField(
                          focusNode: fnName,
                          onEditingComplete: () =>
                              FocusScope.of(context).requestFocus(fnProfession),
                          initialValue: "Alfonso Ribeiro",
                          decoration:
                              kEditFieldDecoration.copyWith(labelText: "Name"),
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          textCapitalization: TextCapitalization.words,
                        ),
                      ),
                    ),
                    height(8.0),
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Theme(
                        data: ThemeData(primaryColor: Colors.pinkAccent),
                        child: TextFormField(
                          onEditingComplete: () =>
                              FocusScope.of(context).requestFocus(fnDecription),
                          focusNode: fnProfession,
                          decoration: kEditFieldDecoration.copyWith(
                              labelText: "Profession"),
                          initialValue: 'Actor - The Fresh Prince of Bel-Air',
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.white70,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    )
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
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(fnPhone),
                  focusNode: fnDecription,
                  decoration:
                      kEditFieldDecoration.copyWith(labelText: "Description"),
                  maxLines: 4,
                  initialValue:
                      'The Hardcore Legend. These videos are perfect for any occasion! I do my best to create amazing videos...and memories! Check out my reviews!10% of NOV sales will go to http://christmasmagic.org',
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
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(fnEmail),
                  focusNode: fnPhone,
                  decoration: kEditFieldDecoration.copyWith(labelText: "Phone"),
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
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(fnLanguage),
                  focusNode: fnEmail,
                  decoration: kEditFieldDecoration.copyWith(labelText: "Email"),
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
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: DropdownButton(
              onTap: () => FocusScope.of(context).requestFocus(fnCountry),
              focusNode: fnLanguage,
              hint: Text("Speaks"),
              isExpanded: true,
              elevation: 1,
              items: [
                DropdownMenuItem(
                  onTap: () => {},
                  child: Text("Language",
                      style: kDropDownTextStyle.copyWith(fontSize: 17)),
                ),
                DropdownMenuItem(
                  child: Text("English", style: kDropDownTextStyle),
                ),
                DropdownMenuItem(
                  child: Text("Tamil", style: kDropDownTextStyle),
                ),
                DropdownMenuItem(
                  child: Text("Dustch", style: kDropDownTextStyle),
                ),
                DropdownMenuItem(
                  child: Text("Spanish", style: kDropDownTextStyle),
                ),
                DropdownMenuItem(
                  child: Text("Japanese", style: kDropDownTextStyle),
                ),
                DropdownMenuItem(
                  child: Text("French", style: kDropDownTextStyle),
                ),
              ],
              onChanged: (value) => {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: DropdownButton(
              focusNode: fnCountry,
              onTap: () => FocusScope.of(context).requestFocus(fnZipcode),
              hint: Text("Country"),
              isExpanded: true,
              elevation: 1,
              items: [
                DropdownMenuItem(
                  onTap: () => {},
                  child: Text("Country",
                      style: kDropDownTextStyle.copyWith(fontSize: 17)),
                ),
                DropdownMenuItem(
                  child: Text("India", style: kDropDownTextStyle),
                ),
                DropdownMenuItem(
                  child: Text("United States", style: kDropDownTextStyle),
                ),
                DropdownMenuItem(
                  child: Text("United Kingdom", style: kDropDownTextStyle),
                ),
                DropdownMenuItem(
                  child: Text("Australia", style: kDropDownTextStyle),
                ),
                DropdownMenuItem(
                  child: Text("Africa", style: kDropDownTextStyle),
                ),
                DropdownMenuItem(
                  child: Text("French", style: kDropDownTextStyle),
                ),
              ],
              onChanged: (value) => {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              child: Theme(
                data: ThemeData(primaryColor: Colors.pinkAccent),
                child: TextFormField(
                  focusNode: fnZipcode,
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(fnCity),
                  decoration:
                      kEditFieldDecoration.copyWith(labelText: "Zip code"),
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
                  focusNode: fnCity,
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(fnAdress),
                  decoration: kEditFieldDecoration.copyWith(labelText: "City"),
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
                  focusNode: fnAdress,
                  maxLines: 3,
                  decoration:
                      kEditFieldDecoration.copyWith(labelText: "Address"),
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
              onPressed: () => {},
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
}
