import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/constants.dart';
import 'package:connect/helperFunction.dart';
import 'package:connect/mainPage.dart';
import 'package:connect/service/auth.dart';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:octo_image/octo_image.dart';
import 'package:path/path.dart';

import 'widgets/clipper.dart';

class Logins extends StatefulWidget {
  @override
  _LoginsState createState() => _LoginsState();
}

class _LoginsState extends State<Logins> {
  final Firestore _db = Firestore.instance;

  // ignore: non_constant_identifier_names
  File ImageFile;
  File cropped;
  bool connection = true;
  bool isLoading = false;
  StreamSubscription<DataConnectionStatus> listener;

  var Internetstatus = "Unknown";

  @override
  void initState() {
    super.initState();
    getprofile();
    //state = AppState.free;
  }

  CheckInternet() async {
    // Simple check to see if we have internet
    print("The statement 'this machine is connected to the Internet' is: ");
    print(await DataConnectionChecker().hasConnection);
    // returns a bool

    // We can also get an enum instead of a bool
    print("Current status: ${await DataConnectionChecker().connectionStatus}");
    // prints either DataConnectionStatus.connected
    // or DataConnectionStatus.disconnected

    // This returns the last results from the last call
    // to either hasConnection or connectionStatus
    print("Last results: ${DataConnectionChecker().lastTryResults}");

    // actively listen for status updates
    listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          Internetstatus="yes";
          print('Data connection is available.');
          setState(() {

          });
          break;
        case DataConnectionStatus.disconnected:
          Internetstatus="No Data Connection";
          print('You are disconnected from the internet.');
          setState(() {

          });
          break;
      }
    });

    // close listener after 30 seconds, so the program doesn't run forever
//    await Future.delayed(Duration(seconds: 30));
//    await listener.cancel();
    return await await DataConnectionChecker().connectionStatus;
  }

  void getprofile() async {
    Constants.UsersUID = await HelperFunction.getUIDInSharedPreference();
    Constants.UsersName = await HelperFunction.getUserNameInSharedPreference();
    Constants.UsersUserName = await HelperFunction.getUsersUserNmeNameSharedPreference();
    Constants.UsersPic = await HelperFunction.getUserDpSharedPreference();
    Constants.UsersMail = await HelperFunction.getUserEmailInSharedPreference();
  }

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    Future uploadPic() async {
      try {
        setState(() => isLoading = true);
        DocumentReference ref =
            _db.collection('users').document(Constants.UsersUID);
        String filename = basename(ImageFile.path);
        StorageReference firebaseStorageRef =
            FirebaseStorage.instance.ref().child(filename);
        StorageUploadTask uploadTask = firebaseStorageRef.putFile(ImageFile);
        StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

        var downurl = await taskSnapshot.ref.getDownloadURL();
        String url = downurl.toString();
        HelperFunction.saveUserPicSharedPreference(url);
        Constants.UsersPic = url;
        Fluttertoast.showToast(
            msg: "Profile Pic Updated \n It take time show ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.black45,
            textColor: Colors.white,
            fontSize: 16.0);
        setState(() {
          // ignore: unnecessary_statements
          Constants.UsersPic;
          // ignore: unnecessary_statements
          isLoading == false;
        });
        ref.setData({'photoURL': url}, merge: true);
        print('💁👌🎍😍${url}');

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) {
              //setState(() =>isLoading = false );
              return MainPage();
            },
          ),
        );
      } catch (e) {
        print('AAAA ${e}');
      }
    }

    void _clearImage() {
      setState(() {
        ImageFile = null;
      });
    }

    Future _cropImage() async {
      File cropped = await ImageCropper.cropImage(
          sourcePath: ImageFile.path,
          cropStyle: CropStyle.circle,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          androidUiSettings: AndroidUiSettings(
            toolbarTitle: "Crop",
            statusBarColor: Colors.black,
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: Colors.blue,
          ),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));

      if (cropped == null) {
        _clearImage();
      } else {
        uploadPic();
        setState(() {
          ImageFile = cropped ?? cropped;
        });
      }
    }

    Future getImage(ImageSource source) async {
      PickedFile pickedFile = await ImagePicker().getImage(source: source);
      ImageFile = File(pickedFile.path);
      _cropImage();
    }

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Hello, ${Constants.UsersName} ",
            style: TextStyle(
                fontFamily: 'Pacifico', color: Colors.black, fontSize: 17),
          ),
        actions: <Widget>[
      IconButton(
      icon: Icon(
        Ionicons.log_out,
        color: Colors.black,
      ),
      onPressed: () {
        AuthService().signOut(context);
      },
    )]

      ),
      //backgroundColor: Colors.black,
      body: Column(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              //Container(),
              ClipPath(
                clipper: MyCustomClipper(),
                child: Container(
                  height: 250.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/banner.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  //physics: BouncingScrollPhysics(),
                  children: [
                    SizedBox(
                      height: 150,
                    ),
                    GestureDetector(
                      onTap: () {
                        //getImage();

                        final act = CupertinoActionSheet(
                            title: Text('Pick Profile'),
                            //message: Text('profile Picture'),
                            actions: <Widget>[
                              CupertinoActionSheetAction(
                                child: Stack(
                                  children: [
                                    Icon(
                                      Icons.camera,
                                      color: Colors.black38,
                                    ),
                                    Center(child: Text('Camera')),
                                  ],
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  getImage(ImageSource.camera);
                                },
                              ),
                              CupertinoActionSheetAction(
                                child: Stack(
                                  children: [
                                    Icon(
                                      Icons.photo,
                                      color: Colors.black38,
                                    ),
                                    Center(child: Text('gallery')),
                                  ],
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  getImage(ImageSource.gallery);
                                },
                              ),
                            ],
                            cancelButton: CupertinoActionSheetAction(
                              child: Text('cancel'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ));
                        showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext context) => act);
                      },
                      child: isLoading == true
                          ? Container(
                              child: Center(
                                  child: SizedBox(
                                      width: 145,
                                      height: 145,
                                      child:
                                          CircularProgressIndicator())),
                            )
                          : Container(
                              child: SizedBox(
                                height: 145,
                                child: OctoImage.fromSet(
                                  fit: BoxFit.cover,
                                  image: CachedNetworkImageProvider(
                                      Constants.UsersPic),
                                  octoSet: OctoSet.circleAvatar(
                                    backgroundColor: Colors.cyan,
                                    text: Text(
                                      '${Constants.UsersName[0]}',
                                      style: TextStyle(
                                        fontSize: 21.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              width: 145.0,
                              height: 145.0,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  image: DecorationImage(
                                      image: (ImageFile != null)
                                          ? FileImage(ImageFile)
                                          : NetworkImage(
                                              Constants.UsersPic,
                                            ),
                                      //AssetImage('assets/images/dp.jpg'),

                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(75.0)),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 7.0,
                                        color: Colors.grey.shade700)
                                  ]),
                            ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 4.0),
                    Text(
                      Constants.UsersName,
                      //"Guru Prasadh J",
                      style: TextStyle(
                        fontSize: 21.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '@${Constants.UsersUserName}',
                      //"@guruprasadh_j",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //crossAxisAlignment: CrossAxisAlignment.,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: [
                          Icon(Icons.phone),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            Constants.UsersPhoneNo.length == 0
                                ? "Not Mentioned"
                                : '${Constants.UsersPhoneNo}',
                            //"+91 99439 38584",
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: [
                          Icon(
                            Icons.favorite,
                            size: 20,
                            color: Colors.pinkAccent,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Single",
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 21.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.lightbulb,
                            size: 40.0,
                            color: Colors.amber,
                          ),
                        ),
                        SizedBox(width: 24.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              "About me :",
                              style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              "Hey, connect me on connect ",
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 17.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
          );
  }
}
