import 'package:connect/screens/register_screens/register_mobile_screen.dart';
import 'package:connect/screens/register_screens/register_web_screen.dart';
import 'package:flutter/material.dart';

import '../../responsive/responsive_layout.dart';
import '../login_screens/Login_screen_web_view.dart';
import '../login_screens/login_mobile_screen.dart';
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(mobileBody: RegisterMobileScreen(), desktopBody: RegisterWebScreen());
  }
}
