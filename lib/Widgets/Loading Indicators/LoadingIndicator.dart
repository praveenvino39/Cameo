import 'package:flutter/material.dart';

void loading(context) {
  showDialog(
      barrierDismissible: false,
      context: (context),
      builder: (context) => Center(
            child: CircularProgressIndicator(),
          ));
}
