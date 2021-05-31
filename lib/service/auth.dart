import 'package:connect/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

import '../constants.dart';
import '../helperFunction.dart';
import '../mainPage.dart';
import '../profile.dart';
import 'database.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Observable<FirebaseUser> user; // firebase user
  Observable<Map<String, dynamic>> profile; // custom user data in Firestore

  setSearchParam(String SearchString) {
    List<String> caseSearchList = List();
    String temp = "";
    for (int i = 0; i < SearchString.length; i++) {
      temp = temp + SearchString[i];
      caseSearchList.add(temp);
    }
    return caseSearchList;
  }
  // constructor
  AuthService() {
    user = Observable(_auth.onAuthStateChanged);

    profile = user.switchMap((FirebaseUser u) {
      if (u != null) {
        return _db
            .collection('users')
            .document(u.uid)
            .snapshots()
            .map((snap) => snap.data);
      } else {
        return Observable.just({});
      }
    });
  }

  Future<FirebaseUser> googleSignIn(context) async {

    try {

      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final AuthResult authResult = await _auth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;
     // FirebaseUser user = await _auth.signInWithCredential(credential);

    HelperFunction.saveUserLoggedInSharedPreference(true);
    HelperFunction.saveUserNameSharedPreference(user.displayName);
    HelperFunction.saveUsersUserNmeNameSharedPreference(user.email.replaceAll("@gmail.com", "").toLowerCase());
    HelperFunction.saveUserPicSharedPreference(user.photoUrl);
    HelperFunction.saveUserEmailSharedPreference(user.email);
    HelperFunction.saveUIDSharedPreference(user.uid);
    Constants.UsersUID  = await HelperFunction.getUIDInSharedPreference();
    Constants.UsersName = await HelperFunction.getUserNameInSharedPreference();
    Constants.UsersUserName = await HelperFunction.getUsersUserNmeNameSharedPreference();
    Constants.UsersPic  = await HelperFunction.getUserDpSharedPreference();
    Constants.UsersMail =await HelperFunction.getUserEmailInSharedPreference();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage()));
      updateUserData(user);
      print("user name: ${user.displayName}");

      return user;
    } catch (e) {
      print (e) ;
      return e  ;
    }
  }

  void updateUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection('users').document(user.uid);
    QuerySnapshot _query = await _db.collection('users').where('uid', isEqualTo: user.uid).getDocuments();
    if (_query.documents.length > 0) {
      return ref.setData({
        'uid'        : user.uid,
        'username'   : user.email.replaceAll("@gmail.com", "").toLowerCase(),
        'email'      : user.email,
        'bannerURL'  : null,
        'displayName': user.displayName,
        "phoneNumber": user.phoneNumber,
        'lastLogin'  : DateTime.now(),
        'status'     : 'n',
        'About'      : 'Hey, Connect Me on Connect',
        "caseSearch": setSearchParam(user.email.replaceAll("@gmail.com", "").toLowerCase()),
      }, merge: true);
    }else{
      return ref.setData({
        'uid'        : user.uid,
        'username'   : user.email.replaceAll("@gmail.com", "").toLowerCase(),
        'email'      : user.email,
        'photoURL'   : user.photoUrl,
        'bannerURL'  : null,
        'displayName': user.displayName,
        "phoneNumber": user.phoneNumber,
        'firstLogin' : DateTime.now(),
        'status'     : 'n',
        'About'      : 'Hey, Connect Me on Connect',
        "caseSearch": setSearchParam(user.email.replaceAll("@gmail.com", "").toLowerCase()),

      }, merge: true);
    }
  }

  Future<String> signOut(context) async {
    try {
      await _googleSignIn.signOut();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
      return 'SignOut';
    } catch (e) {
      return e.toString();
    }
  }
}



