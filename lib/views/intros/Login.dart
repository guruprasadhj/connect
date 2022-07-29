import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/animations/FadeAnimation.dart';
import 'package:connect/helpers/helperfunction.dart';
import 'package:connect/services/auth.dart';
import 'package:connect/services/database.dart';
import 'package:connect/views/default/chatRoom.dart';
import 'package:connect/views/default/main_page.dart';
import 'package:connect/views/intros/register.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}


class _LoginState extends State<Login> {

  final _formKey = GlobalKey<FormState>();
  AuthService _authService = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  bool isLoading= false;
  QuerySnapshot snapshotUserInfo;
  logIn()async{

    if(_formKey.currentState.validate()){
      setState(() {
        isLoading = true;
      });

      HelperFunction.saveUserEmailSharedPreference(emailTextEditingController.text);

      await databaseMethods.getUserByUserEmail(emailTextEditingController.text).then((val){
        snapshotUserInfo=val;
        HelperFunction.saveUserNameSharedPreference(snapshotUserInfo.documents[0].data["userName"]);
      });


      await _authService.signInWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text ).then((val){
        if(val != null){

          HelperFunction.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.fade, child: MainPage()));
        }
      });


    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0d0d0d),
      body: isLoading ? Center(child: Container(child: CircularProgressIndicator(),)): Center(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height+40,
            padding: EdgeInsets.all(30),
            width: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FadeAnimation(1.2,Text("Login",style: TextStyle(color: Colors.white,fontSize: 40,fontWeight:FontWeight.bold),)),
                SizedBox(height: 30,),
                FadeAnimation(1.5,Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Container(decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.grey[300]))
                        ),
                          child: TextFormField(

                            controller: emailTextEditingController,
                            validator: (val){
                              return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                              null : "Enter valid email";
                            },
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.grey.withOpacity(.8)),
                                hintText: "Email"
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(),
                          child: TextFormField(
                            controller: passwordTextEditingController,
                            obscureText: true,
                            //TODO:controller: ,
                            validator:  (val){
                              return val.length < 6 ? "Enter Password 8+ characters" : null;
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey.withOpacity(.8)),
                              hintText: "Password",),
                          ),
                        ),],
                    ),
                  ),
                ),
                ),
                SizedBox(height: 8,),
                FadeAnimation(1.6, Container(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                    child: Text('Forgot Password ?',style: TextStyle(color:Colors.white),),
                  ),
                )),
                SizedBox(height: 8,),
                FadeAnimation(1.8,Center(
                  child:GestureDetector(
                    onTap: (){
                      logIn();
                    },
                    child: Container(
                      width: 120,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Color(0xffd80147)
                      ),


                      child: Center(child: Text("Login",style: TextStyle(color: Colors.white.withOpacity(.7)),),),
                    ),),

                )),
                SizedBox(height: 20,),
                FadeAnimation(1.6,Center(
                  child: Text("_________________________________",style: TextStyle(color: Colors.white,),),
                )),
                SizedBox(height: 40,),

                FadeAnimation(1.6,Center(
                  child:GestureDetector(
                    onTap: ()async{
                      await _authService.signInWithGoogle(context);
                    },
                    child: Container(
                        width: 330,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.white
                        ),
                        child: Center(

                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image(image: AssetImage("assets/images/google_logo.png"), height: 50.0),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text('Login With Google',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                              ),],
                          ),)
                    ),),),

                ),
                SizedBox(height: 16,),
                FadeAnimation(1.6,Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account ?",style: TextStyle(color: Colors.white),),
                    SizedBox(
                      width: 2,
                    ),
                    GestureDetector(
                    onTap: (){
                      Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.fade, child: Register()));
                    },
                        child: Text("Register Now",style: TextStyle(color: Colors.white,decoration: TextDecoration.underline),))
                  ],
                ))

              ],
            ),
          ),
        ),
      ),

    );
  }
}
