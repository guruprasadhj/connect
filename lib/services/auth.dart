import 'package:connect/helpers/helperfunction.dart';
import 'package:connect/model/user.dart';
import 'package:connect/views/default/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'database.dart';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseMethods databaseMethods = new DatabaseMethods();

  User _userFromFirebaseUser(FirebaseUser user){
    return user != null ? User(userId: user.uid):null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword
        (email : email , password : password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  Future<FirebaseUser> signInWithGoogle(BuildContext context)async{


    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final  GoogleSignIn _googleSignIn = new GoogleSignIn();
    final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);
    AuthResult result = await _firebaseAuth.signInWithCredential(credential);
    FirebaseUser userDetails = result.user;
    if (result==null){
      print("Error fucks, In SignIn With Google Auth");
    }else{
      Map<String,String> userInfoMap={
        "username": userDetails.email.replaceAll("@gmail.com", "").toLowerCase(),
        "name" :userDetails.displayName/*.replaceAll(" ", "")*/,
        "email":userDetails.email,
        "dp":userDetails.photoUrl,
      };

      databaseMethods.uploadUserInfo(userInfoMap);
      HelperFunction.saveUserLoggedInSharedPreference(true);
      HelperFunction.saveUserNameSharedPreference(userDetails.email.replaceAll("@gmail.com", "").toLowerCase());
      HelperFunction.saveUserDpSharedPreference(userDetails.photoUrl);
      HelperFunction.saveUserEmailSharedPreference(userDetails.email);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage()));
    }
    return userDetails;
  }
  // sign up with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }
  Future resetPass(String email)async{
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }catch(e){
      print(e.toString());
    }
  }
  //logout
  Future logOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }


}

