import 'package:flutter/material.dart';
import 'package:skuy_messaging/Home/Home.dart';
import 'package:skuy_messaging/SignIn_n_SignUp/SignIn.dart';
import 'package:skuy_messaging/SplashScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: <String,WidgetBuilder>{
        '/':(context)=> SplashScreen(),
        '/signIn':(context)=>SignIn(),
        '/home':(context)=>Home(),

      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

