
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{

  uploadUserInfo(userMap){
    Firestore.instance.collection("users").add(userMap);
  }

  getUserByUsername(String username)async{
    return await Firestore.instance.collection("users").where("username",isEqualTo: username ).getDocuments();
  }

  getUserByUserEmail(String userEmail)async{
    return await Firestore.instance.collection("users").where("email",isEqualTo: userEmail ).getDocuments();
  }

  createChatRoom(String chatRoomId, chatRoomMap){
    Firestore.instance.collection("ChatRooms").document(chatRoomId).setData(chatRoomMap).catchError((e){
      print(e.toString());
    });
  }

  addConversationMessages(String chatRoomId, messageMap){
    Firestore.instance.collection("ChatRooms")
        .document(chatRoomId)
        .collection("chats")
        .add(messageMap).catchError((e){
          print(e.toString());});
  }
  getConversationMessages(String chatRoomId)async{
    return await Firestore.instance
        .collection("ChatRooms")
        .document(chatRoomId)
        .collection("chats")
        .orderBy("time",descending: false)
        .snapshots();
  }

  getChatRooms(String userName)async{
    return await Firestore.instance.
    collection("ChatRooms")
        .where("users", arrayContains: userName).orderBy("time",descending: true).snapshots();
  }

  getRecentUsers() {}

}