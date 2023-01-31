
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/screens/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseMethods {
  Future<void> addUserInfo(userData) async {
    FirebaseFirestore.instance.collection("users").add(userData).catchError((e)
    {
      print(e.toString());
    });
  }

  updateUserInfo({required String id,required Map<String,dynamic>updateData}){
    FirebaseFirestore.instance
        .collection("users").doc(id).update(updateData).catchError((e){
          print(e.toString());
    });
  }

  getUserInfo(String email) {
    return FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
  }

  searchByName(String searchField) {
    return FirebaseFirestore.instance
        .collection("users")
        .where('username', isEqualTo: searchField)
        .get();
  }
}
