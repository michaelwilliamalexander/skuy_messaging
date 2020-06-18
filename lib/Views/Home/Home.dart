
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skuy_messaging/Firebase_Controller/db_contact.dart';
import 'package:skuy_messaging/Views/Contact/contact_screen.dart';
import 'package:skuy_messaging/Firebase_Controller/Authentication.dart';
import 'package:skuy_messaging/Views/Home/HomeScreen.dart';
import 'package:skuy_messaging/Views/Setting/Setting.dart';
import 'package:skuy_messaging/Views/model/user.dart';
import 'package:skuy_messaging/helper/constants.dart';
import 'package:skuy_messaging/helper/helperfunctions.dart';

class Home extends StatefulWidget{
  HomeState createState()=> HomeState();
}

class HomeState extends State<Home>{
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  SharedPreferences pref;
  String image;
  String email = "";
  String nama="";
  FirebaseUser user;

  void registerNotification()async{
    firebaseMessaging.requestNotificationPermissions();
    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      showNotification(message['notification']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      return;
    });
    user = (await Auth_Controller.authentication.currentUser());
    firebaseMessaging.getToken().then((token) {
      print('token: $token');
      print("email"+user.email);
      Firestore.instance.collection('users').document(user.email).updateData({'tokenNotif': token});
    }).catchError((err) {

    });
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid ? 'id.ac.ukdw.skuy_messaging' : 'id.ac.ukdw.skuy_messaging',
      'Flutter chat test',
      'tes tes',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    print(message);
//    print(message['body'].toString());
//    print(json.encode(message));

    await flutterLocalNotificationsPlugin.show(
        0, message['title'].toString(), message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));

//    await flutterLocalNotificationsPlugin.show(
//        0, 'plain title', 'plain body', platformChannelSpecifics,
//        payload: 'item x');
  }

  void configLocalNotification() {
    var initializationSettingsAndroid = new AndroidInitializationSettings("assets/image/LOGO.png");
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  void initState(){
    // TODO: implement initState
    getCurrentUser();
    configLocalNotification();
    registerNotification();
    super.initState();
  }

  Future<void> SignOut()async{
    await Auth_Controller.logOut();
    await HelperFunctions.saveUserLoggedIn(false);
    Navigator.of(context).pushNamedAndRemoveUntil('/signIn',(Route<dynamic>route)=>false);
  }

  Future<void> getCurrentUser()async{
    Constants.myName = await HelperFunctions.getUsername();
    user = (await Auth_Controller.authentication.currentUser());
    String namas = await HelperFunctions.getUsername();
    DbContact.searchUid(user.uid).then((value)async{
      QuerySnapshot sp = value;
      for(int i=0;i<sp.documents.length;i++){
        String tempt = await DbContact.downloadImage(sp.documents[i].data["photo"]);
        setState(() {
          User.photo = tempt;
          User.username = sp.documents[i].data["username"];
        });
      }
    });
    setState(() {
      User.email = user.email;
      User.uid = user.uid;
    });

  }

  void goContact(){
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => ContactScreen()
    ),);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Skuy"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.orange,Colors.red])),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.orange,Colors.red])),
              accountEmail: Text(User.email),
              accountName: Text(Constants.myName),
              currentAccountPicture: User.photo!=null? CircleAvatar(backgroundImage: NetworkImage(User.photo),)
                  :CircleAvatar(backgroundColor: Colors.blueGrey,)
            ),
            ListTile(
              title: Text("Contact"),
              leading: Icon(Icons.account_box),
              onTap: goContact,
            ),
            ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Setting())).then((value){
                  setState(() {
                    getCurrentUser();
                  });
                });
              },
              title: Text("Setting"),
              leading: Icon(FontAwesomeIcons.tools),
            ),
            ListTile(
              title: Text("Sign Out"),
              leading: Icon(FontAwesomeIcons.signOutAlt),
              onTap: SignOut,
            ),
          ],
        ),
      ),
      body: HomeScreen(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: "new Conversation",
        backgroundColor: Colors.orange,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> ContactScreen()));
        },
      ),
    );
  }

}


