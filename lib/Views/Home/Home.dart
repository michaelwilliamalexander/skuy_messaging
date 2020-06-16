
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skuy_messaging/Views/Contact/contact_screen.dart';
import 'package:skuy_messaging/Firebase_Controller/Authentication.dart';
import 'package:skuy_messaging/Views/Home/HomeScreen.dart';
import 'package:skuy_messaging/helper/constants.dart';
import 'package:skuy_messaging/helper/helperfunctions.dart';

class Home extends StatefulWidget{
  HomeState createState()=> HomeState();
}

class HomeState extends State<Home>{
  SharedPreferences pref;
  String email = "";
  String nama="as";
  FirebaseUser user;


  @override
  void initState(){
    // TODO: implement initState
    getCurrentUser();
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
    setState(() {
      email = user.email;
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
              accountEmail: Text(email),
              accountName: Text(Constants.myName),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.blue,
              ),
            ),
            ListTile(
              title: Text("Contact"),
              leading: Icon(Icons.account_box),
              onTap: goContact,
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


