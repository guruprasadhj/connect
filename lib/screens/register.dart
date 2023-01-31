import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect/helper/avatar.dart';
import 'package:connect/screens/home.dart';
import 'package:connect/screens/verify.dart';
import 'package:connect/services/auth.dart';
import 'package:connect/services/database.dart';
import 'package:connect/widgets/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String username = "";
  String selectedAvatarUrl = "";

  List<String> avatarUrls = [];

  bool isLoading = false;
  bool isRegisted = false;
  bool _hasPasswordOneNumber = false;
  bool _isPasswordEightCharacters = false;
  bool _hasSamePassword = false;

  TextEditingController _firstController = TextEditingController();
  TextEditingController _lastController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  AuthService _authService = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();

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

  RegisterAvatar() async {}

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
            print(result);
            username = _emailController.value.text.split("@")[0];
            print(username);
            Map<String, String> userDataMap = {
              "username": username,
              "email": _emailController.value.text,
              "firstName": _firstController.text,
              "lastName": _lastController.text,
            };
            databaseMethods.addUserInfo(userDataMap);
            setState(() {
              isLoading = false;
              isRegisted = true;
            });
            // Navigator.push(
            //     context,
            //     PageTransition(
            //         type: PageTransitionType.fade, child: const HomePage()));
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
    } else {
      setState(() {
        isLoading = false;
      });
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

  Widget avatarTile(String avatarUrl, context, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAvatarUrl = avatarUrl;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: EdgeInsets.only(
          right: 14,
          left: index == 0 ? 30 : 0,
        ),
        height: 100,
        width: 100,
        decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                avatarUrl,
              ),
              fit: BoxFit.fill,
            ),
            border: selectedAvatarUrl == avatarUrl
                ? Border.all(color: Color(0xff007EF4), width: 4)
                : Border.all(color: Colors.transparent, width: 10),
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(120)),
      ),
    );
  }

  @override
  void initState() {
    avatarUrls = getAvatarUrls();
    avatarUrls.shuffle();
    selectedAvatarUrl = avatarUrls[0].toString();
    super.initState();
  }

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
    final currentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          bgWidget(),
          isRegisted
              ? SafeArea(
                  child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 100,
                        margin: const EdgeInsets.only(bottom: 40),
                        child: ListView.builder(
                            itemCount: avatarUrls.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return avatarTile(avatarUrls[index], this, index);
                            }),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.fade,
                                  child: const HomePage()));
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
                ))
              : SafeArea(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Hello Newbie!!",
                            style: TextStyle(
                              fontFamily: 'Ubuntu',
                              fontSize: 70,
                            ),
                            textAlign: TextAlign.left,
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
                        currentWidth < 600
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      readOnly: isLoading,
                                      controller: _firstController,
                                      textInputAction: TextInputAction.next,
                                      textAlign: currentWidth < 600
                                          ? TextAlign.left
                                          : TextAlign.center,
                                      decoration: InputDecoration(
                                        hintText: "First Name",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      readOnly: isLoading,
                                      controller: _lastController,
                                      textInputAction: TextInputAction.next,
                                      textAlign: TextAlign.left,
                                      decoration: InputDecoration(
                                        hintText: "Last Name",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      readOnly: isLoading,
                                      controller: _emailController,
                                      textInputAction: TextInputAction.next,
                                      textAlign: TextAlign.left,
                                      decoration: InputDecoration(
                                        hintText: "Email ID",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      onChanged: (password) =>
                                          onPasswordChanged(password),
                                      obscureText: true,
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      readOnly: isLoading,
                                      controller: _passwordController,
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
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      onChanged: (confirmPassword) =>
                                          onConfirmPasswordChanged(
                                              confirmPassword),
                                      obscureText: true,
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      readOnly: isLoading,
                                      controller: _passwordController,
                                      textInputAction: TextInputAction.next,
                                      textAlign: TextAlign.left,
                                      decoration: InputDecoration(
                                        hintText: "Confirm Password",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, bottom: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                              color: _hasPasswordOneNumber
                                                  ? Colors.green
                                                  : Colors.transparent,
                                              border: _hasPasswordOneNumber
                                                  ? Border.all(
                                                      color: Colors.transparent)
                                                  : Border.all(
                                                      color:
                                                          Colors.grey.shade400),
                                              borderRadius:
                                                  BorderRadius.circular(50)),
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
                                        const Text(
                                            "Contains at least 1 number"),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, bottom: 8.0),
                                    child: Row(
                                      children: [
                                        AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                              color: _isPasswordEightCharacters
                                                  ? Colors.green
                                                  : Colors.transparent,
                                              border: _isPasswordEightCharacters
                                                  ? Border.all(
                                                      color: Colors.transparent)
                                                  : Border.all(
                                                      color:
                                                          Colors.grey.shade400),
                                              borderRadius:
                                                  BorderRadius.circular(50)),
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
                                        const Text(
                                            "Contains at least 8 characters"),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, bottom: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                              color: _hasSamePassword
                                                  ? Colors.green
                                                  : Colors.transparent,
                                              border: _hasSamePassword
                                                  ? Border.all(
                                                      color: Colors.transparent)
                                                  : Border.all(
                                                      color:
                                                          Colors.grey.shade400),
                                              borderRadius:
                                                  BorderRadius.circular(50)),
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
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 50,
                                    width: 195,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFffffff)
                                          .withOpacity(0.4),
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
                                      color: const Color(0xFFffffff)
                                          .withOpacity(0.4),
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: TextField(
                                        readOnly: isLoading,
                                        controller: _lastController,
                                        textInputAction: TextInputAction.next,
                                        textAlign: TextAlign.center,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Last Name",
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        if (currentWidth > 600)
                          Column(
                            children: [
                              Container(
                                height: 50,
                                width: 400,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFFffffff).withOpacity(0.4),
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
                                  color:
                                      const Color(0xFFffffff).withOpacity(0.4),
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
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
                                            ? Border.all(
                                                color: Colors.transparent)
                                            : Border.all(
                                                color: Colors.grey.shade400),
                                        borderRadius:
                                            BorderRadius.circular(50)),
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
                                            ? Border.all(
                                                color: Colors.transparent)
                                            : Border.all(
                                                color: Colors.grey.shade400),
                                        borderRadius:
                                            BorderRadius.circular(50)),
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
                                  color:
                                      const Color(0xFFffffff).withOpacity(0.4),
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: TextField(
                                    onChanged: (confirmPassword) =>
                                        onConfirmPasswordChanged(
                                            confirmPassword),
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
                                            ? Border.all(
                                                color: Colors.transparent)
                                            : Border.all(
                                                color: Colors.grey.shade400),
                                        borderRadius:
                                            BorderRadius.circular(50)),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          "Join Now",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
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
                        //const SizedBox(height: 550),
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
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
