
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skuy_messaging/Firebase_Controller/db_contact.dart';
import 'package:skuy_messaging/Views/ChatRoom/chatScreen.dart';
import 'package:skuy_messaging/Views/model/friend.dart';
import 'package:skuy_messaging/Views/model/user.dart';

class ConversationTile extends StatefulWidget{
  final String username;
  final String conversationId;
  final String user;

  ConversationTile(this.username, this.conversationId,this.user);
  ConversationState createState()=> ConversationState();
}

class ConversationState extends State<ConversationTile>{

  @override
  void initState() {
//    getFriendData();
    super.initState();
  }

  getFriendData()async{
    DbContact.getConversations(User.uid).then((value){
      Stream sp = value;
      String tempt;
      sp.forEach((element) {
        QuerySnapshot s = element;

        for(int i=0;i<s.documents.length;i++){
           tempt= s.documents[i].data["chatroomId"]
              .toString()
              .replaceAll("_", "")
              .replaceAll(User.uid,"");
          DbContact.searchUid(tempt).then((onvalue){
            QuerySnapshot snap = onvalue;
            for(int j=0;j<snap.documents.length;j++){
              setState(() {
                if(snap.documents[j].data["uid"]==widget.username){
                  Friend.username = snap.documents[j].data["username"];
                }
              });
            }
          });
        }
      });
    });
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
              Friend.username!=null?CircleAvatar(backgroundColor: Colors.blueGrey,child: Text("${Friend.username.substring(0,1).toUpperCase()}",style: TextStyle(color: Colors.white),),)
                  :CircleAvatar(backgroundColor: Colors.blueGrey,),
              SizedBox(width: 8,),
              widget.user!=null?Text(
                widget.user,
                style: TextStyle(
                    fontSize: 17),
              ):Text(""),
            ]
        ),
      ),
    );
  }

}