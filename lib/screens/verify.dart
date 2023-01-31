// ignore_for_file: unnecessary_const

import 'dart:async';

import 'package:connect/helper/constants.dart';
import 'package:connect/screens/register.dart';
import 'package:connect/screens/login.dart';
import 'package:connect/widgets/widget.dart';
import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:page_transition/page_transition.dart';

class VerifyPage extends StatefulWidget {
  const VerifyPage({Key? key}) : super(key: key);

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage>
    with SingleTickerProviderStateMixin {
  bool validEmail = false;
  bool isLoading = false;
  bool isSubmitted = false;
  bool isVerified = false;
  String _emailId = '';
  String _otpValue = '';

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);

  late Animation<double> scaleAnimation =
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut);

  late Animation<double> checkAnimation =
      CurvedAnimation(parent: _controller, curve: Curves.linear);

  final TextEditingController _emailController = TextEditingController();

  late EmailAuth emailAuth;
  @override
  void initState() {
    emailAuth = EmailAuth(
      sessionName: "Connect",
    );

    super.initState();
  }

  void sendOtp() async {
    bool result = await emailAuth.sendOtp(
        recipientMail: _emailController.value.text, otpLength: 4);
    if (result) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('OTP sent to ${_emailController.text}'),
      ));
      setState(() {
        isSubmitted = true;
      });
    } else {
      const snackBar = SnackBar(
        content: Text('Error occurs while sending. Please check the Email ID'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void verifyOTP() async {
    setState() => isVerified = (emailAuth.validateOtp(
        recipientMail: _emailController.value.text, userOtp: _otpValue));

    await Future.delayed(
        const Duration(seconds: 2), () => print("1 second later."));

    // ignore: use_build_context_synchronously
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Register()));
  }

  Future<void> emailCheck() async {
    if (_emailController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      Timer(const Duration(seconds: 1), () {
        print("Yeah, this done after 1 seconds");

        setState(() {
          validEmail = RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(_emailController.text.trim());
          if (validEmail) {
            Constants.emailId = _emailController.text;
            _emailId = _emailController.text.trim();
          }
          isLoading = false;
        });
      });

      print(validEmail);
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

  Widget _otpTextField(bool isNext) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 68,
      width: 64,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white),
          color: Colors.white.withOpacity(0.3),
          shape: BoxShape.rectangle),
      child: TextField(
        onChanged: (value) {
          if (value.length == 1) {
            _otpValue = _otpValue + value.toString();
            if (isNext) {
              FocusScope.of(context).nextFocus();
            } else {
              print(_otpValue);
              verifyOTP();
            }
          }
        },
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "X",
          hintStyle: TextStyle(fontSize: 40.0, color: Colors.black12),
        ),
        style: Theme.of(context).textTheme.headlineLarge,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    child: isVerified
                        ? Stack(
                            children: [
                              Center(
                                child: ScaleTransition(
                                  scale: scaleAnimation,
                                  child: Container(
                                    height:
                                        MediaQuery.of(context).size.height / 7,
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                              SizeTransition(
                                sizeFactor: checkAnimation,
                                axis: Axis.horizontal,
                                axisAlignment: -1,
                                child: Center(
                                  child: Icon(Icons.check,
                                      color: Colors.white,
                                      size: MediaQuery.of(context).size.height /
                                          10),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Hello Newbie!!",
                                style: TextStyle(
                                  fontFamily: 'Ubuntu',
                                  fontSize: 70,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(bottom: 30),
                                child: Text(
                                  "Verify your email first😉",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(),
                                ),
                              ),
                              !isSubmitted
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
                                          onSubmitted: ((value) {
                                            emailCheck();
                                          }),
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Email",
                                          ),
                                          controller: _emailController,
                                        ),
                                      ),
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 30),
                                          child: Text(
                                            "OTP has been Sent to ${_emailController.text}",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(),
                                          ),
                                        ),
                                        Form(
                                            child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            _otpTextField(true),
                                            _otpTextField(true),
                                            _otpTextField(true),
                                            _otpTextField(true),
                                            _otpTextField(true),
                                            _otpTextField(false),
                                          ],
                                        )),
                                      ],
                                    ),
                              !isSubmitted
                                  ? GestureDetector(
                                      onTap: () => sendOtp(),
                                      child: Container(
                                        margin: const EdgeInsets.all(10),
                                        height: 70,
                                        width: 250,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(250),
                                          border:
                                              Border.all(color: Colors.white),
                                          color: const Color(0xff18293c),
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Text(
                                              "Get OTP",
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
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        verifyOTP();
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.all(10),
                                        height: 70,
                                        width: 250,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(250),
                                          border:
                                              Border.all(color: Colors.white),
                                          color: const Color(0xff18293c),
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Text(
                                              "Verify",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 30),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
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
                      const Text("Have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.fade,
                                  child: const LoginPage()));
                        },
                        child: const Text(
                          "LogIn",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ],
              )),
            ],
          ),
        )
      ],
    ));
  }
}
