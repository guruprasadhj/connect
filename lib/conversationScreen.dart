import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/helperFunction.dart';
import 'package:connect/service/database.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:intl/intl.dart';


import 'constants.dart';

class ConversationScreen extends StatefulWidget {
  final String connectorsName, chatRoomId,connectorsPhotoURL;
  ConversationScreen({this.chatRoomId,  this.connectorsName, this.connectorsPhotoURL});
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

  Stream chatMessageStream;
  TextEditingController messageController = new TextEditingController();
  bool hideCam = false;
  ScrollController _controller;
  checkMessageDate(){
    if ( messageController.text.isNotEmpty){
      setState(() {
        hideCam = true;
      });

      print('yes');
    }
    else{
      print('no');
      setState(() {
        hideCam = false;
      });

    }
  }
  Widget chatMessageList(){
    return
      Padding(
        padding: EdgeInsets.only(bottom: 80),
        child: StreamBuilder(
          stream: chatMessageStream,
          builder: (context,snapshot){
            return snapshot.hasData? ListView.builder(
                controller: _controller,
                reverse: false,
                itemCount:snapshot.data.documents.length,
                itemBuilder: (context,index,){
                  return MessageTile(
                    message: snapshot.data.documents[index].data["message"],
                    isSendByMe:snapshot.data.documents[index].data["sentBy"],
                      isSendAt: snapshot.data.documents[index].data["time"],
                      itemCount:snapshot.data.documents.length,
                  );
                }):Container();
          },
        ),
      );
  }

  sendMessage(){
    print(DateTime.now().toString());
    if(messageController.text.isNotEmpty){
      Map<String,dynamic> messageMap ={
        "message":messageController.text,
        "sentBy": Constants.UsersUID,
        "time":DateTime.now(),
      };
      DatabaseMethods().addConversationMessages(widget.chatRoomId,messageMap);
      setState(() {
        messageController.text ="";
      });
      Timer(Duration(milliseconds: 500),
              () => _controller.jumpTo(_controller.position.maxScrollExtent));
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    _controller = ScrollController();
    DatabaseMethods().getConversationMessages(widget.chatRoomId).then((result) {
      chatMessageStream = result;
      setState(() {});
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,

      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios,color: Colors.black, size: 20,),onPressed: (){},),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.connectorsName,
                  //'Guru ',
                  style: TextStyle(fontFamily: 'Open_Sans',color: Colors.black,fontSize: 20),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Online',
                      style: TextStyle(fontFamily: 'Open_Sans',color: Colors.grey,fontSize: 15),),
                    SizedBox(width: 10,),
                    Icon(Icons.circle,size: 10,color: Colors.green,)
                  ],
                )

              ],
            ),
            SizedBox(width: 20,),
            CircleAvatar(
              backgroundImage:NetworkImage(widget.connectorsPhotoURL),
              //AssetImage('assets/images/dp.jpg'),
            ),
          ],
        ),
      ),
      body:Container(
    decoration: BoxDecoration(
    image: DecorationImage(
    colorFilter: new ColorFilter.mode(Colors.blue.shade100.withOpacity(0.5), BlendMode.dstATop),
    image: AssetImage("assets/images/background.png"), fit: BoxFit.cover),
    ),
        child: Stack(
          children: [
            chatMessageList(),
            Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ConstrainedBox(
                    constraints: new BoxConstraints(
                      //minWidth: size.width,
                      //maxWidth: size.width,
                      minHeight: 25.0,
                      maxHeight: 125.0,
                    ),
                    child: Container(
                      padding: EdgeInsets.only(left: 16,bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      ),
                      width: double.infinity,
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.s,
                      //crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: (){
                            print('emoji');
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                            child: Icon(Icons.insert_emoticon,
                                size:30.0, color:Colors.grey ),
                          ),
                        ),
                       // SizedBox(width: 0),
                        Flexible(
                          child: new ConstrainedBox(
                            constraints: new BoxConstraints(
                              //minWidth: size.width,
                              //maxWidth: size.width,
                              minHeight: 25.0,
                              maxHeight: 135.0,
                            ),
                            child: new Scrollbar(
                              radius: Radius.circular(50) ,
                              child: new TextField(
                                onChanged: (String message){checkMessageDate();},
                                cursorColor: Colors.blue.shade800,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                controller: messageController,
                                //_handleSubmitted : null,
                                style: TextStyle(
                                    height: 1.5,
                                    fontSize: 20),
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                  //disabledBorder:
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(
                                      top: 2.0,
                                      left: 13.0,
                                      right: 13.0,
                                      bottom: 2.0),

                                  hintText: "Type your message",
                                  hintStyle: TextStyle(
                                    fontSize: 15,
                                    color:Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            print('paper clip');
                          },
                          child: Container(
                              alignment: Alignment.center,
                              color: Colors.white,
                              height: 25,
                              width: 30,
                              child: Icon(Ionicons.attach,color: Colors.grey,size: 35,)),
                        ),
                       hideCam ?SizedBox(width: 10,):GestureDetector(
                         onTap: (){
                           print('camera');
                         },
                         child: Container(
                             alignment: Alignment.center,
                             color: Colors.white,
                             height: 25,
                             width: 50,
                             child: Icon(Ionicons.camera,color: Colors.grey,size: 30,)),
                       ),



                        GestureDetector(
                          onTap: (){
                            print('send ');
                            sendMessage();
                          },
                          child: Container(//color: Colors.blue.shade50,
                            //height: 50,
                            padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
                            child: CircleAvatar(
                              backgroundColor: Colors.blueAccent,
                              radius: 28,
                              //child:Icon(Ionicons.paper_plane)
                              backgroundImage: AssetImage('assets/images/rocket.png'),//AssetImage('assets/images/rocket.png',),
                              // child: Image.asset('assets/images/rocket.png'),
                                //child: SvgPicture.asset("assets/images/yourImage.svg")\
                            ),
                          ),
                        ),

                      ],),
                    ),
                  ),
                  SizedBox(height: 7,)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final String isSendByMe;
  final int  itemCount;
 final Timestamp isSendAt;



  MessageTile({@required this.message, @required this.isSendByMe, @required this.itemCount,@required this.isSendAt});

  @override
  Widget build(BuildContext context) {
    final bool sendByMe = (isSendByMe==Constants.UsersUID? true:false);
    final DateFormat formatter = DateFormat('jm');//yyyy-MM-dd');
    final String formatted = formatter.format(isSendAt.toDate());
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(
              top: 8,
              bottom: 2,
              left: sendByMe ? 70 : 20,
              right: sendByMe ? 20 : 70),
          alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: sendByMe
                ? EdgeInsets.only(left: 25,)
                : EdgeInsets.only(right: 25),
            padding: EdgeInsets.only(
                top: 17, bottom: 17, left: 20, right: 20),
            decoration: BoxDecoration(
                borderRadius: sendByMe ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23)
                ) :
                BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23)),
                gradient: LinearGradient(
                  colors: sendByMe ? [
                    const Color(0xffffffff),
                    const Color(0xffffffff)
                  ]
                      : [
                    const Color(0xff489def),
                    const Color(0xff489def)
                  ],
                )
            ),
            child: ExpandableText('${message}',
                expandText: 'show more',
                collapseText: ' ',
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: sendByMe ? Colors.black :Colors.white,
                    fontSize: 16,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300)),
          ),
        ),
        Container(
          alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
          //alignment: sendByMe ?Alignment.bottomRight:Alignment.bottomLeft,
          margin: sendByMe
              ? EdgeInsets.only(left: 30)
              : EdgeInsets.only(right: 30),
          padding: EdgeInsets.only(
              top: 8,
              bottom: 8,
              left: sendByMe ? 0 : 24,
              right: sendByMe ? 24 : 0),
          child: Text('${formatted}',
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                  fontFamily: 'OverpassRegular',
                  fontWeight: FontWeight.w300)),
        )
      ],
    );
  }
}