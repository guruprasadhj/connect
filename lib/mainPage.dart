import 'package:connect/profile.dart';
import 'package:connect/search.dart';
import 'package:connectivity/connectivity.dart';
import 'chatRoom.dart';
import 'file:///D:/workspace/connect/lib/widgets/blurBottom.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  bool connection;
  static const TextStyle optionStyle =
  TextStyle( fontSize: 30, fontWeight: FontWeight.bold);

  static List<Widget> _widgetOptions = <Widget>[

    ChatRoom(),
    Search(),
    Logins()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  void CheckStatus() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        setState(() => connection = true);
      } else {
        setState(() => connection = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(

        children: <Widget>[
          _widgetOptions.elementAt(_selectedIndex),
          BlurBottomView(
            bottomNavigationBarType: BottomNavigationBarType.fixed,
            showSelectedLabels:true,
            unselectedItemColor: Colors.black,
            backgroundColor: Colors.white,

              bottomNavigationBarItems: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Ionicons.chatbubble_ellipses_outline,size: 30,),
                  title: Text('.',style: optionStyle),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Ionicons.search_circle_outline,size: 30,),
                  title: Text('.',style: optionStyle),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.emoji_emotions,size: 30,),
                  title: Text('.',style: optionStyle),
                )
              ],
              currentIndex: _selectedIndex,
              onIndexChange: (val) {
                _onItemTapped(val);
              }),
        ],
      ),
    );
  }
}
