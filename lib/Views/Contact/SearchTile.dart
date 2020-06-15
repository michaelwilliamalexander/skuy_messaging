import 'package:flutter/material.dart';
import 'package:skuy_messaging/Firebase_Controller/db_contact.dart';

class SearchTile extends StatelessWidget{
  final String username;
  final String email;
  final String uid;
  final String currentUID;
  SearchTile({this.username,this.email,this.uid,this.currentUID});

  void addContact(){
    Map<String,String> userMap = {
      "username":username,
      "email": email,
      "uid":uid,
      "user_uid":currentUID,
    };
    DbContact.addContact(userMap);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
      return uid!=currentUID ? Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(username),
                Text(email)
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: (){
                addContact();
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(24)
                ),
                child: Text("add Contact",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16
                  ),),
              ),
            ),
          ],
        ),
      ) : Container();

  }

}