import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/service/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import 'constants.dart';
import 'conversationScreen.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController =
      new TextEditingController();
  QuerySnapshot searchSnapshot;
  bool isLoading = false;

  initiateSearch() async {
    if (searchTextEditingController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await databaseMethods
          .getUserByCaseSearch(searchTextEditingController.text)
          .then((val) {
        searchSnapshot = val;
        setState(() {
          isLoading = false;
        });
      });
    }
  }
  _buildUserTile({String connectorsUID, String connectorsUsername, String connectorName, connectorPhotoURL}) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          radius: 30.0,
          backgroundImage: connectorPhotoURL.isEmpty
              ? AssetImage('assets/images/user_placeholder.jpg')
              : CachedNetworkImageProvider(connectorPhotoURL),
        ),
        title: Text(connectorName),
        subtitle: Text('@ ${connectorsUsername}'),
          trailing: GestureDetector(
              onTap: (){createChatRoomAndChat(UID: connectorsUID, connectorName :connectorName , connectorPhotoURL: connectorPhotoURL,);},
              child: Icon(Ionicons.person_add,size: 30,)),
        onTap: () {}
      ),
    );
  }

  Widget searchList() {
    return isLoading
        ? Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Container(
            child: searchSnapshot != null
                ? ListView.builder(
                    itemCount: searchSnapshot.documents.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return _buildUserTile(
                          // ignore: deprecated_member_use
                          connectorsUID:
                              searchSnapshot.documents[index].data["uid"],
                          connectorsUsername:
                              searchSnapshot.documents[index].data["username"],
                          connectorName:
                              searchSnapshot.documents[index].data["displayName"],
                          connectorPhotoURL:
                              searchSnapshot.documents[index].data["photoURL"]);
                    })
                : Container());
  }

  // ignore: non_constant_identifier_names
  createChatRoomAndChat({String UID, String connectorName, String connectorPhotoURL}) {
    if (connectorName != Constants.UsersName) {
      String chatRoomId = getChatRoomId(UID, Constants.UsersUID);
      List<String> connectors = [connectorName, Constants.UsersName];
      List<String> avatarUrls = [connectorPhotoURL, Constants.UsersPic];
      List<int> unreadMessages = [0, 1];
      Map<String, dynamic> chatRoomMap = {
        "users": connectors,
        "DisplayPictureUrl": avatarUrls,
        "lastMessage": "message",
        "lastMessageSendBy": Constants.UsersName,
        'timestamp': Timestamp.now(),
        "unreadMessage": unreadMessages,
        "chatRoomId": chatRoomId,
        "protectMode": "pass",
      };

      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      print('Every thing is finished');
      Navigator.push(context, MaterialPageRoute(builder: (context)=> ConversationScreen(chatRoomId: chatRoomId,connectorsName: connectorName ,connectorsPhotoURL: connectorPhotoURL)));
      //Navigator.push(context, MaterialPageRoute(builder: (context)=> ConversationScreen(chatRoomId:widget.chatRoomId.toString() , userName:widget.name.toString(),displayPic:widget.image.toString())));
      //Navigator.push(context, MaterialPageRoute(builder: (context)=> ConversationScreen(chatRoomId:chatRoomId , userName:userName,displayPic: userDp ,)));
    } else {
      print("you cannot send message to yourself idiot");
    }
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  Widget searchTile(
      {String connectorsUID, String connectorsUsername, String connectorName, connectorPhotoURL}) {
    return Container(
        //padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
       // color: Colors.grey.shade200,
        child: Container(
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10,0 ) ,//.symmetric(horizontal: 10, vertical: 10),
            //padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(75.0)),
                    image: DecorationImage(
                        image: NetworkImage(connectorPhotoURL), fit: BoxFit.cover),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        '${connectorName}',
                        style: TextStyle(fontSize: 18, /*fontWeight: FontWeight.bold*/),
                      ), // ${userDp}'),
                    ),
                    Container(
                      child: Text(
                        '${connectorsUsername}',
                        style: TextStyle(fontSize: 15,color: Colors.grey),
                      ), // ${userDp}'),
                    ),
                    SizedBox(
                      width: 20,
                    ),

                  ],
                ),
                Spacer(),
                GestureDetector(
                  onTap: (){
                    createChatRoomAndChat(UID: connectorsUID, connectorName :connectorName , connectorPhotoURL: connectorPhotoURL,);// connectorsUID,connectorName,connectorPhotoURL);
                  },
                  child: Container(
                    width: 120,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Connect  ',style: TextStyle(fontFamily: 'Source Sans Pro', fontSize: 15,color: Colors.white,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),
                        SizedBox(width: 10,),
                        Icon(Ionicons.chatbubbles,color: Colors.white,),

                      ],
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.horizontal(left: Radius.circular(75.0),right: Radius.circular(75.0)),
                          //RadiusT .circular(75.0)),
                      gradient: LinearGradient(
                          colors:  [
                            const Color(0xff2ec5f0),
                            //const Color(0xff518cf4),
                            //const Color(0xff2ec5f0),
                            const Color(0xff518cf4)
                          ]
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff2f6fa),
        title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Image.asset(
            'assets/images/search.png',
            fit: BoxFit.fitWidth,
            height: 32,
          ),
        ]),
      ),
      body: Container(
        decoration: BoxDecoration(

          image: DecorationImage(
              colorFilter: new ColorFilter.mode(Colors.blue.shade100.withOpacity(0.1), BlendMode.dstATop),
              image: AssetImage("assets/images/background.png"), fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            // SizedBox(
            //   height: 10,
            // ),
            TextField(
              controller: searchTextEditingController,
              onChanged: (String username) {
                //print('hello');
                initiateSearch();
              },
              decoration: InputDecoration(
                hintText: "Search...",
                hintStyle: TextStyle(color: Colors.grey.shade400),
                prefixIcon: Icon(
                  Ionicons.search_circle,
                  color: Colors.grey.shade400,
                  size: 30,
                ),
                filled: true,
                fillColor: Colors.grey.shade300,
                contentPadding: EdgeInsets.all(20),
                enabledBorder: OutlineInputBorder(
                    //borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.grey.shade100)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}
