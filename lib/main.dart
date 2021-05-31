import 'package:connect/login.dart';
import 'package:connect/themeProvider.dart';
import 'package:flutter/material.dart';

import 'conversationScreen.dart';
import 'mainPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connect Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        //canvasColor: Colors.blue
      ),
      home: Login(),

    );
  }
}


