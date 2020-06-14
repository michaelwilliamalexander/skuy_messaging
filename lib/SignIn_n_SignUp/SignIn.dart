
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skuy_messaging/Firebase_Controller/Authentication.dart';
import 'package:skuy_messaging/SignIn_n_SignUp/SignUp.dart';
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
    _cekLogin();
  }

  void emailLogin() async {
    if (_formKey.currentState.validate()) {
      if(await Auth_Controller.emailSignIn(email.text, pass.text)){
        pref = await SharedPreferences.getInstance();
        pref.setBool("isLogin", true);
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
      }else{
        email.clear();
        pass.clear();
      }
    }
  }

  Future _cekLogin() async {
    pref = await SharedPreferences.getInstance();
    if (pref.getBool("isLogin")) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.white,
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
                    SizedBox(
                      width: double.infinity,
                      child: new RaisedButton(
                        onPressed: emailLogin,
                        color: Colors.white,
                        highlightColor: Colors.white70,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.grey)),
                        child: Text(
                          "Login",
                        ),
                      ),
                    ),
                    new Column(
                      children: <Widget>[
                        RaisedButton(
                          onPressed: ()=>{Navigator.push(context, MaterialPageRoute(builder: (context)=> SignUp()))},
                          child: Text("Dont Have a Account",style: TextStyle(color: Colors.lime),),
                          color: Colors.white,
                          highlightColor: Colors.white,
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