import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/helper/constants.dart';
import 'package:connect/helper/helperfunction.dart';
import 'package:connect/screens/home.dart';
import 'package:connect/screens/loader.dart';
import 'package:connect/screens/verify.dart';
import 'package:connect/services/auth.dart';
import 'package:connect/services/database.dart';
import 'package:connect/widgets/widget.dart';

import 'package:connect/screens/register.dart';
import 'package:connect/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late bool isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late bool emailValid = false;

  late String emailId;
  late String username;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  AuthService authService = AuthService();
  DatabaseMethods _databaseMethods = DatabaseMethods();

  late QuerySnapshot userSnapshot;

  getUserInfo() async {
    final SharedPreferences prefs = await _prefs;

    await _databaseMethods.getUserInfo(_emailController.text).then((snapshot) {
      userSnapshot = snapshot;
      Constants.setEmail(_emailController.text);
      Constants.setUserLoggedIn(true);
      if (userSnapshot.docs.length > 0) {
        username = snapshot.docs[0].data()["useremail"];
        Constants.setUsername(username);
        print("-----------------" + username);
      }

      emailId = prefs.getString(Constants.sharedPreferenceUserEmailKey)!;

      print("------------------$emailId");
      Navigator.push(context,
          PageTransition(type: PageTransitionType.fade, child: LoaderPage()));
    });
    //HelperFunctions.sharedPreferenceUserEmailKey(_emailController.text);
    //Constants.sharedPreferenceUserEmailKey;
  }

  logIn() async {
    setState(() {
      isLoading = true;
    });

    print("logIn");
    await authService.SignInWithEmailAndPassword(
            _emailController.text, _passwordController.text)
        .then((result) {
      if (result == "Done") {
        Constants.setEmail(_emailController.text);
        print("---------------" + result);
        //getUserInfo();
      } else {
        // if (result.code == 'user-not-found') {
        setState(() {
          isLoading = false;
        });
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Email doesn\'t exist'),
                content: const Text('Join Us today instead'),
                actions: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const Register())),
                    child: const Text('OK'),
                  ),
                ],
              );
            });
        // }
        // if (result.code == 'email-doesnt-exist') {
        //   // tell use to sign up...
        // }
        // if (result.code == 'wrong-password') {
        //   showDialog(
        //     context: context,
        //     builder: (context) {
        //       return const AlertDialog(
        //         title: Text('Wrong Password'),
        //         content: Text('Try Again'),
        //       );
        //     },
        //   );
        // }
      }
    });
  }

  Future<void> emailCheck() async {
    if (_emailController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      Timer(const Duration(seconds: 1), () {
        print("Yeah, this done after 1 seconds");

        setState(() {
          emailValid = RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(_emailController.text);
          isLoading = false;
        });
      });

      print(emailValid);
    } else {
      print("It is empty");
      const snackBar = SnackBar(
        content: Text('The Email field is Empty'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Fluttertoast.showToast(
        msg: "The Email field is Empty",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        // timeInSecForIos: 1               // duration
      );
    }
  }

  Widget _updateButton() {
    return isLoading
        ? const SizedBox(
            height: 70,
            width: 70,
            child: CircularProgressIndicator(
              backgroundColor: Colors.grey,
            ),
          )
        : const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
            size: 20,
          );
  }

  void butonPressed() {
    print("Pressed");
    emailValid ? logIn() : emailCheck();
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xff7bd5f5),
      body: Stack(
        children: <Widget>[
          const bgWidget(),
          SafeArea(
            child: Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Hello!",
                            style: TextStyle(
                              fontFamily: 'Ubuntu',
                              fontSize: 70,
                            ),
                          ),
                          const Text(
                            "Log In to Your Account",
                            style: TextStyle(),
                          ),
                          (currentWidth > 600)
                              ? Container(
                                  height: 50,
                                  width: 400,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFffffff)
                                        .withOpacity(0.4),
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: TextField(
                                      onSubmitted: (value) {
                                        butonPressed();
                                      },
                                      textInputAction: TextInputAction.next,
                                      textAlign: TextAlign.center,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Email",
                                      ),
                                      readOnly: isLoading,
                                      controller: _emailController,
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    readOnly: isLoading,
                                    controller: _emailController,
                                    textInputAction: TextInputAction.next,
                                    textAlign: TextAlign.left,
                                    decoration: InputDecoration(
                                      hintText: "Email ID",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                  ),
                                ),
                          emailValid
                              ? (currentWidth > 600)
                                  ? Container(
                                      height: 50,
                                      width: 400,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFffffff)
                                            .withOpacity(0.4),
                                        border: Border.all(color: Colors.white),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: TextField(
                                          onSubmitted: (value) {
                                            butonPressed();
                                          },
                                          autofocus: true,
                                          readOnly: isLoading,
                                          textAlign: TextAlign.center,
                                          obscureText: true,
                                          enableSuggestions: false,
                                          autocorrect: false,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Password",
                                          ),
                                          controller: _passwordController,
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(
                                        readOnly: isLoading,
                                        controller: _passwordController,
                                        obscureText: true,
                                        enableSuggestions: false,
                                        autocorrect: false,
                                        textInputAction: TextInputAction.next,
                                        textAlign: TextAlign.left,
                                        decoration: InputDecoration(
                                          hintText: "Password",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                        ),
                                      ),
                                    )
                              : const SizedBox(),
                          GestureDetector(
                            onTap: () {
                              butonPressed();
                            },
                            child: Container(
                                margin: const EdgeInsets.all(10),
                                constraints: const BoxConstraints(
                                    minWidth: 70, minHeight: 70),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  color: const Color(0xff18293c),
                                  shape: BoxShape.circle,
                                ),
                                child: AnimatedSwitcher(
                                  duration: const Duration(seconds: 1),
                                  child: _updateButton(),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 550),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.fade,
                                    child: const VerifyPage()));
                          },
                          child: const Text(
                            "Join Us",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ],
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
