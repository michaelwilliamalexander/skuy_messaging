
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skuy_messaging/Views/ChatRoom/chatScreen.dart';
import 'package:skuy_messaging/Views/Home/ConversionTile.dart';
import 'package:skuy_messaging/Views/model/friend.dart';
import 'package:skuy_messaging/Views/model/user.dart';
import 'package:skuy_messaging/helper/constants.dart';
import 'package:skuy_messaging/Firebase_Controller/db_contact.dart';
import 'package:skuy_messaging/helper/helperfunctions.dart';

class HomeScreen extends StatefulWidget{
  HomeScreenState createState()=> HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>{
  Stream conversationStream;

  Widget conversationList(){
    return StreamBuilder(
      stream: conversationStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index){
            String data = snapshot.data.documents[index].data["chatroomId"]
                .toString()
                .replaceAll("_", "")
                .replaceAll(User.uid
              ,snapshot.data.documents[index].data["chatroomId"]);
            String tempt;
            DbContact.searchUid(data).then((value)async{
              QuerySnapshot sp = value;
              for(int i=0;i<sp.documents.length;i++){
                setState(() {
                  Friend.username = sp.documents[0].data["username"];
                });
              }
            });
                return Container(
                  child: Dismissible(
                    key: UniqueKey(),
                    background: Container(color: Colors.red),
                    onDismissed: (direction) async {
                    },
                    child: ConversationTile(
                        snapshot.data.documents[index].data["chatroomId"]
                            .toString()
                            .replaceAll("_", "")
                            .replaceAll(User.uid                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     , ""),
                        snapshot.data.documents[index].data["chatroomId"],Friend.username
                    ),
                  ),
                );
              },
        ): Container();
      },
    );
  }

  @override
  void initState(){
    // TODO: implement initState
    getUserInfo();
    super.initState();
  }

  getUserInfo() async{
    Constants.myName = await HelperFunctions.getUsername();
    DbContact.getConversations(User.uid).then((value){
      conversationStream = value;
    });
    setState((){

    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: conversationList(),
    );
  }
}
//class ConversationTile extends StatelessWidget{
//  final String username;
//  final String conversationId;
//
//  ConversationTile(this.username, this.conversationId);
//  @override
//  Widget build(BuildContext context) {
//    // TODO: implement build
//    return GestureDetector(
//      onTap: (){
//        Navigator.push(context, MaterialPageRoute(
//          builder: (context) => ChatRoom(conversationId,username)
//        ));
//      },
//      child: Container(
//        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//        child: Row(
//            children: [
//              Container(
//                height: 40,
//                width: 40,
//                alignment: Alignment.center,
//                decoration: BoxDecoration(
//                    color: Colors.grey,
//                    borderRadius: BorderRadius.circular(40)
//                ),
//                child: Text("${username.substring(0,1).toUpperCase()}"),
//              ),
//              SizedBox(width: 8,),
//              Text(
//                username,
//                style: TextStyle(
//
//                    fontSize: 17
//                ),
//              )
//            ]
//        ),
//      ),
//    );
//  }
//}