import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/components/chat.dart';
import 'package:connect/helpers/constants.dart';
import 'package:connect/helpers/helperfunction.dart';
import 'package:connect/services/database.dart';
import 'package:connect/views/default/timeLine_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'chat_page.dart';


class MainPage extends StatefulWidget{

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

//  PageController pageController;
//  int _page = 0;
//  DatabaseMethods databaseMethods = new DatabaseMethods();
//  QuerySnapshot getUserSnapshot;
//  Constants constants = new Constants();
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    ChatPage(),
    Text('Messgaes Screen'),
    Text('Profile Screen'),
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    saveUser();
    super.initState();
  }

  saveUser() async {
    Constants.myName = await HelperFunction.getUserNameInSharedPreference();
    Constants.myName = await HelperFunction.getUserNameInSharedPreference();
    Constants.myPic= await HelperFunction.getUserDpSharedPreference();
    Constants.myMail=await HelperFunction.getUserEmailInSharedPreference();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey.shade400,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat_bubble_outline,
            ),
            title: Text(
              'Messages',
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle_outline,
            ),
            title: Text(
              'Timeline',
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
            ),
            title: Text(
              'Profile',
            ),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
        selectedFontSize: 13.0,
        unselectedFontSize: 13.0,
      ),
    );


//  static const TextStyle optionStyle =  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
//
//  static const List<Widget> _widgetOptions = <Widget>[
//    ChatPage(),
//    //TimeLine(),
//    Text(
//      'Index 2: School',
//      style: optionStyle,
//    ),
//  ];
//
//
//
//  void onPageChanged(int page) {
//    setState(() {
//      _page = page;
//    });
//  }
//
//  void navigationTapped(int page) {
//    pageController.jumpToPage(page);
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      backgroundColor: Constants.mode==false?Colors.black:Color(0xFF1B1C1E),
//      body: PageView(
//        children: <Widget>[
//          ChatPage(),
//          Center(
//              child: Text(
//                "Contact Screen",
//                style: TextStyle(color: Colors.white),
//              )),
//          Center(
//              child: Text(
//                "Contact Screen",
//                style: TextStyle(color: Colors.white),
//              )),
//        ],
//        controller: pageController,
//        onPageChanged: onPageChanged,
//        physics: NeverScrollableScrollPhysics(),
//      ),
//      //backgroundColor: Colors.black87,
//      bottomNavigationBar: BottomNavigationBar(
//        backgroundColor: Constants.mode==false? Colors.white : Color(0xFF1a1a1a),
//        // backgroundColor: Colors.transparent,
//        selectedItemColor: Colors.pink,
//        unselectedItemColor: Colors.grey.shade400,
//        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
//        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
//        type: BottomNavigationBarType.fixed,
//        items: [
//          BottomNavigationBarItem(
//            icon: Icon(Icons.chat),
//            title: Text("Chats"),
//          ),
//          BottomNavigationBarItem(
//            icon: Icon(Icons.timeline),
//            title: Text("Groups"),
//          ),
//          BottomNavigationBarItem(
//            icon: Icon(Icons.account_circle),
//            title: Text("Profile"),
//          ),
//        ],
//        onTap: navigationTapped,
//        currentIndex: _page,
//      ),
//      //ChatPage(),
//    );
  }
}



