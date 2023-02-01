import 'package:connect/helper/chatUser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class ChatCard extends StatelessWidget {
  ChatCard({Key? key,required this.chatUsers}) : super(key: key);
  ChatUsers chatUsers;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey),) //.all(color: Colors.blueAccent)
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            foregroundImage: AssetImage("${chatUsers.imageURL}",),
            backgroundImage: const AssetImage("assets/images/default_profile.jpg"),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: SizedBox(
              width: 45.w,
              // color: Colors.red,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                        // "<Name>"
                        chatUsers.name,
                    ),
                  ),
                  Text(
                  chatUsers.messageText,overflow:TextOverflow.ellipsis ,
                      // "<Conversation>"
                  ),
                ],
              ),
            ),
          ),
          Spacer(),
          SizedBox(
            width: 18.w,
            child: Text(
              chatUsers.time,overflow:TextOverflow.ellipsis,textAlign: TextAlign.right,
              // "<Time>"
            ),
          ),
          /*Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                chatUsers.time,
                // "<Time>"
              ),

              // Center(child: Text("<Conversation>")),
            ],
          ),*/
        ],
      ),
    );
  }
}
