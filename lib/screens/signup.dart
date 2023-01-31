// ignore_for_file: unnecessary_const, unnecessary_new


import 'package:connect/helper/avatar.dart';
import 'package:connect/screens/home.dart';
import 'package:connect/screens/login.dart';
import 'package:connect/services/auth.dart';
import 'package:connect/services/database.dart';
import 'package:connect/widgets/widget.dart';
import 'package:connect/helper/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:page_transition/page_transition.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
    with SingleTickerProviderStateMixin {
  TextEditingController _firstController = TextEditingController();
  TextEditingController _lastController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  //text: Constants.emailId);
  TextEditingController _passwordController = TextEditingController();
  String username = "";

  // String avatarUrl1;
  bool _hasPasswordOneNumber = false;
  bool _isPasswordEightCharacters = false;
  bool _hasSamePassword = false;
  bool isLoading = false;
  bool isRegisted = false;

  onPasswordChanged(String password) {
    final numericRegex = RegExp(r'[0-9]');

    setState(() {
      _isPasswordEightCharacters = false;
      if (password.length >= 8) {
        _isPasswordEightCharacters = true;
      }

      _hasPasswordOneNumber = false;
      if (numericRegex.hasMatch(password)) {
        _hasPasswordOneNumber = true;
      }
    });
  }

  onConfirmPasswordChanged(String confirmPassword) {
    setState(() {
      _hasSamePassword = false;
      if (confirmPassword == _passwordController.text) {
        _hasSamePassword = true;
      }
    });
  }

  AuthService _authService = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Regiter() async {
    setState(() {
      isLoading = true;
    });

    if (_firstController.text.isNotEmpty &&
        _lastController.text.isNotEmpty &&
        _isPasswordEightCharacters &&
        _hasPasswordOneNumber &&
        _hasSamePassword) {
      try {
        await _authService.SignUpWithEmailAndPassword(
                ("${_firstController.text} ${_lastController.text}"),
                _emailController.text,
                _passwordController.text)
            .then((result) {
          if (result != null) {
            username = _emailController.value.text.split("@")[0];
            print(username);
            Map<String, String> userDataMap = {
              "username": username,
              "useremail": _emailController.value.text,
              "firstName": _firstController.text,
              "lastName": _lastController.text,
            };
            databaseMethods.addUserInfo(userDataMap);
            setState(() {
              isLoading = false;
            });
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.fade, child: const HomePage()));
          }
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        print(e);
      }
    }
  }

  List<String> avatarUrls = [];
  String selectedAvatarUrl = "";
  @override
  void initState() {
    super.initState();

    avatarUrls = getAvatarUrls();
    avatarUrls.shuffle();
    selectedAvatarUrl = avatarUrls[0].toString();
  }

  // Widget avatarTile(String avatarUrl, context, int index) {
  //   return GestureDetector(
  //     onTap: () {
  //       selectedAvatarUrl = avatarUrl;
  //       setState(() {});
  //     },
  //     child: Container(
  //       padding: EdgeInsets.all(8),
  //       margin: EdgeInsets.only(
  //         right: 14,
  //         left: 0, //index == 0 ? 30 : 0,
  //       ),
  //       height: 100,
  //       width: 100,
  //       decoration: BoxDecoration(
  //           image: DecorationImage(
  //             image: NetworkImage(avatarUrl),
  //             fit: BoxFit.cover,
  //           ),
  //           border: selectedAvatarUrl == avatarUrl
  //               ? Border.all(color: Color(0xff007EF4), width: 4)
  //               : Border.all(color: Colors.transparent, width: 10),
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(120)),
  //       //child: Image.network(avatarUrl),
  //     ),
  //   );
  // }

  @override
  void dispose() {
    _firstController.dispose();
    _lastController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        const bgWidget(),
        SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GlassmorphicContainer(
                width: 1190,
                height: 600,
                borderRadius: 50,
                blur: 20,
                alignment: Alignment.bottomCenter,
                border: 2,
                linearGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFffffff).withOpacity(0.2),
                      const Color(0xFFFFFFFF).withOpacity(0.2),
                    ],
                    stops: const [
                      0.1,
                      1,
                    ]),
                borderGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFffffff).withOpacity(0.5),
                    const Color((0xFFFFFFFF)).withOpacity(0.5),
                  ],
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          "Hello Newbie!!",
                          style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontSize: 70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 30),
                        child: Text(
                          "Let's Connects🔗 and Rock🤘",
                          textAlign: TextAlign.center,
                          style: TextStyle(),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 50,
                            width: 195,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFffffff).withOpacity(0.4),
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              readOnly: isLoading,
                              controller: _firstController,
                              textInputAction: TextInputAction.next,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "First Name",
                              ),
                              //controller: ,
                            ),
                          ),
                          Container(
                            height: 50,
                            width: 195,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFffffff).withOpacity(0.4),
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: TextField(
                                readOnly: isLoading,
                                controller: _lastController,
                                textInputAction: TextInputAction.next,
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Last Name",
                                ),
                                //controller: ,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 50,
                        width: 400,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFffffff).withOpacity(0.4),
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          readOnly: isLoading,
                          controller: _emailController,
                          textInputAction: TextInputAction.next,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Email",
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 400,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFffffff).withOpacity(0.4),
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            onChanged: (password) =>
                                onPasswordChanged(password),
                            onSubmitted: (value) {},
                            readOnly: isLoading,
                            controller: _passwordController,
                            textInputAction: TextInputAction.next,
                            textAlign: TextAlign.center,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Password",
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedContainer(
                            duration: Duration(milliseconds: 500),
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                                color: _hasPasswordOneNumber
                                    ? Colors.green
                                    : Colors.transparent,
                                border: _hasPasswordOneNumber
                                    ? Border.all(color: Colors.transparent)
                                    : Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(50)),
                            child: const Center(
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text("Contains at least 1 number"),
                          const SizedBox(
                            width: 15,
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                                color: _isPasswordEightCharacters
                                    ? Colors.green
                                    : Colors.transparent,
                                border: _isPasswordEightCharacters
                                    ? Border.all(color: Colors.transparent)
                                    : Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(50)),
                            child: const Center(
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text("Contains at least 8 characters"),
                        ],
                      ),
                      Container(
                        height: 50,
                        width: 400,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFffffff).withOpacity(0.4),
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            onChanged: (confirmPassword) =>
                                onConfirmPasswordChanged(confirmPassword),
                            readOnly: isLoading,
                            textAlign: TextAlign.center,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Confirm Password",
                            ),
                            // controller: _passwordController,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                                color: _hasSamePassword
                                    ? Colors.green
                                    : Colors.transparent,
                                border: _hasSamePassword
                                    ? Border.all(color: Colors.transparent)
                                    : Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(50)),
                            child: const Center(
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text("Password Match"),
                        ],
                      ),
                      AnimatedSwitcher(
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return ScaleTransition(
                              scale: animation, child: child);
                        },
                        duration: const Duration(seconds: 1),
                        child: isLoading
                            ? Container(
                                margin: const EdgeInsets.all(10),
                                constraints: const BoxConstraints(
                                    minWidth: 70, minHeight: 70),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  color: const Color(0xff18293c),
                                  shape: BoxShape.circle,
                                ),
                                child: const SizedBox(
                                  height: 70,
                                  width: 70,
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.grey,
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () => Regiter(),
                                child: Container(
                                  margin: const EdgeInsets.all(10),
                                  height: 70,
                                  width: 250,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(250),
                                    border: Border.all(color: Colors.white),
                                    color: const Color(0xff18293c),
                                    shape: BoxShape.rectangle,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        "Join Now",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    ));
  }
}
