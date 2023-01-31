import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/helper/constants.dart';
import 'package:connect/screens/home.dart';
import 'package:connect/services/database.dart';
import 'package:connect/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoaderPage extends StatefulWidget {
  LoaderPage({Key? key}) : super(key: key);

  @override
  State<LoaderPage> createState() => _LoaderPageState();
}

class _LoaderPageState extends State<LoaderPage> {
  bool isLoading = true;
  DatabaseMethods databaseMethods = DatabaseMethods();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late QuerySnapshot userInfoSnapshot;

  getUserDetails() async {
    print("Getting Data...");
    final SharedPreferences prefs = await _prefs;
    String emailId =
        prefs.getString(Constants.sharedPreferenceUserEmailKey) as String;
    print("Email Id :" + emailId);
    await databaseMethods.getUserInfo(emailId).then((snapshot) {
      userInfoSnapshot = snapshot;
      if (userInfoSnapshot.docs.isNotEmpty) {
        print("Has Data");
        print(snapshot.docs[0].data()["username"]);
        String username = snapshot.docs[0].data()["useremail"];
        Constants.setUsername(username);
        setState(() {
          isLoading = false;
        });
      } else {
        print("No data");
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    getUserDetails();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    //getUserDetails();

    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : HomePage();

    // Scaffold(
    //   body: Stack(
    //     children: [
    //       bgWidget(),
    //       // isLoading
    //       //     ? const Center(
    //       //         child: CircularProgressIndicator(),
    //       //       )
    //       //     :
    //       Center(
    //         child: GestureDetector(
    //           onTap: () => Navigator.push(
    //               context,
    //               PageTransition(
    //                   type: PageTransitionType.fade, child: const HomePage())),
    //           child: Container(
    //             alignment: Alignment.center,
    //             height: 70,
    //             width: 200,
    //             decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(50),
    //               border: Border.all(color: Colors.white),
    //               color: const Color(0xff18293c),
    //               shape: BoxShape.rectangle,
    //             ),
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: const [
    //                 Text(
    //                   "Let's Go",
    //                   style: TextStyle(
    //                     fontSize: 30,
    //                     color: Colors.white,
    //                   ),
    //                 ),
    //                 Icon(
    //                   Icons.arrow_forward_ios,
    //                   color: Colors.white,
    //                   size: 20,
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
