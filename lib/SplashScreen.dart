


import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skuy_messaging/SignIn_n_SignUp/SignIn.dart';

class SplashScreen extends StatefulWidget{
  @override
  SplashState createState() => SplashState();
}

class SplashState extends State< SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(
        Duration(seconds: 3),
            (){
              Navigator.of(context).pushNamedAndRemoveUntil('/signIn', (Route<dynamic> route) => false);
        }
    );

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