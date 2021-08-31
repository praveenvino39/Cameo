import 'package:flutter/cupertino.dart';
import 'package:recase/recase.dart';

Widget height(value) {
  return SizedBox(height: value);
}

Widget width(value) {
  return SizedBox(width: value);
}

String titleCase({String string}) {
  ReCase rescase = ReCase(string);
  return rescase.titleCase;
}

void forceHideKeyboard(context) {
  FocusScope.of(context).requestFocus(FocusNode());
}
