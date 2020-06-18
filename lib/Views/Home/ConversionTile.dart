
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skuy_messaging/Firebase_Controller/db_contact.dart';
import 'package:skuy_messaging/Views/ChatRoom/chatScreen.dart';


// ignore: must_be_immutable
class ConversationTile extends StatefulWidget{
  final String friendUid;
  final String conversationId;
  String friendUsername;

  ConversationTile(this.friendUid, this.conversationId);
  ConversationState createState()=> ConversationState();
}

class ConversationState extends State<ConversationTile>{
  QuerySnapshot temp;
  @override
  void initState() {
    getUsernameFromUid().then((value){
      setState(() {
        widget.friendUsername = value.documents[0].data["username"];
        print("INI USERNAME ${widget.friendUsername}");
      });
    });
    super.initState();
  }


  getUsernameFromUid() async{
    print("INI UID ${widget.friendUid}");
    return await DbContact.searchUid(widget.friendUid);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ChatRoom(widget.conversationId, widget.friendUid, widget.friendUsername)
        ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
            children: [
              widget.friendUsername !=null?CircleAvatar(backgroundColor: Colors.blueGrey,child: Text("${widget.friendUsername.substring(0,1).toUpperCase()}",style: TextStyle(color: Colors.white),),)
                  :CircleAvatar(backgroundColor: Colors.blueGrey,),
              SizedBox(width: 8,),
              widget.friendUsername!=null?Text(
                widget.friendUsername,
                style: TextStyle(
                    fontSize: 17),
              ):Text("username"),
            ]
        ),
      ),
    );
  }

}