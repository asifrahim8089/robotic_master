// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

void showSnackBar(
    {@required String? message,
    @required BuildContext? context,
    Duration? duration}) {
  var snack = SnackBar(
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.all(20),
    duration: duration ?? Duration(milliseconds: 4000),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    content: Text(
      message!,
      textScaleFactor: 1,
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.black.withAlpha(200),
  );
  ScaffoldMessenger.of(context!).showSnackBar(snack);
}
