import 'package:cameo/constants.dart';
import 'package:flutter/material.dart';

class FilterDropDown extends StatelessWidget {
  final List items;
  final Function onChanged;
  const FilterDropDown({Key key, this.items, this.onChanged}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: DropdownButton(
          hint: DropdownMenuItem(
            child: Text(
              'Select Status',
              style: kDropDownTextStyle.copyWith(fontSize: 16),
            ),
          ),
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(
                    e,
                    style: kDropDownTextStyle.copyWith(fontSize: 16),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            onChanged();
          }),
    );
  }
}
