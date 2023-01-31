import 'package:flutter/material.dart';

import '../../responsive/responsive_layout.dart';
import 'Login_screen_web_view.dart';
import 'login_mobile_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(mobileBody: LoginMobileScreen(), desktopBody: LoginWebScreen());
  }
}
