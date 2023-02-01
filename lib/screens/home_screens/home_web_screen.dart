import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/screens/home_screens/components/chat_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/chatUser.dart';
import '../../helper/constants.dart';
import '../../services/database.dart';
import '../../utils/show_alert.dart';
import '../home.dart';
import '../login.dart';
class HomeWebScreen extends StatefulWidget {
  const HomeWebScreen({Key? key}) : super(key: key);

  @override
  State<HomeWebScreen> createState() => _HomeWebScreenState();
}

class _HomeWebScreenState extends State<HomeWebScreen> with SingleTickerProviderStateMixin {
  final Tween<double> _tween1 = Tween(begin: 0.3, end: 0.5);
  final Tween<double> _tween2 = Tween(begin: 0.3, end: 0.5);
  // late final AnimationController _controller;
  // late final Animation<double> _animation;
  // late final Animation<Offset> _offsetAnimation;
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(1.5, 0.0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  ));
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late String emailId;
  late String username;
  bool isSearching=false;
  bool isSearchScreen=false;
  bool isLoading=false;
  bool haveUserSearched = false;
  TextEditingController searchEditingController = TextEditingController();
  DatabaseMethods databaseMethods = DatabaseMethods();
  late QuerySnapshot searchResultSnapshot;


  @override
  void initState() {
    setState(()=>isLoading=true);
    // _controller = AnimationController(
    //   duration: const Duration(seconds: 2),
    //   vsync: this,
    // )..repeat(reverse: true);
    // _animation = CurvedAnimation(
    //   parent: _controller,
    //   curve: Curves.fastOutSlowIn,
    // );
    // _offsetAnimation = Tween<Offset>(
    //   begin: Offset.zero,
    //   end: const Offset(1.5, 0.0),
    // ).animate(CurvedAnimation(
    //   parent: _controller,
    //   curve: Curves.fastOutSlowIn,
    // ));
    _prefs.then((SharedPreferences preps) {
      setState(() {
        username = preps.getString(Constants.sharedPreferenceUserNameKey) ??
            "username";
        emailId =
            preps.getString(Constants.sharedPreferenceUserEmailKey) ?? "email";
      });
    });

    setState(()=>isLoading=false);
    super.initState();
  }

  initiateSearch() async {
    if(searchEditingController.text.isNotEmpty){
      setState(() {
        isLoading = true;
      });
      await databaseMethods.searchByName(searchEditingController.text)
          .then((snapshot){
        searchResultSnapshot = snapshot;
        print("$searchResultSnapshot");
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: isLoading?
      Center(
        child: CircularProgressIndicator(),
      )
          :Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xff7bd5f5),
                  Color(0xff787ff6),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: ScaleTransition(
              scale: _tween1.animate(_animation),
              child: Container(
                width: currentHeight / 2,
                height: currentHeight / 2,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Positioned(
            left: currentWidth / 3,
            top: currentHeight / 1.7,
            child: ScaleTransition(
              scale: _tween2.animate(_animation),
              child: Container(
                width: currentHeight / 2,
                height: currentHeight / 2,
                //height: 300,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: ScaleTransition(
              scale: _tween2.animate(_animation),
              child: Container(
                width: currentHeight / 1.5,
                height: currentHeight / 1.5,
                decoration: const BoxDecoration(
                  color: Colors.pinkAccent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Positioned(
            right: currentWidth / 7,
            top: currentHeight / 1.6,
            child: SlideTransition(
              position: _offsetAnimation,
              child: Container(
                width: currentHeight / 4,
                height: currentHeight / 4,
                decoration: const BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child:  GlassmorphicContainer(
                  width: currentWidth-10,
                  height: currentHeight-10,
                  borderRadius: 50,
                  blur: 20,
                  alignment: Alignment.bottomCenter,
                  border: 2,
                  linearGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFFffffff).withOpacity(0.2),
                        const Color(0xFFFFFFFF).withOpacity(0.2),
                      ],
                      stops: const [
                        0.1,
                        1,
                      ]),
                  borderGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFffffff).withOpacity(0.5),
                      const Color((0xFFFFFFFF)).withOpacity(0.5),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: currentHeight,
                        width: currentWidth/4,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Container(
                            height: 125,
                            width: currentWidth/4,
                            color: Colors.white,
                            constraints: BoxConstraints(
                              minWidth: 300,
                            ),
                            padding: EdgeInsets.all(10.0),
                            child: isSearchScreen?
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                    onPressed: (){
                                      setState(()=>isSearchScreen =!isSearchScreen);
                                    },
                                    icon: Icon(Icons.arrow_back_rounded,color: Colors.black,)),
                                Container(
                                  width: (currentWidth/4)-90,
                                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                                  child: TextField(
                                    controller: searchEditingController,
                                    onChanged: (value){},
                                    decoration: InputDecoration(
                                      hintText: "Search",
                                      suffixIcon: Icon(Icons.search_rounded)
                                    ),
                                  ),
                                ),

                              ],
                            )
                                :Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 42,
                                  foregroundImage: AssetImage("assets/images/default_profile.jpg"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("<Username>"),
                                      Text("<Email>"),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                     Padding(
                                      padding: const EdgeInsets.only(
                                          right: 10, left: 10,bottom: 15),
                                      child: IconButton(
                                          onPressed: (){
                                            DialogUtils.showCustomDialog(context,
                                              title: "Do you wanna LogOut ?",
                                              action: () async {
                                                Constants.Logout();
                                                FirebaseAuth.instance.signOut();
                                                Navigator.pushReplacement(
                                                    context,
                                                    PageTransition(
                                                        type: PageTransitionType
                                                            .fade,
                                                        child:
                                                        const LoginPage()));
                                              },);

                                          },
                                          icon: const Icon(Icons.logout)),
                                    ),
                                    IconButton(onPressed: (){
                                      setState(()=>isSearchScreen =!isSearchScreen);
                                    }, icon: Icon(Icons.search))
                                  ],
                                )
                              ],
                            ),
                          ),
                            isSearchScreen?
                                Center(child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Image.asset("assets/images/search-illustration.png"),
                                ),)
                                :Expanded(
                                  child: ListView.builder(
                              // physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                                  itemCount: chatUsers.length,
                                  itemBuilder: (context, index) {
                                    return ChatCard(chatUsers: chatUsers[index],);
                                  }),
                                )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),

         /* Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                isSearching
                    ? Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(0),
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(0),
                    ),
                    color: Colors.white.withOpacity(0.5),
                  ),
                  height: 900,
                  width: 350,
                  child: Column(
                    children: [
                      Container(
                        width: 350,
                        height: 125,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(0),
                          ),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 300,
                              height: 50,
                              child: TextField(
                                onChanged: (value) {
                                  // initiateSearch();
                                },
                                controller: searchEditingController,
                                cursorHeight: 25,
                                decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.search),
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20)),
                                    ),
                                    hintText: 'Search Here...'),
                              ),
                            ),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isSearching = !isSearching;
                                  });
                                },
                                child: Icon(Icons.close_rounded)),
                            //Container(width: 250, child: TextField())
                          ],
                        ),
                      ),
                      // userList(),
                    ],
                  ),
                )
                    : Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(0),
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(0),
                    ),
                    color: Colors.white.withOpacity(0.5),
                  ),
                  height: 900,
                  width: 350,
                  child: Column(
                    children: [
                      Container(
                        width: 350,
                        height: 125,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(0),
                          ),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(
                                left: 15,
                              ),
                              child: CircleAvatar(
                                radius: 42,
                                // backgroundColor: Colors.blue,
                                backgroundImage: NetworkImage(
                                    "assets\\images\\default_profile.jpg"),
                                // "https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/c58146e8-3480-4eb6-8497-0b5bed970d6a/ddspajr-552fcad7-9659-40cf-9fab-21777cd0ec32.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7InBhdGgiOiJcL2ZcL2M1ODE0NmU4LTM0ODAtNGViNi04NDk3LTBiNWJlZDk3MGQ2YVwvZGRzcGFqci01NTJmY2FkNy05NjU5LTQwY2YtOWZhYi0yMTc3N2NkMGVjMzIuanBnIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmZpbGUuZG93bmxvYWQiXX0.0-KSQxM1xl1G3em80w42sCZpcYuAE5pxoVnQCcIJSZI"),
                                // "https://firebasestorage.googleapis.com/v0/b/connect-cup.appspot.com/o/avatar%2Favatar%20(1).png?alt=media&token=d431ed9c-5e35-4832-96d7-35fe78b27ca5"),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                // Text("${username.toString()}"),
                                // Text(emailId),
                                //Text(user.email.toString()),
                              ],
                            ),
                            Spacer(),
                            Column(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                    onTap: () async {
                                      Constants.Logout();
                                      FirebaseAuth.instance.signOut();
                                      Navigator.pushReplacement(
                                          context,
                                          PageTransition(
                                              type: PageTransitionType
                                                  .fade,
                                              child:
                                              const LoginPage()));
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.only(
                                          right: 10, left: 10),
                                      child: Icon(Icons.logout),
                                    )),
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isSearching = !isSearching;
                                      });
                                    },
                                    child: Icon(Icons.search)),
                                const SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Expanded(
                      //   child: ListView.builder(
                      //     itemCount: chatUsers.length,
                      //     padding: EdgeInsets.only(top: 16),
                      //     physics: BouncingScrollPhysics(),
                      //     itemBuilder: (context, index) {
                      //       return ConversationList(
                      //         name: chatUsers[index].name,
                      //         messageText: chatUsers[index].messageText,
                      //         imageUrl: chatUsers[index].imageURL,
                      //         time: chatUsers[index].time,
                      //         isMessageRead: (index == 0 || index == 3)
                      //             ? true
                      //             : false,
                      //       );
                      //     },
                      //   ),
                      // ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
                // isNoChat
                //     ? Container(
                //   height: currentHeight,
                //   width: currentWidth - 367,
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: const [
                //       Image(
                //         height: 400,
                //         width: 400,
                //         image: NetworkImage("assets/images/anime.png"),
                //       )
                //     ],
                //   ),
                // )
                //     : Container(
                //   height: currentHeight,
                //   width: currentWidth - 367,
                //   decoration: const BoxDecoration(
                //       borderRadius: BorderRadius.only(
                //         topLeft: Radius.circular(0),
                //         topRight: Radius.circular(50),
                //         bottomLeft: Radius.circular(0),
                //         bottomRight: Radius.circular(50),
                //       ),
                //       color: Colors.purple),
                //   child: Column(
                //     children: [
                //       Container(
                //         width: currentWidth - 350,
                //         height: 125,
                //         decoration: const BoxDecoration(
                //           borderRadius: BorderRadius.only(
                //             topRight: Radius.circular(50),
                //             topLeft: Radius.circular(0),
                //             bottomLeft: Radius.circular(0),
                //             bottomRight: Radius.zero,
                //           ),
                //           color: Colors.white,
                //         ),
                //       ),
                //       Container(
                //         height: currentHeight - 250,
                //         color: Colors.amber,
                //       )
                //     ],
                //   ),
                // ),
              ],
            ),
          ),*/
        ],
      ),
    );
  }
  List<ChatUsers> chatUsers = [
    ChatUsers(
        name: "Jane Russel",
        messageText: "Awesome Setup",
        imageURL: "assets/avatars/avatar_1.png",
        time: "Now"),
    ChatUsers(
        name: "Glady's Murphy",
        messageText: "That's Great",
        imageURL: "assets/avatars/avatar_3.png",
        time: "Yesterday"),
    ChatUsers(
        name: "Jorge Henry",
        messageText: "Hey where are you?",
        imageURL: "assets/avatars/avatar_2.png",
        time: "31 Mar"),
    ChatUsers(
        name: "Philip Fox",
        messageText: "Busy! Call me in 20 mins",
        imageURL: "assets/avatars/avatar_1.png",
        time: "28 Mar"),
    ChatUsers(
        name: "Debra Hawkins",
        messageText: "Thankyou, It's awesome",
        imageURL: "assets/avatars/avatar_4.png",
        time: "23 Mar"),
    ChatUsers(
        name: "Jacob Pena",
        messageText: "will update you in evening",
        imageURL: "assets/avatars/avatar_5.png",
        time: "17 Mar"),
    ChatUsers(
        name: "Andrey Jones",
        messageText: "Can you please share the file?",
        imageURL: "assets/avatars/avatar_2.png",
        time: "24 Feb"),
    ChatUsers(
        name: "John Wick",
        messageText: "How are you?",
        imageURL: "assets/avatars/avatar_3.png",
        time: "18 Feb"),
  ];
}
