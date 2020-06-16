import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skuy_messaging/Firebase_Controller/db_contact.dart';
import 'package:skuy_messaging/Views/ChatRoom/MessageTIle.dart';
import 'package:skuy_messaging/helper/constants.dart';

class ChatRoom extends StatefulWidget{
  String chatRoomId;
  ChatRoom(this.chatRoomId);

  @override
  State<StatefulWidget> createState()=> _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom>{
  String images = "IMAGE";
  TextEditingController messageController = new TextEditingController();
  Stream messagesStream;

  Widget MessageList(){
    return StreamBuilder(
      stream: messagesStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){
              return MessageTile(snapshot.data.documents[index].data["message"],
                  snapshot.data.documents[index].data["isphoto"],
                snapshot.data.documents[index].data["sendBy"] == Constants.myName
              );
            }) : Container();
      },
    );
  }



  Future pickPictureFromGallery() async{
    var galeryFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    String tempt = "Skuy"+"${DateTime.now().millisecondsSinceEpoch}";
    await DbContact.uploadImage(tempt, galeryFile);
    setState(() {
      images = tempt;
    });
  }

  Future pickPictureUsingPhoto() async{
    var galeryFile = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      images = base64Encode(galeryFile.readAsBytesSync());
    });
  }

  sendMessage(){
    if(!messageController.text.trim().isEmpty){
      Map<String, dynamic> messageMap = {
        "message" : messageController.text,
        "sendBy" : Constants.myName,
        "isphoto":false,
        "time" : DateTime.now().millisecondsSinceEpoch
      };
      DbContact.addConversationMessages(widget.chatRoomId, messageMap);
    }
  }

  sendImage(){
    if(images.isNotEmpty){
      Map<String, dynamic> messageMap = {
        "message" : images,
        "sendBy" : Constants.myName,
        "isphoto":true,
        "time" : DateTime.now().millisecondsSinceEpoch
      };
      DbContact.addConversationMessages(widget.chatRoomId, messageMap);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    DbContact.getConversationMessages(widget.chatRoomId).then((value){
      setState(() {
        messagesStream = value;
      });
    });
    super.initState();
  
  }

  Future<String> createBoxDialog(BuildContext context) {
    TextEditingController newCategory = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Photos"),
            content: Wrap(
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  child: new RaisedButton(
                    onPressed: ()async{
                      await pickPictureUsingPhoto();
                      sendImage();
                      Navigator.pop(context);
                    },
                    color: Colors.white,
                    highlightColor: Colors.white70,
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
                        sendImage();
                        Navigator.pop(context);
                      },
                    color: Colors.white,
                    highlightColor: Colors.white70,
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


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("SKUY"),
      ),
      body: Container(
        child: Stack(
          children: [
            MessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Color(0x54FFFFFF),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        createBoxDialog(context);
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  const Color(0x36FFFFFF),
                                  const Color(0x0FFFFFFF)
                                ]
                            ),
                            borderRadius: BorderRadius.circular(40)
                        ),
                        child: Icon(Icons.photo),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                          hintText: "Message. . .",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        sendMessage();
                        messageController.clear();
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0x36FFFFFF),
                              const Color(0x0FFFFFFF)
                            ]
                          ),
                          borderRadius: BorderRadius.circular(40)
                        ),
                        padding: EdgeInsets.all(12),
                        child: Icon(FontAwesomeIcons.angleRight),
                      ),
                    )
                  ],
                ),
              ),
            )],
        ),
      ),
    );
  }
}
