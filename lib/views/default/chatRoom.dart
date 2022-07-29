import 'package:connect/helpers/constants.dart';
import 'package:connect/helpers/helperfunction.dart';
import 'package:connect/services/auth.dart';
import 'package:connect/services/database.dart';
import 'package:connect/views/default/converstionScreen.dart';
import 'package:connect/views/default/search.dart';
import 'package:connect/views/intros/Login.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthService authService = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Stream chatRoomStream;

  Widget chatRoomList(){
    return StreamBuilder(
        stream: chatRoomStream,
        builder: (context,snapshot){
          return snapshot.hasData ? ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context,index){
                return ChatRoomTile(
                    snapshot.data.documents[index].data["chatRoomId"].toString().replaceAll("_", "").replaceAll(Constants.myName, ""),
                    snapshot.data.documents[index].data["chatRoomId"]
                );
              }): Container();
        }

    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }
  getUserInfo()async{
    Constants.myName = await HelperFunction.getUserNameInSharedPreference();
    Constants.myPic= await HelperFunction.getUserDpSharedPreference();
    Constants.myMail=await HelperFunction.getUserEmailInSharedPreference();
    databaseMethods.getChatRooms(Constants.myName).then((value){
      setState(() {
        chatRoomStream = value;
      });
    });
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0d0d0d),
      appBar: AppBar(
        title: Text('Chats',style: TextStyle(color: Colors.white,fontSize: 25),),
        elevation: 0.0,
        centerTitle: false,
        actions: [
          GestureDetector(
            onTap: (){
              authService.logOut();
              Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.fade, child: Login()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          ),
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: (){
          Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Search()));
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class ChatRoomTile extends StatelessWidget {
  String userName;
  final String chatRoomId;
  ChatRoomTile(this.userName,this.chatRoomId);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ConversationScreen(chatRoomId:chatRoomId)
        ));
      },
      child: Container(
        color: Colors.white10,
        padding: EdgeInsets.symmetric(horizontal: 24 , vertical: 16),
        child: Row(
          children: [
            Container(
              height:40,
              width: 40,
              alignment: Alignment.center,
              decoration:  BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(40)
              ),
              child: Text("${userName.substring(0,1).toUpperCase()}",style: TextStyle(color: Colors.white,
                  fontSize: 20)),
            ),
            SizedBox(width: 8,),
            Text(userName, style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontFamily: 'OverpassRegular',
                fontWeight: FontWeight.w300))
          ],
        ),
      ),
    );
  }
}
