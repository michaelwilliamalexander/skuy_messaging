
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skuy_messaging/Firebase_Controller/Authentication.dart';
import 'package:skuy_messaging/Firebase_Controller/db_contact.dart';
import 'package:skuy_messaging/Views/ChatRoom/DetailPhoto.dart';
import 'package:skuy_messaging/Views/model/user.dart';
import 'package:skuy_messaging/helper/constants.dart';

class Setting extends StatefulWidget{
  SettingState createState()=> SettingState();
}

class SettingState extends State<Setting>{
  TextEditingController _username = new TextEditingController();
  Future pickPictureFromGallery() async{
    var galeryFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    String tempt = "Profile-"+User.uid;
    await DbContact.updatePhoto(User.email,tempt);
    await DbContact.uploadImage(tempt, galeryFile);
    String count = await DbContact.downloadImage(tempt);
    setState(() {
      User.photo = count;
    });
  }

  Future pickPictureUsingPhoto() async{
    var galeryFile = await ImagePicker.pickImage(source: ImageSource.camera);
    String tempt = "Profile-"+User.uid;
    await DbContact.updatePhoto(User.email,tempt);
    await DbContact.uploadImage(tempt, galeryFile);
    String count = await DbContact.downloadImage(tempt);
    setState(() {
      User.photo = count;
    });
  }

  Future<String> createBoxDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Photo"),
              ],
            ),
            content: Wrap(
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  child: new RaisedButton(
                    onPressed: ()async{
                      await pickPictureUsingPhoto();
                      Navigator.pop(context);
                    },
                    color: Colors.black,
                    //highlightColor: Colors.white70,
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.grey)),
                    child: Text(
                      "Camera",
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: new RaisedButton(
                    onPressed: ()async{
                      await pickPictureFromGallery();
                      Navigator.pop(context);
                    },
                    color: Colors.black,
                    //highlightColor: Colors.white70,
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.grey)),
                    child: Text(
                      "Galery",
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<void> changeUsername(){
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Enter the new Username"),
              ],
            ),content: Wrap(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Username",
                ),
                controller: _username,
              ), SizedBox(
                width: double.infinity,
                child: new RaisedButton(
                  onPressed: ()async{
                    await DbContact.updateUsername(User.email,User.username);
                    Navigator.pop(context);
                  },
                  color: Colors.black,
                  //highlightColor: Colors.white70,
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.grey)),
                  child: Text(
                    "Save",
                  ),
                ),
              ),
            ],
          ),
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.orange,Colors.red])),
        ),
      ),
      body: Scrollbar(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(20),
          child: ListView(
            children: <Widget>[
             Container(
               decoration: BoxDecoration(
                 color: Colors.black54,
                 borderRadius: BorderRadius.all(
                   Radius.circular(10.0)
                 ),
               ),
               padding: EdgeInsets.all(20),
               child: Row(
                 children: <Widget>[
                   Container(
                     child: User.photo!=null? CircleAvatar(backgroundImage: NetworkImage(User.photo),radius: 50,child: GestureDetector(
                       onTap: (){
                         Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailPhoto(photo: User.photo,)));
                       },
                     ),)
                         :CircleAvatar(backgroundColor: Colors.blueGrey,radius: 50,),
                   ),
                   Expanded(
                     child: Container(
                       padding: EdgeInsets.only(left: 30),
                       child: Column(
                         children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child:Text(Constants.myName,style: TextStyle(
                                fontSize: 25
                            ),),
                          ),Align(
                             alignment: Alignment.centerLeft,
                             child: User.email!=null?Text(User.email,style: TextStyle(
                                 fontSize: 15
                             ),):Text(""),
                           ),
                           Container(
                               padding: EdgeInsets.all(10),
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.end,
                                 children: <Widget>[
                                   GestureDetector(
                                     onTap: (){
                                       createBoxDialog();
                                     },
                                       child: CircleAvatar(child: Icon(FontAwesomeIcons.camera),backgroundColor: Colors.orange,)),
                                 ],
                               )
                           )
                         ],
                       ) ,
                     ),
                   ),
                 ],
               ),
             ),
              Container(height: 20,),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.all(
                      Radius.circular(10.0)
                  ),
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text("Account")
                      ],
                    ),
                    Container(height: 10,),
                    ListTile(
                      title: Text("Change Username"),
                      leading: Icon(Icons.account_circle),
                      subtitle: Container(
                        decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.grey))
                        ),
                      ),
                    ),
                    ListTile(
                      onTap: (){
                        Auth_Controller.changePass(User.email);
                        Fluttertoast.showToast(
                            msg: "Please Check Your Email",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 2,
                            backgroundColor: Colors.blue,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      },
                      title: Text("Change Password"),
                      leading: Icon(FontAwesomeIcons.lock),
                      subtitle: Container(
                        decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.grey))
                        ),
                      ),
                    ),
                    
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}