import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class NoNetwork extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Center(

          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Image(image: AssetImage("assets/images/noNet.png"),height: 350,),),
                Container(
                  child : Text('Something Went Wrong',style: TextStyle(color: Colors.white,fontSize:20),),)
                ],
            ),
          ),
        ),
      ),
    );
  }
}
