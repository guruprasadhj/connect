import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction{
  static String sharedPreferenceUserLoggedInKey    = "ISLOGGEDIN"      ;
  static String sharedPreferenceUIDKey             = "UIDKEY"          ;
  static String sharedPreferenceUserNameKey        = "USERNAMEKEY"     ;
  static String sharedPreferenceUsersUserNameKey   = "USERSUSERNAME"   ;
  static String sharedPreferenceUserPicKey         = "USERAVATARKEY"   ;
  static String sharedPreferenceUserEmailKey       = "USEREMAILKEY"    ;
  static String sharedPreferenceUserPhoneNumberKey = "USERPHONENUMBER" ;

  //saving data to sharedPreference
  static Future<bool> saveUserLoggedInSharedPreference(bool isUserLoggedIn)async{
    SharedPreferences prefs =await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }
  static Future<bool> saveUIDSharedPreference(String uid)async{
    SharedPreferences prefs =await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUIDKey, uid);
  }
  static Future<bool> saveUserNameSharedPreference(String name)async{
    SharedPreferences prefs =await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserNameKey, name);
  }
  static Future<bool> saveUsersUserNmeNameSharedPreference(String userName)async{
    SharedPreferences prefs =await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUsersUserNameKey, userName);
  }

  static Future<bool> saveUserPicSharedPreference(String userAvatar) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceUserPicKey, userAvatar);
  }

  static Future<bool> saveUserEmailSharedPreference(String email)async{
    SharedPreferences prefs =await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserEmailKey, email);
  }
  static Future<bool> saveUserPhoneNumberSharedPreference(String email)async{
    SharedPreferences prefs =await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserPhoneNumberKey, email);
  }

//getting data to sharedPreference
  static Future<bool> getUserLoggedInSharedPreference()async{
    SharedPreferences prefs =await SharedPreferences.getInstance();
    return  prefs.getBool(sharedPreferenceUserLoggedInKey)??false;
  }
  static Future<String> getUIDInSharedPreference()async{
    SharedPreferences prefs =await SharedPreferences.getInstance();
    return  prefs.getString(sharedPreferenceUIDKey);
  }
  static Future<String> getUserNameInSharedPreference()async{
    SharedPreferences prefs =await SharedPreferences.getInstance();
    return  prefs.getString(sharedPreferenceUserNameKey);
  }

  static Future<String> getUsersUserNmeNameSharedPreference()async{
    SharedPreferences prefs =await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUsersUserNameKey);
  }

  static Future<String> getUserDpSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceUserPicKey);
  }

  static Future<String> getUserEmailInSharedPreference()async{
    SharedPreferences prefs =await SharedPreferences.getInstance();
    return  prefs.getString(sharedPreferenceUserEmailKey);
  }

  static String timeAgoSinceDate(String dateString,
      {bool numericDates = true}) {
    DateTime date = DateTime.parse(dateString);

    final date2 = DateTime.now();

    final difference = date2.difference(date);

    if ((difference.inDays / 365).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if ((difference.inDays / 365).floor() >= 1) {
      return (numericDates) ? '1 year ago' : 'Last year';
    } else if ((difference.inDays / 30).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} months ago';
    } else if ((difference.inDays / 30).floor() >= 1) {
      return (numericDates) ? '1 month ago' : 'Last month';
    } else if ((difference.inDays / 7).floor() >= 2) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return 'few seconds ago';
    } else {
      return 'Just now';
    }
  }

}