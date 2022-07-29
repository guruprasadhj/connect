import 'package:connect/helpers/constants.dart';
import 'package:connect/services/database.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
class ConversationScreen extends StatefulWidget {

  final String userName, chatRoomId,displayPic;
  ConversationScreen({this.chatRoomId,  this.userName, this.displayPic});

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

  Stream chatMessageStream;
  TextEditingController messageController = new TextEditingController();
  ScrollController _controller;







  Widget chatMessageList(){
    return
     Padding(
       padding: EdgeInsets.only(bottom: 80),
       child: StreamBuilder(
          stream: chatMessageStream,
          builder: (context,snapshot){
            return snapshot.hasData? ListView.builder(reverse: false,
                itemCount:snapshot.data.documents.length,
                itemBuilder: (context,index,){
                  return MessageTile(snapshot.data.documents[index].data["message"],
                      snapshot.data.documents[index].data["sentBy"] ==Constants.myName
                  );
                }):Container();
          },
        ),
     );
  }


  moveDown() {
    _controller.animateTo(_controller.offset ,
        curve: Curves.linear, duration: Duration(milliseconds: 500));
  }

  sendMessage(){
    if(messageController.text.isNotEmpty){
      Map<String,dynamic> messageMap ={
        "message":messageController.text,
        "sentBy": Constants.myName,
        "time":DateTime.now().millisecondsSinceEpoch,
      };
      DatabaseMethods().addConversationMessages(widget.chatRoomId,messageMap);
      setState(() {
        messageController.text ="";
      });
    }
  }

  @override
  void initState() {
    _controller = ScrollController();
    DatabaseMethods().getConversationMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(0xff0d0d0d),
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back,color: Colors.black,),
                ),
                SizedBox(width: 2,),
                CircleAvatar(
                  backgroundImage:
                  NetworkImage(widget.displayPic),
                  maxRadius: 20,
                ),
                SizedBox(width: 12,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(widget.userName,style: TextStyle(fontWeight: FontWeight.w600),),
                      SizedBox(height: 6,),
                      Text("Online",style: TextStyle(color: Colors.green,fontSize: 12),),
                    ],
                  ),
                ),
                Icon(Icons.more_vert,color: Colors.grey.shade700,),
              ],
            ),
          ),
        ),
      ),
        body:
        
        
        Stack(
          children: <Widget>[
            chatMessageList(),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 16,bottom: 10),
              height: 80,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(Icons.add,color: Colors.white,size: 21,),
                    ),
                  ),
                  SizedBox(width: 16,),
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                          hintText: "Type message...",
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          border: InputBorder.none
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: EdgeInsets.only(right: 30,bottom: 20),
                child: FloatingActionButton(
                  onPressed: (){
                    sendMessage();
                  },
                  child: Icon(Icons.send,color: Colors.white,),
                  backgroundColor: Color(0xffd80147),
                  elevation: 0,
                ),

            ),),
        ]
        ),

//      body: Stack(
//        children: [
//          chatMessageList(),
//          SizedBox(height: 10,),
//          Container(
//            alignment: Alignment.bottomCenter,
//            child: Container(
//              color: Color(0x54ffffff),
//              padding: EdgeInsets.symmetric(horizontal: 14,vertical: 16),
//              child: Row(
//                children: [
//                  Expanded(child: TextField(
//                    controller: messageController,
//                    style:TextStyle(color: Colors.white),
//                    decoration: InputDecoration(
//                      hintText: "message",
//                      hintStyle: TextStyle(color: Colors.white54),
//                    ),
//                  )),
//                  GestureDetector(
//                    onTap: (){
//                      sendMessage();
//                    },
//                    child: Container(
//                        height: 40,
//                        width: 40,
//                        decoration: BoxDecoration(
//                            gradient: LinearGradient(
//                                colors:[
//                                  const Color(0x36ffffff),
//                                  const Color(0x0ffffff)
//                                ]
//                            ),
//                            borderRadius: BorderRadius.circular(40)
//                        ),
//                        child: Icon(Icons.send,color: Colors.white,)),
//                  )
//                ],
//              ),
//            ),
//          ),
//        ],
//      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile(this.message,this.isSendByMe);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left : isSendByMe ? 70:13,  right: isSendByMe ? 13 : 70),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight:Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24,  vertical: 16),
        decoration:  BoxDecoration(
            gradient: LinearGradient(
                colors: isSendByMe ?[
                  const Color(0xffffcad4),
                  const Color(0xffffcad4)
                ] : [
                  const Color(0xffe6e0da),
                  const Color(0xffe6e0da)
                ]
            ),
            borderRadius: isSendByMe ? BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
            ):
            BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomRight: Radius.circular(23)
            )
        ),
        child: Column(
          children: [
            ExpandableText(
              message,
              expandText: 'show more',
              collapseText: 'show less',
              maxLines: 3,
                linkColor: Colors.blue,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w400)
            ),
            /*Text(message,textAlign: TextAlign.start,maxLines:5 ,overflow: TextOverflow.visible,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300)),*/
          ],
        ),
      ),
    );
  }
}
//class ConversationAppBar extends StatelessWidget {
//
//  @override
//  Widget build(BuildContext context) {
//    return AppBar(
//      elevation: 0,
//      automaticallyImplyLeading: false,
//      backgroundColor: Colors.white,
//      flexibleSpace: SafeArea(
//        child: Container(
//          padding: EdgeInsets.only(right: 16),
//          child: Row(
//            children: <Widget>[
//              IconButton(
//                onPressed: (){
//                  Navigator.pop(context);
//                },
//                icon: Icon(Icons.arrow_back,color: Colors.black,),
//              ),
//              SizedBox(width: 2,),
//              CircleAvatar(
//                backgroundImage:
//                NetworkImage(widget.displayPic),
//                maxRadius: 20,
//              ),
//              SizedBox(width: 12,),
//              Expanded(
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    Text(widget.username,style: TextStyle(fontWeight: FontWeight.w600),),
//                    SizedBox(height: 6,),
//                    Text("Online",style: TextStyle(color: Colors.green,fontSize: 12),),
//                  ],
//                ),
//              ),
//              Icon(Icons.more_vert,color: Colors.grey.shade700,),
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//}
