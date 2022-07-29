import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    title: appBar(context),
    backgroundColor: Color(0xff145C9E),
    elevation: 0.0,
    centerTitle: false,
    brightness: Brightness.dark,
  );
}

appBar(BuildContext context) {
}

// ignore: camel_case_types
class colorWidget{
  static String guru = Colors.white as String;
  final Color redColor = Color(0xffd80147);
}