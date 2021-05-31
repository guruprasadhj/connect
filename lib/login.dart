import 'package:connect/mainPage.dart';
import 'package:connect/profile.dart';
import 'package:connect/themeProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'service/auth.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}
final String logo = 'assets/images/logo.svg';

class _LoginState extends State<Login> {
  bool themeSwitch = false;
  bool isLoading   = false;
  AuthService _authService = new AuthService();
  @override
  Widget build(BuildContext context) {
    //var themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      //backgroundColor: Colors.red,
      body : isLoading == true  ? Center(child: Container(child: CircularProgressIndicator(),)):
      Container(
        //color: Colors.black,
        child: Center(
          child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 25,right: 25),
                    child: Align(

                      alignment: Alignment.topRight,
                      child: Switch(
                        value: false,
                        onChanged: (value) {
                          setState(() {});
                        },
                        activeTrackColor: Colors.cyanAccent,
                        activeColor: Colors.blue,
                      ),
                    )
                  ),

                  Align(
                    alignment:Alignment.center ,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                            image: AssetImage("assets/images/logo.png"),
                            height: 150.0),
                        SizedBox(
                          height: 50,
                        ),
                        _loginButton(),
                      ],
                    ),
                  ),

    ],),),),);
  }

  Widget _loginButton() {
    return OutlineButton(
      splashColor: Colors.grey,
       onPressed: ()async{
        setState(() => isLoading = true);
        await _authService.googleSignIn(context);
        },

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
                image: AssetImage("assets/images/google_logo.png"),
                height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
