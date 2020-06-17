import 'package:flutter/material.dart';
import 'package:skuy_messaging/Views/Home/Home.dart';
import 'package:skuy_messaging/Views/UserSign//SignIn.dart';
import 'package:skuy_messaging/Views/SplashScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black38
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: <String,WidgetBuilder>{
        '/':(context)=> SplashScreen(),
        '/signIn':(context)=>SignIn(),
        '/home':(context)=>Home(),
        //'/conversation':(context)=>ChatRoom(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

