import 'dart:async';
import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/screens/home.dart';
import 'package:connect/screens/home_screens/home_screen.dart';
import 'package:connect/screens/verify.dart';
import 'package:connect/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/background_animation.dart';
import '../../widgets/widget.dart';
import '../register_screens/register_screen.dart';

class LoginWebScreen extends StatefulWidget {
  const LoginWebScreen({Key? key}) : super(key: key);

  @override
  State<LoginWebScreen> createState() => _LoginWebScreenState();
}

class _LoginWebScreenState extends State<LoginWebScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool isLoading = false;
  bool isEmailValid = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  logIn({required String emailAddress, required String password}) async {
    setState(()=>isLoading=true);
    try {
      // final credential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      ).then((value) {
        if(value.user?.uid!=null){
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomeScreen()));
        }
        print("object : ${value.user?.uid}");
      });

    } on FirebaseAuthException catch (e) {
      print(e.code.toString());
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        showToastMessage(msg: "No user found for that email.");
      }
      else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        showToastMessage(msg: 'Wrong password. Please check the password once.');
      }
      else{
        print(e.toString());
        showToastMessage(msg: 'Something went wrong!');
      }
    }
    setState(()=>isLoading=false);
  }
  showToastMessage({required String msg}){
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.redAccent,
      webBgColor: "linear-gradient(to right, #FF5252FF, #FF5252FF)",
      // timeInSecForIos: 1               // duration
    );
  }

  // async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //
  //   print("logIn");
  //   await authService.SignInWithEmailAndPassword(
  //       _emailController.text, _passwordController.text)
  //       .then((result) {
  //     if (result == "Done") {
  //       Constants.setEmail(_emailController.text);
  //       print("---------------" + result);
  //       //getUserInfo();
  //     } else {
  //       // if (result.code == 'user-not-found') {
  //       setState(() {
  //         isLoading = false;
  //       });
  //       showDialog(
  //           context: context,
  //           builder: (context) {
  //             return AlertDialog(
  //               title: const Text('Email doesn\'t exist'),
  //               content: const Text('Join Us today instead'),
  //               actions: [
  //                 ElevatedButton(
  //                   onPressed: () => Navigator.of(context).push(
  //                       MaterialPageRoute(
  //                           builder: (context) => const Register())),
  //                   child: const Text('OK'),
  //                 ),
  //               ],
  //             );
  //           });
  //       // }
  //       // if (result.code == 'email-doesnt-exist') {
  //       //   // tell use to sign up...
  //       // }
  //       // if (result.code == 'wrong-password') {
  //       //   showDialog(
  //       //     context: context,
  //       //     builder: (context) {
  //       //       return const AlertDialog(
  //       //         title: Text('Wrong Password'),
  //       //         content: Text('Try Again'),
  //       //       );
  //       //     },
  //       //   );
  //       // }
  //     }
  //   });
  // }
  Future<void> emailCheck() async {
    if (_emailController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      Timer(const Duration(seconds: 1), () {
        print("Yeah, this done after 1 seconds");

        setState(() {
          isEmailValid = RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(_emailController.text);
          isLoading = false;
        });
      });

      print(isEmailValid);
    } else {
      // print("It is empty");
      // const snackBar = SnackBar(
      //   content: Text('The Email field is Empty'),
      // );
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Fluttertoast.showToast(
        msg: "The Email field is Empty",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.redAccent,
        webBgColor: "linear-gradient(to right, #FF5252FF, #FF5252FF)",
        // timeInSecForIos: 1               // duration
      );
    }
  }


  void buttonPressed() {
    print("Pressed");
    isEmailValid ? logIn(emailAddress: _emailController.text, password: _passwordController.text) : emailCheck();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff7bd5f5),
      body: Stack(
        children: <Widget>[
          // const bgWidget(),
          BackgroundAnimation(
            glassWidth: 1190,
            glassHeight: 600,
          ),
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
                          // (currentWidth > 600)
                          //     ?
                          Container(
                            height: 50,
                            width: 400,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFffffff).withOpacity(0.4),
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: TextField(
                                onSubmitted: (value) {
                                  buttonPressed();
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
                          ),
                          //     : Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: TextField(
                          //     readOnly: isLoading,
                          //     controller: _emailController,
                          //     textInputAction: TextInputAction.next,
                          //     textAlign: TextAlign.left,
                          //     decoration: InputDecoration(
                          //       hintText: "Email ID",
                          //       border: OutlineInputBorder(
                          //         borderRadius: BorderRadius.circular(30),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          isEmailValid
                              ?
                              // (currentWidth > 600)
                              //     ?
                              Container(
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
                                        buttonPressed();
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
                              //     : Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: TextField(
                              //     readOnly: isLoading,
                              //     controller: _passwordController,
                              //     obscureText: true,
                              //     enableSuggestions: false,
                              //     autocorrect: false,
                              //     textInputAction: TextInputAction.next,
                              //     textAlign: TextAlign.left,
                              //     decoration: InputDecoration(
                              //       hintText: "Password",
                              //       border: OutlineInputBorder(
                              //         borderRadius:
                              //         BorderRadius.circular(30),
                              //       ),
                              //     ),
                              //   ),
                              // )
                              : const SizedBox(),
                          GestureDetector(
                            onTap: ()
                            // {
                            async{
                              print("clicked");
                              QuerySnapshot data = await DatabaseMethods().getUserInfo(_emailController.text);
                              print("data:${data.docs[0].id}");
                              // buttonPressed();
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
                                  child: isLoading
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
                                  ),
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
                                    child: const RegisterScreen()));
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
