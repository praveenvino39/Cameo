import 'package:cameo/Screens/SearchResult.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class SearchAlertDialog extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey();
  SearchAlertDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: _formKey,
        child: Theme(
          data: ThemeData(primaryColor: Colors.pinkAccent),
          child: TextFormField(
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
        DropdownButton(
          items: [],
          onChanged: (value) => {},
          hint: Text('Country'),
        ),
        DropdownButton(
          items: [],
          onChanged: (value) => {},
          hint: Text('State'),
        ),
        FlatButton(
          color: Colors.pinkAccent,
          onPressed: () => {
            if (_formKey.currentState.validate())
              {
                Navigator.pop(context),
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => SearchResult(),
                  ),
                )
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
