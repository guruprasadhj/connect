import 'package:shared_preferences/shared_preferences.dart';

class Constants {
  static String userId = "";
  static String firstName = "";
  static String lastName = "";
  static String emailId = "";
  static String sharedPreferenceUserLoggedInKey = "ISLOGGEDIN";
  static String sharedPreferenceUserNameKey = "USERNAMEKEY";
  static String sharedPreferenceUserAvatarKey = "USERAVATARKEY";
  static String sharedPreferenceUserEmailKey = "USEREMAILKEY";

  static Future setUserLoggedIn(bool isLoggedIn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(sharedPreferenceUserLoggedInKey, isLoggedIn);
  }

  static Future setEmail(String email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(sharedPreferenceUserEmailKey, email);
  }

  static Future setUsername(String username) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(sharedPreferenceUserNameKey, username);
  }

  static Logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(sharedPreferenceUserEmailKey);
    prefs.remove(sharedPreferenceUserLoggedInKey);
    prefs.remove(sharedPreferenceUserNameKey);
  }

  static Future<bool> saveUserLoggedInSharedPreference(
      bool isUserLoggedIn) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(
        sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSharedPreference(String userName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceUserNameKey, userName);
  }

  static Future<bool> saveUserAvatarSharedPreference(String userAvatar) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(
        sharedPreferenceUserAvatarKey, userAvatar);
  }

  static saveUserEmailSharedPreference(String userEmail) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(sharedPreferenceUserEmailKey, userEmail);
  }

  /// This is awesome
  static Future<bool> getUserLoggedInSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(sharedPreferenceUserLoggedInKey) ?? false;
  }

  static Future<String?> getUserNameSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceUserNameKey);
  }

  static Future<String?> getUserAvatarSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceUserAvatarKey);
  }

  Future<String> getUserEmailSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceUserEmailKey).toString();
  }

  static String makeFirstLetterUpperCase(String string) {
    return '${string[0].toUpperCase()}${string.substring(1)}';
  }
}
