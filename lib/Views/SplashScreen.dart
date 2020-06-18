
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skuy_messaging/Views/UserSign/SignIn.dart';
import 'package:skuy_messaging/helper/helperfunctions.dart';

class SplashScreen extends StatefulWidget{
  @override
  SplashState createState() => SplashState();
}

class SplashState extends State< SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cekLogin();
  }

  Future _cekLogin() async {
    if (await HelperFunctions.getUserLoggedIn() == true) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
    }else{
      Future.delayed(
          Duration(seconds: 3),
              (){
            Navigator.of(context).pushNamedAndRemoveUntil('/signIn', (Route<dynamic> route) => false);
          }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image(
          image: AssetImage("assets/image/LOGO.png"),
        ),
      ),
    );
  }
}