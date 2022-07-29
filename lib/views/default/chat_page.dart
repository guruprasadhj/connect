import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/helpers/constants.dart';
import 'package:connect/services/auth.dart';
import 'package:connect/services/database.dart';
import 'package:connect/views/default/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'converstionScreen.dart';

class ChatPage extends StatefulWidget{
  final ChatUsersList chatUsersList;

  const ChatPage({Key key, this.chatUsersList}) : super(key: key);
  @override
  _ChatPageState createState() => _ChatPageState();


}

class _ChatPageState extends State<ChatPage> {
  bool mode = false;


  AuthService authService = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot getUserSnapshot;
  Stream chatRoomStream;


  // ignore: non_constant_identifier_names
  String getDisplayPictureUrlOfOthers(List<dynamic> DisplayPictureUrl) {
    if (DisplayPictureUrl[0] == Constants.myPic) {
      return DisplayPictureUrl[1];
    } else {
      return DisplayPictureUrl[0];
    }
  }



  Widget chatRoomsList() {

    return StreamBuilder(
      stream: Firestore.instance.collection("ChatRooms").where("users", arrayContains: Constants.myName).snapshots(),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
            padding: EdgeInsets.only(top: 16),
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ChatUsersList(

                userName: snapshot.data.documents[index].data['chatRoomId'].toString().replaceAll("_", "").replaceAll(Constants.myName, ""),
                name:snapshot.data.documents[index].data['chatRoomId'].toString().replaceAll("_", "").replaceAll(Constants.myName, ""),
                chatRoomId: snapshot.data.documents[index].data["chatRoomId"],
                secondaryText: "Hello",//snapshot.data.documents[index].data["lastMessage"],
                image:getDisplayPictureUrlOfOthers( snapshot.data.documents[index].data["DisplayPictureUrl"]),
                time: "Now",
                isMessageRead: true,
              );
            }) : Container();
      },
    );
  }






  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Constants.mode==false?Colors.white:Color(0xFF1B1C1E),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16,right: 16,top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Chats",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color:  Constants.mode==false?Colors.black:Colors.white,),),
                    Container(
                      padding: EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 2),
                      height: 30,
                      child: Switch(value: Constants.mode, onChanged: (val){
                        setState(() {
                          Constants.mode=val;
                          print(val);
                        });
                      }),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Search()));
              },
              child: Padding(
                padding: EdgeInsets.only(top: 16,left: 16,right: 16,bottom: 0),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Constants.mode==false?Colors.grey.shade100:Colors.black12,
                  ),
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 10,),
                      Icon(Icons.search,color: Colors.pink,size: 20,),
                      SizedBox(width: 10,),
                      Text("Search...",style: TextStyle(fontSize: 20,color:Colors.grey.shade400),),
                    ],
                  ),
                ),
              ),
            ),
            chatRoomsList(),
          ],
        ),
      ),
    );
  }
}










class UniqueColorGenerator {
  static Random random = new Random();
  static Color getColor() {
    return Color.fromARGB(255, random.nextInt(255), random.nextInt(255), random.nextInt(255));
  }
}













// ignore: must_be_immutable
class ChatUsersList extends StatefulWidget{

  final String userName;
  final String name;
  final String chatRoomId;
  String secondaryText;
  String image;
  String time;
  bool isMessageRead;
  ChatUsersList({@required this.userName,@required this.name,@required this.chatRoomId,@required this.secondaryText,@required this.image,@required this.time,@required this.isMessageRead});
  @override
  _ChatUsersListState createState() => _ChatUsersListState();
}

class _ChatUsersListState extends State<ChatUsersList> {

  final Color myColor = UniqueColorGenerator.getColor();





  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> ConversationScreen(chatRoomId:widget.chatRoomId.toString() , userName:widget.name.toString(),displayPic:widget.image.toString())));
      },
      child: Container(
        padding: EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 16
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  widget.image != null ?
                  CircleAvatar(
                    maxRadius: 30,
                    backgroundImage:
                    NetworkImage(widget.image),
                    backgroundColor: Colors.transparent,
                  )
                      :
                  Container(
                    height:60,
                    width: 60,
                    alignment: Alignment.center,
                    decoration:  BoxDecoration(
                        color: myColor,
                        borderRadius: BorderRadius.circular(60)
                    ),
                    child: Text("${widget.userName.substring(0,1).toUpperCase()}",style: TextStyle(color: Colors.white,
                        fontSize: 30)),
                  ),
                  SizedBox(width: 16,),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(widget.userName,style: TextStyle(color:  Constants.mode ==false?Colors.black:Colors.white,)),
                          SizedBox(height: 6,),
                          Text(widget.secondaryText,style: TextStyle(fontSize: 14,color: Colors.grey.shade500),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(widget.time,style: TextStyle(fontSize: 12,color: widget.isMessageRead?Colors.pink:Colors.grey.shade500),),
          ],
        ),
      ),
    );
  }
}

