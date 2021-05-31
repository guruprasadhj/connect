import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import 'conversationScreen.dart';
class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  Stream chatRoomStream;
  Widget chatRoomList(){
    return StreamBuilder(
        stream: chatRoomStream,
        builder: (context,snapshot){
          return snapshot.hasData ? ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context,index){
                return ChatRoomTile(
                    snapshot.data.documents[index].data[""].toString().
                );
              }): Container();
        }

    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
        title: Text('Connect',style: TextStyle(fontFamily: 'pacifico',color: Colors.black),),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                // /Ionicons.settings_sharp,
                Ionicons.settings_outline,
                //Ionicons.settings,
                //Icons.settings,
                color: Colors.black,
              ),
              onPressed: () {
              },
            )]
             ),),
    body: ListView(
      physics: BouncingScrollPhysics(),
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        Container(
          height: 100,
          color: Colors.amber[600],
          child: const Center(child: Text('Entry A')),
        ),
        Container(
          height: 100,
          color: Colors.amber[500],
          child: const Center(child: Text('Entry B')),
        ),
        Container(
          height: 100,
          color: Colors.amber[800],
          child: const Center(child: Text('Entry C')),
        ),
        Container(
          height: 100,
          color: Colors.red[800],
          child: const Center(child: Text('Entry C')),
        ),
        Container(
          height: 100,
          color: Colors.blue[800],
          child: const Center(child: Text('Entry C')),
        ),
        Container(
          height: 100,
          color: Colors.green[800],
          child: const Center(child: Text('Entry C')),
        ),
        Container(
          height: 100,
          color: Colors.grey[800],
          child: const Center(child: Text('Entry C')),
        ),
        Container(
          height: 100,
          color: Colors.black,
          child: const Center(child: Text('Entry C')),
        ),
        Container(
          height: 100,
          color: Colors.pink,
          child: const Center(child: Text('Entry C')),
        ),
        Container(
          height: 100,
          color: Colors.brown,
          child: const Center(child: Text('Entry C')),
        )
      ],
    ),
    );
  }
}
class ChatRoomTile extends StatelessWidget {
  String connectorName;
  final String chatRoomId;
  final String connectorPhotoURL;
  ChatRoomTile(this.connectorName,this.chatRoomId,this.connectorPhotoURL);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> ConversationScreen(chatRoomId: chatRoomId,connectorsName: connectorName ,connectorsPhotoURL: connectorPhotoURL)));
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
              child: Text("${connectorName}",style: TextStyle(color: Colors.white,
                  fontSize: 20)),
            ),
            SizedBox(width: 8,),
            Text(connectorName, style: TextStyle(
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