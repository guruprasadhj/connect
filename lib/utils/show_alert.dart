import 'package:flutter/material.dart';



class DialogUtils {
  static final DialogUtils _instance = DialogUtils.internal();

  DialogUtils.internal();

  factory DialogUtils() => _instance;

  static void showCustomDialog(BuildContext context,
      {required String title,
      String yesBtnText = "Yes",
      String noBtnText = "No",
      required Function() action}) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          // contentPadding: EdgeInsets.only(top: 10.0),
          elevation: 0.0,
          child: Container(
            height: 250,
            width: 400,
            child: Stack(
              children: [
                Positioned(
                  right: 28.0,
                  top: 28.0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Align(
                      alignment: Alignment.topRight,
                      child: CircleAvatar(
                        radius: 12.0,
                        backgroundColor: Colors.black38,
                        child: Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 200,
                      child: Text(
                        title,
                        // "Are you sure you want to remove these doctors?",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.lightBlue,
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              width: 100,
                              height: 30,
                              child: Text(noBtnText,
                                  // "No",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      color: Colors.white))),
                        ),
                        InkWell(
                          onTap: action,
                          child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.lightBlue,
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              width: 100,
                              height: 30,
                              child: Text(yesBtnText,
                                  // "Yes",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      color: Colors.white))),
                        ),
                      ],
                    ),
                    // SizedBox(height:50,),
                  ],
                ),
              ],
            ),
          ),
          // contentTextStyle: Theme.of(context).textTheme.labelLarge!.copyWith(),
        );
      },
    );
  }
  static void showCustomAlertDialog(BuildContext context,
      {required String title,
      required String content}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go Back'))
        ],
      ),
    );
  }
}
