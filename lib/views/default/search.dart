import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/helpers/constants.dart';
import 'package:connect/services/database.dart';
import 'package:connect/views/default/converstionScreen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'main_page.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController = new TextEditingController();
  QuerySnapshot searchSnapshot;
  QuerySnapshot recentUsersSnapshot;

  bool isLoading = false;
  bool haveUserSearched = false;

  initiateSearch()async{
    if(searchTextEditingController.text.isNotEmpty){
      setState(() {
        isLoading = true;
      });
      await databaseMethods.getUserByUsername(searchTextEditingController.text).then((val){
        searchSnapshot = val;
        //print("Holly Molly Fucking Val i ${searchSnapshot}");
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }
  getRecentMembers() {
    DatabaseMethods().getRecentUsers().then((snapshot) {
      print(snapshot.documents[0].data['userName'].toString()+"this is awesome");
      setState(() {
        recentUsersSnapshot = snapshot;
      });
    });
  }
  // ignore: missing_return
  Widget recentUser(){

  }

  Widget searchList(){
    return isLoading ? Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Center(child: CircularProgressIndicator(),),
    ) : Container(

        child: searchSnapshot!= null ? ListView.builder(
            itemCount: searchSnapshot.documents.length,
            shrinkWrap: true,
            itemBuilder: (context,index){
              return searchTile(
                // ignore: deprecated_member_use
                  userName:searchSnapshot.documents[index].data["username"],
                  name:searchSnapshot.documents[index].data["name"],
                  userDp:searchSnapshot.documents[index].data["dp"]
              );
            }):Container());
  }



  createChatRoomAndChat({String userName,String userDp}){
    if(userName!=Constants.myName){
      String chatRoomId = getChatRoomId(userName, Constants.myName);
      List<String> users = [userName, Constants.myName];
      List<String> avatarUrls = [userDp,Constants.myPic];
      List<int> unreadMessages = [0, 1];
      Map<String,dynamic>chatRoomMap={
        "users":users,
        "DisplayPictureUrl": avatarUrls,
        "lastMessage": "message",
        "lastMessageSendBy": Constants.myName,
        'timestamp': Timestamp.now(),
        "unreadMessage": unreadMessages,
        "chatRoomId":chatRoomId,
        "protectMode":"pass",
      };

      DatabaseMethods().createChatRoom(chatRoomId,chatRoomMap);
      //Navigator.push(context, MaterialPageRoute(builder: (context)=> ConversationScreen(chatRoomId:widget.chatRoomId.toString() , userName:widget.name.toString(),displayPic:widget.image.toString())));
      Navigator.push(context, MaterialPageRoute(builder: (context)=> ConversationScreen(chatRoomId:chatRoomId , userName:userName,displayPic: userDp ,)));
    }else{
      print("you cannot send message to yourself idiot");
    }
  }
  getChatRoomId(String a, String b){
    if(a.substring(0,1).codeUnitAt(0)>b.substring(0,1).codeUnitAt(0)){
      return"$b\_$a";
    }else{
      return "$a\_$b";
    }
  }
  Widget searchTile({String userName,String name,userDp}){
    return Container(

      padding: EdgeInsets.symmetric(horizontal: 24 , vertical: 16),
      child:  Row(
        children: [
          Container(

            height:40,
            width: 40,
            alignment: Alignment.topRight,
            decoration:  BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(40)
            ),
            child: userDp ==null ? Text("${userName.substring(0,1).toUpperCase()}",style: TextStyle(color: Colors.black,
                fontSize: 20))
                :CircleAvatar(
              radius: 50.0,
              backgroundImage:
              NetworkImage("${userDp}"),
              backgroundColor: Colors.transparent,
            ),
          ),
          SizedBox(width: 20,),
          Column(
            children: [
              Text("@${userName}", style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontFamily: 'OverpassRegular',
                  fontWeight: FontWeight.w300)),
              Text(name,style: TextStyle(color: Colors.black, fontSize: 16))
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              createChatRoomAndChat(userName:userName,userDp:userDp);
            },
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.pinkAccent,
                    borderRadius: BorderRadius.circular(30)
                ),
                padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8 ),
                child: Icon(Icons.chat_bubble,color: Colors.white)//Text("Message",style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          )

        ],
      ),

    );

    /*  Container(
          padding: EdgeInsets.symmetric(horizontal: 24 ,vertical: 16),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userName,style: TextStyle(color: Colors.white, fontSize: 16),),
                  Text(name,style: TextStyle(color: Colors.white, fontSize: 16))
                ],
              ),
              Spacer(),
              GestureDetector(
                onTap: (){
                  createChatRoomAndChat(userName:userName);
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(30)
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8 ),
                  child: Text("Message",style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              )
            ],
          ),
        ));*/
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 16,right: 16,top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Search",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                  Container(
                    padding: EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 2),
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.pink[50],
                    ),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: MainPage()));
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.close,color: Colors.pink,size: 20,),
                          SizedBox(width: 2,),
                          Text("close",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 16,left: 16,right: 16),
                  child: TextField(
                    onChanged: (val){
                      initiateSearch();
                    },
                    controller: searchTextEditingController,
                    decoration: InputDecoration(
                      hintText: "Search...",
                      hintStyle: TextStyle(color: Colors.grey.shade400,fontSize: 18),
                      prefixIcon: Icon(Icons.search,color: Colors.grey.shade400,size: 20,),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: EdgeInsets.all(8),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                              color: Colors.grey.shade100
                          )
                      ),
                    ),
                  ),

                ),
//            Container(
//              color: Color(0x54ffffff),
//              padding: EdgeInsets.symmetric(horizontal: 14,vertical: 16),
//              child: Row(
//                children: [
//                  Expanded(child: TextField(
//                    controller: searchTextEditingController,
//                    style:TextStyle(color: Colors.white),
//                    decoration: InputDecoration(
//                      hintText: "Search Username",
//                      hintStyle: TextStyle(color: Colors.white54),
//                    ),
//                  )),
//                  GestureDetector(
//                    onTap: (){
//                      initiateSearch();
//                    },
//                    child: Container(
//                      height: 40,
//                      width: 40,
//                      decoration: BoxDecoration(
//                          gradient: LinearGradient(
//                              colors:[
//                                const Color(0x36ffffff),
//                                const Color(0x0ffffff)
//                              ]
//                          ),
//                          borderRadius: BorderRadius.circular(40)
//                      ),
//                      child:
//                      Container( child: Icon(Icons.search,color: Colors.white)),
//                    ),
//                  ),
//                ],
//              ),
//            ),
                searchList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}







