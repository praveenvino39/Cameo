import 'package:flutter/material.dart';

void loading(context) {
  showDialog(
      context: (context),
      builder: (context) => Center(
            child: CircularProgressIndicator(),
          ));
}
