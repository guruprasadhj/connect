import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{

  uploadUserInfo(userMap){
    Firestore.instance.collection("users").add(userMap);
  }
  getUserByCaseSearch(String caseSearch)async{
    //return await Firestore.instance.collection("users").where("caseSearch",isEqualTo: caseSearch ).getDocuments();
    return await Firestore.instance.collection("users").where("caseSearch", arrayContains: caseSearch).getDocuments();
  }
  getUserByUsername(String username)async{
    return await Firestore.instance.collection("users").where("username",isEqualTo: username ).getDocuments();
}

  getUserByUserEmail(String userEmail)async{
    return await Firestore.instance.collection("users").where("email",isEqualTo: userEmail ).getDocuments();
  }
  Future<QuerySnapshot> getRecentUsers() async {
    return await Firestore.instance.collection("users").limit(10).getDocuments();
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

}