import 'package:connect/responsive/responsive_layout.dart';
import 'package:connect/screens/home_screens/home_web_screen.dart';
import 'package:flutter/material.dart';

import 'home_mobile_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(mobileBody: HomeMobileScreen(), desktopBody: HomeWebScreen());
  }
}
