
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
                return Container(
                  child: Dismissible(
                    key: UniqueKey(),
                    background: Container(color: Colors.red),
                    onDismissed: (direction) async {
                    },
                    child:ConversationTile(
                        snapshot.data.documents[index].data["chatroomId"]
                            .toString()
                            .replaceAll("_", "")
                            .replaceAll(User.uid                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     , ""),
                        snapshot.data.documents[index].data["chatroomId"],
                    )
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
    setState((){});
  }
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: conversationStream!=null?conversationList():Text(" "),
    );
  }
}