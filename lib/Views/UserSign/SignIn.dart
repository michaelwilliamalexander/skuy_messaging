
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skuy_messaging/Firebase_Controller/Authentication.dart';
import 'package:skuy_messaging/Firebase_Controller/db_contact.dart';
import 'package:skuy_messaging/Views/UserSign/SignUp.dart';
import 'package:skuy_messaging/helper/helperfunctions.dart';
import 'package:validators/validators.dart' as validator;

class SignIn extends StatefulWidget{
  SignInState createState()=> SignInState();
}

class SignInState extends State<SignIn>{
  final _formKey = GlobalKey<FormState>();
  SharedPreferences pref;
  String info = "";
  TextEditingController email = new TextEditingController();
  TextEditingController pass = new TextEditingController();

  TextFormField getForm(String label) {
    if (label == "Email") {
      return TextFormField(
        decoration: InputDecoration(
          labelText: label,
          icon: Icon(FontAwesomeIcons.envelope),
        ),
        validator: (input) =>
        !validator.isEmail(input) ? "Format Email Salah" : null,
        controller: email,
      );
    } else if (label == "password") {
      return TextFormField(
        decoration: InputDecoration(
          labelText: label,
          icon: Icon(Icons.lock_outline),
        ),
        obscureText: true,
        validator: (input) =>
        !validator.isLength(input, 6) ? "Minimal panjang 6" : null,
        controller: pass,
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  void gmailLogin() async {
    await Auth_Controller.googleSignIn();
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser user = (await Auth_Controller.authentication.currentUser());
    await HelperFunctions.saveUserLoggedIn(true);
    await HelperFunctions.saveUserEmail(user.email);
    QuerySnapshot data = await DbContact.searchEmail(user.email);
    await HelperFunctions
        .saveUsername(data.documents[0].data["username"]);
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
  }

  void emailLogin() async {
    if (_formKey.currentState.validate()) {
      if(await Auth_Controller.emailSignIn(email.text, pass.text)){
        await HelperFunctions.saveUserLoggedIn(true);
        await HelperFunctions.saveUserEmail(email.text);
        QuerySnapshot data = await DbContact.searchEmail(email.text);
        await HelperFunctions
            .saveUsername(data.documents[0].data["username"]);
        print(data.documents[0].data["username"]);
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
        print("berhasil login");
      }else{
        email.clear();
        pass.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: new Center(
          child: new Padding(
              padding: EdgeInsets.all(32),
              child: Form(
                key: _formKey,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      "Sign In",
                      style: TextStyle(fontSize: 30),
                    ),
                    getForm("Email"),
                    getForm("password"),
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: new RaisedButton(
                        onPressed: emailLogin,
                        //color: Colors.white,
                        //highlightColor: Colors.white70,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.grey)),
                        child: Text(
                          "Login",
                        ),
                      ),
                    ),SizedBox(
                      width: double.infinity,
                      child: new RaisedButton(
                        onPressed: gmailLogin,
                        //color: Colors.white,
                        //highlightColor: Colors.white70,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.grey)),
                        child: Text(
                          "Using Gmail",
                        ),
                      ),
                    ),
                    new Column(
                      children: <Widget>[
                        RaisedButton(
                          onPressed: ()=>{Navigator.push(context, MaterialPageRoute(builder: (context)=> SignUp()))},
                          child: Text("Dont Have an Account?",style: TextStyle(color: Colors.black),),
                          color: Colors.white,
                          //highlightColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.white)),

                        ),
                      ],
                    )
                  ],
                ),
              )),
        )
    );
  }

}