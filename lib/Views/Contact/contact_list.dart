
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skuy_messaging/Firebase_Controller/Authentication.dart';
import 'package:skuy_messaging/Firebase_Controller/db_contact.dart';
import 'package:skuy_messaging/Views/ChatRoom/chatScreen.dart';
import 'package:skuy_messaging/helper/constants.dart';
import 'package:skuy_messaging/helper/helperfunctions.dart';

class ContactList extends StatefulWidget{
  ContactListState createState()=> ContactListState();
}

class ContactListState extends State<ContactList>{
  FirebaseUser user;
  String uid;

  @override
  void initState(){
    // TODO: implement initState
    getUserInfo();
    getCurrentUser();
    super.initState();
  }

  Future<void> getCurrentUser()async{
    user = (await Auth_Controller.authentication.currentUser());
    setState(() {
      uid = user.uid;
    });
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUsername();
    setState(() {

    });
  }

  //buat chatroom dan query pesan
  createChatroomAndStartConversation({String username}){
    String chatRoomId = getChatRoomId(username, Constants.myName);
    List<String> users = [username, Constants.myName];
    Map<String, dynamic> conversationMap = {
      "users": users,
      "chatroomId": chatRoomId
    };

    DbContact.createChatRoom(chatRoomId, conversationMap);
    //Navigator.of(context).pushNamedAndRemoveUntil('/conversation', (Route<dynamic> route) => false);
    //Navigator.popAndPushNamed(context, '/conversation', arguments: chatRoomId);
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => ChatRoom(
        chatRoomId
      )
    ));
  }
  
  //untuk membuat id chatroom
  getChatRoomId(String a, String b){
    if(b.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0))
      return "$b\_$a";
    else
      return "$a\_$b";
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("listContact").where("user_uid",isEqualTo: uid ).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        Widget widget;
        if(snapshot.hasData){
          var data = snapshot.data.documents;
          widget = ListView.builder(
            itemCount:  data.length,
              itemBuilder: (context,index){
              return Container(
                child: Dismissible(
                  key: UniqueKey(),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) async {
                    await Firestore.instance.runTransaction((Transaction myTransaction) async {
                      await myTransaction.delete(snapshot.data.documents[index].reference);
                    });
                    setState(() {});
                  },
                  child: ListTile(
                    title: Text(data[index]["username"]),
                    subtitle: Text(data[index]["email"]),
                    onTap: (){
                      createChatroomAndStartConversation(
                        username: data[index]["username"]
                      );
                    },
                  ),
                ),
              );
          }
          );
        }else if(snapshot.hasError){
          widget = Text("ERROR");
        }else{
        widget = SizedBox(
              child: CircularProgressIndicator(),
              width: 50,
              height: 50
          );
        }
        return widget;
      },
    );
  }

}