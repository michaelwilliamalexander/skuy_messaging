
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skuy_messaging/Firebase_Controller/Authentication.dart';
import 'package:validators/validators.dart' as validator;

class SignUp extends StatefulWidget{
  SignUpState createState()=> SignUpState();
}

class SignUpState extends State<SignUp>{
  final _formKey = GlobalKey<FormState>();
  TextEditingController email = new TextEditingController();
  TextEditingController pass = new TextEditingController();
  TextEditingController name = new TextEditingController();

  TextFormField getForm(String label){
    if(label=="Email"){
      return TextFormField(
        decoration: InputDecoration(
          labelText: label,
          icon: Icon(FontAwesomeIcons.envelope),
        ),
        validator: (input)=> !validator.isEmail(input)? "Format Email Salah":null,
        controller: email,
      );
    }else if(label=="password"){
      return TextFormField(
        decoration: InputDecoration(
          labelText: label,
          icon: Icon(Icons.lock_outline),
        ),
        obscureText: true,
        validator: (input)=> !validator.isLength(input,6)? "Minimal panjang 6":null,
        controller: pass,
      );
    }else if(label=="Username"){
        return TextFormField(
            decoration: InputDecoration(
            labelText: label,
            icon: Icon(Icons.account_circle),
        ),
            controller: name,
        );
    }
  }

  void signUp() async {
    if (_formKey.currentState.validate()) {
      await Auth_Controller.signUpEmail(email.text, pass.text, name.text);
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/signIn', (Route<dynamic> route) => false);
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
                      "Sign Up",
                      style: TextStyle(fontSize: 30),
                    ),
                    getForm("Username"),
                    getForm("Email"),
                    getForm("password"),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Expanded(
                          child: new RaisedButton(
                            onPressed: ()=>{Navigator.of(context)
                                .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false)},
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.grey)),
                            child: Text(
                              "Cancel",
                            ),
                          ),
                        ),
                        new Expanded(
                            child: new RaisedButton(
                              onPressed: signUp,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.grey)),
                              child: Text(
                                "Sign Up",
                              ),
                            ))
                      ],
                    ),
                  ],
                ),
              )),
        )
    );
  }

}