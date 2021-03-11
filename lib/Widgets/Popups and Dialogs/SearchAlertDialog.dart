import 'dart:convert';

import 'package:cameo/Network/networkHelper.dart';
import 'package:cameo/Screens/SearchResult.dart';
import 'package:cameo/Widgets/Loading%20Indicators/LoadingIndicator.dart';
import 'package:cameo/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class SearchAlertDialog extends StatefulWidget {
  SearchAlertDialog({
    Key key,
  }) : super(key: key);

  @override
  _SearchAlertDialogState createState() => _SearchAlertDialogState();
}

class _SearchAlertDialogState extends State<SearchAlertDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  String searchQuery;
  var selectedCountry;
  List stateList = [];
  var selectedState;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: _formKey,
        child: Theme(
          data: ThemeData(primaryColor: Colors.pinkAccent),
          child: TextFormField(
            onChanged: (value) => searchQuery = value,
            validator: MinLengthValidator(1,
                errorText: "Search field shouldn't be empty"),
            decoration: InputDecoration(hintText: 'Search your Cameos...'),
          ),
        ),
      ),
      actions: [
        DropdownButton(
          items: [],
          onChanged: (value) => {},
          hint: Text('Category'),
        ),
        FutureBuilder(
          future: ApiHelper().countryJson(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return DropdownButton(
                value: selectedCountry,
                items: snapshot.data
                    .map<DropdownMenuItem>(
                      (element) => DropdownMenuItem(
                        value: element["id"],
                        child: Container(
                          width: 200,
                          child: Text(
                            element["country"],
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) async {
                  loading(context);
                  selectedCountry = value;
                  var response =
                      await ApiHelper().state(int.parse(selectedCountry));
                  stateList = jsonDecode(response.body);
                  setState(() => {});
                  Navigator.pop(context);
                },
                hint: Text('Country'),
              );
            } else {
              return Container(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(kSecondaryColor),
                ),
              );
            }
          },
        ),
        DropdownButton(
          value: selectedState,
          items: stateList
              .map<DropdownMenuItem>((element) => DropdownMenuItem(
                    value: element["state_id"],
                    child: Text(element["state_name"]),
                  ))
              .toList(),
          onChanged: (value) => {setState(() => selectedState = value)},
          hint: Text('State'),
        ),
        FlatButton(
          color: Colors.pinkAccent,
          onPressed: () {
            if (_formKey.currentState.validate()) {
              Navigator.pop(context);
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => SearchResult(
                    searchQuery: searchQuery,
                  ),
                ),
              );
            }
          },
          child: Text(
            'Search',
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }
}
