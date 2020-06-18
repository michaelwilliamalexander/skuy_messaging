
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skuy_messaging/Firebase_Controller/db_contact.dart';
import 'package:skuy_messaging/Views/ChatRoom/chatScreen.dart';
import 'package:skuy_messaging/Views/model/friend.dart';
import 'package:skuy_messaging/Views/model/user.dart';

class ConversationTile extends StatefulWidget{
  final String uid;
  final String conversationId;
  String username;

  ConversationTile(this.uid, this.conversationId);
  ConversationState createState()=> ConversationState();
}

class ConversationState extends State<ConversationTile>{
  QuerySnapshot temp;
  @override
  void initState() {
    //getFriendData();
    getUsernameFromUid().then((value){
      setState(() {
        widget.username = value.documents[0].data["username"];
      });
    });
    super.initState();
  }

  getFriendData()async{
    DbContact.getConversations(User.uid).then((value){
      Stream sp = value;
      sp.forEach((element) {
        QuerySnapshot s = element;
        for(int i=0;i<s.documents.length;i++){
          String tempt = s.documents[i].data["chatroomId"]
              .toString()
              .replaceAll("_", "")
              .replaceAll(User.uid,"");
          DbContact.searchUid(tempt).then((onvalue){
            QuerySnapshot snap = onvalue;
            for(int j=0;j<snap.documents.length;j++){
              setState(() {
                widget.username = snap.documents[j].data["username"];
              });
              print(widget.username);
            }
          });
        }
      });
    });
  }

  Future getUsernameFromUid() async{
    print("INI UID ${widget.uid}");
    return temp = await DbContact.searchUid(widget.uid);

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ChatRoom(widget.conversationId, widget.uid, widget.username)
        ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
            children: [
              widget.username !=null?CircleAvatar(backgroundColor: Colors.blueGrey,child: Text("${widget.username.substring(0,1).toUpperCase()}",style: TextStyle(color: Colors.white),),)
                  :CircleAvatar(backgroundColor: Colors.blueGrey,),
              SizedBox(width: 8,),
              widget.username !=null?Text(
                widget.username,
                style: TextStyle(
                    fontSize: 17),
              ):Text(""),
            ]
        ),
      ),
    );
  }

}