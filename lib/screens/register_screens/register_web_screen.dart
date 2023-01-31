import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/screens/home_screens/home_screen.dart';
import 'package:connect/screens/home_screens/home_web_screen.dart';
import 'package:connect/screens/login_screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../helper/avatar.dart';
import '../../services/auth.dart';
import '../../services/database.dart';
import '../../widgets/background_animation.dart';

class RegisterWebScreen extends StatefulWidget {
  const RegisterWebScreen({Key? key}) : super(key: key);

  @override
  State<RegisterWebScreen> createState() => _RegisterWebScreenState();
}

class _RegisterWebScreenState extends State<RegisterWebScreen> {
  bool isRegistered = false;
  bool isLoading = false;
  bool _isPasswordEightCharacters = false;
  bool _hasPasswordOneNumber = false;
  bool _hasSamePassword = false;
  List<String> avatarUrls = [];
  String selectedAvatarUrl = "";
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  AuthService _authService = AuthService();
  DatabaseMethods databaseMethods = DatabaseMethods();
  final _formKey = GlobalKey<FormState>();

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

  register(
      {required String firstName,
      required String lastName,
      required String email,
      required String password}) async {
    setState(() {
      isLoading = true;
    });
    String username = email.split("@")[0];
    print(username);
    try {
      await _authService.SignUpWithEmailAndPassword(username, email, password)
          .then((result) {
        if (result != null) {
          print(result);

          Map<String, String> userDataMap = {
            "username": username,
            "email": email,
            "firstName": firstName,
            "lastName": lastName,
          };
          databaseMethods.addUserInfo(userDataMap);
          setState(() {
            isLoading = false;
            isRegistered = true;
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
  }
  addAvatar({required String profilePic})async{
    QuerySnapshot data = await databaseMethods.getUserInfo(_emailController.value.text);
    String id =data.docs[0].id;
    print("data:$id");
    Map<String,dynamic> updateData={"profilePic":profilePic};
    await databaseMethods.updateUserInfo(id: id, updateData: updateData);
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.fade,
            child: const HomeScreen()));
  }
  @override
  void initState() {
    avatarUrls = getAvatarUrls();
    avatarUrls.shuffle();
    selectedAvatarUrl = avatarUrls[0].toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundAnimation(
            glassWidth: 1190,
            glassHeight: 600,
          ),
          isRegistered
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
                          addAvatar(profilePic: selectedAvatarUrl);

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
                ))
              : SafeArea(
                  child: Center(
                    child: Form(
                      key: _formKey,
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
                                  color:
                                      const Color(0xFFffffff).withOpacity(0.4),
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: TextField(
                                  readOnly: isLoading,
                                  controller: _firstNameController,
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
                                  color:
                                      const Color(0xFFffffff).withOpacity(0.4),
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: TextField(
                                    readOnly: isLoading,
                                    controller: _lastNameController,
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
                                    onTap: () {
                                      if (_formKey.currentState!.validate()) {
                                        register(
                                            firstName:
                                                _firstNameController.text,
                                            lastName: _lastNameController.text,
                                            email: _emailController.text,
                                            password: _passwordController.text);
                                      }
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(10),
                                      height: 70,
                                      width: 250,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(250),
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
                              const Text("have an account? "),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Login",
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
                ),
        ],
      ),
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
}
