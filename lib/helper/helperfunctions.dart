import 'package:shared_preferences/shared_preferences.dart';
import 'package:skuy_messaging/helper/constants.dart';

class HelperFunctions{
  static String userLoggedInKey = "ISLOGGEDIN";
  static String usernameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";

  //menyimpan data login username dan email
  static Future<void> saveUserLoggedIn(bool isLoggedIn) async{
      SharedPreferences sp = await SharedPreferences.getInstance();
      return await sp.setBool(userLoggedInKey, isLoggedIn);
  }

  static Future<void> saveUsername(String username) async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    Constants.myName = username;
    return await sp.setString(usernameKey, username);
  }

  static Future<void> saveUserEmail(String email) async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    return await sp.setString(usernameKey, email);
  }
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  //ambil data sp
  static Future<bool> getUserLoggedIn()async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    return await sp.getBool(userLoggedInKey);
  }

  static Future<String> getUsername()async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    return await sp.getString(usernameKey);
  }

  static Future<String> getUserEmail()async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    return await sp.getString(userEmailKey);
  }
}