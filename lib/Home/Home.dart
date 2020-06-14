
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skuy_messaging/Firebase_Controller/Authentication.dart';
import 'package:skuy_messaging/Home/HomeScreen.dart';

class Home extends StatefulWidget{
  HomeState createState()=> HomeState();
}

class HomeState extends State<Home>{
  SharedPreferences pref;
  String email = "";
  FirebaseUser user;

  @override
  void initState(){
    // TODO: implement initState
    getCurrentUser();
    super.initState();
  }

  Future<void> SignOut()async{
    await Auth_Controller.logOut();
    pref = await SharedPreferences.getInstance();
    pref.setBool("isLogin", false);
    Navigator.of(context).pushNamedAndRemoveUntil('/signIn',(Route<dynamic>route)=>false);
  }

  Future<void> getCurrentUser()async{
    user = (await Auth_Controller.authentication.currentUser());
    setState(() {
      email = user.email;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Skuy"),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(email),
            ),
            ListTile(
              title: Text("Contact"),
              leading: Icon(Icons.account_box),
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
    );
  }

}
