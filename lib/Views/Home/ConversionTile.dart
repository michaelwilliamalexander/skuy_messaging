

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skuy_messaging/Firebase_Controller/db_contact.dart';
import 'package:skuy_messaging/Views/ChatRoom/chatScreen.dart';
import 'package:skuy_messaging/Views/model/friend.dart';

class ConversationTile extends StatefulWidget{
  final String username;
  final String conversationId;
  final String nickName;

  ConversationTile(this.username, this.conversationId,this.nickName);
  ConversationState createState()=> ConversationState();
}

class ConversationState extends State<ConversationTile>{

  Future<void> initiateFriend()async{
    DbContact.searchUid(widget.username).then((value)async{
      QuerySnapshot sp = value;
      for(int i=0;i<sp.documents.length;i++){
        String tempt = sp.documents[i].data["photo"];
        if(!tempt.isEmpty){
          String coun = await DbContact.downloadImage(tempt);
          setState(() {
            Friend.photo = coun;
          });
        }
        setState(() {
          Friend.username = sp.documents[i].data["username"];
          Friend.email = sp.documents[i].data["email"];
          Friend.uid = sp.documents[i].data["uid"];
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    initiateFriend();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ChatRoom(widget.conversationId,widget.username)
        ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(40)
                ),
                child: Text("${Friend.username.substring(0,1).toUpperCase()}"),
              ),
              SizedBox(width: 8,),
              Text(
                Friend.username,
                style: TextStyle(

                    fontSize: 17
                ),
              )
            ]
        ),
      ),
    );
  }

}