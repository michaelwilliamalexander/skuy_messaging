
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skuy_messaging/Firebase_Controller/Authentication.dart';
import 'package:skuy_messaging/Firebase_Controller/db_contact.dart';
import 'package:skuy_messaging/Views/ChatRoom/DetailPhoto.dart';
import 'package:skuy_messaging/helper/constants.dart';
import 'package:skuy_messaging/helper/helperfunctions.dart';

class Setting extends StatefulWidget{
  SettingState createState()=> SettingState();
}

class SettingState extends State<Setting>{
  String image;
  String email;
  String nama = "Aku";
  bool edit = false;
  @override
  void initState(){
    getImage();
    super.initState();
  }

  Future pickPictureFromGallery() async{
    var galeryFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    String tempt = "Skuy"+"${DateTime.now().millisecondsSinceEpoch}";
    await DbContact.uploadImage(tempt, galeryFile);
    setState(() {
      image = tempt;
    });
  }

  Future pickPictureUsingPhoto() async{
    var galeryFile = await ImagePicker.pickImage(source: ImageSource.camera);
    String tempt = "Skuy"+"${DateTime.now().millisecondsSinceEpoch}";
    await DbContact.uploadImage(tempt, galeryFile);
    setState(() {
      image = tempt;
    });
  }

  Future<String> createBoxDialog(BuildContext context) {
    TextEditingController newCategory = TextEditingController();
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

  void getImage()async{
    String tempt = await DbContact.downloadImage("Skuy1592308940792");
    FirebaseUser user = (await Auth_Controller.authentication.currentUser());
    setState(() {
      image = tempt;
      email = user.email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.orange,Colors.red])),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(20),
        child: Column(
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
                   child: image!=null? CircleAvatar(backgroundImage: NetworkImage(image),radius: 50,child: GestureDetector(
                     onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailPhoto(photo: image,)));
                     },
                   ),)
                       :CircleAvatar(backgroundColor: Colors.blueGrey,radius: 50,child: GestureDetector(
                     onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailPhoto(photo: image,)));
                     },
                   ),),
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
                           child: email!=null?Text(email,style: TextStyle(
                               fontSize: 15
                           ),):Text(""),
                         ),
                         Container(
                             padding: EdgeInsets.all(10),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.end,
                               children: <Widget>[
                                 CircleAvatar(child: Icon(FontAwesomeIcons.camera),backgroundColor: Colors.orange,),
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

          ],
        ),
      ),
    );
  }

}