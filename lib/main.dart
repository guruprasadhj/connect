import 'package:connect/helpers/constants.dart';
import 'package:connect/helpers/helperfunction.dart';
import 'package:connect/views/default/main_page.dart';
import 'package:connect/views/intros/welcome.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunction.getUserLoggedInSharedPreference().then((value){
      setState(() {
        userIsLoggedIn  = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: AppBarTheme(
            //color: Color(0xffd80147),
          ),
        backgroundColor: Color(0xff0d0d0d),
        primarySwatch: Colors.red,
        brightness: Constants.mode==false? Brightness.light : Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:  userIsLoggedIn != null ?  userIsLoggedIn ? MainPage() : Welcome()
        : Container(
    child: Center(
    child: Welcome(),
    ),
    ));
  }
}

