
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skuy_messaging/Firebase_Controller/db_contact.dart';
import 'package:skuy_messaging/Views/ChatRoom/MapPicker.dart';
import 'package:skuy_messaging/Views/ChatRoom/MessageTIle.dart';
import 'package:skuy_messaging/helper/constants.dart';

class ChatRoom extends StatefulWidget{
  String chatRoomId;
  String username;
  ChatRoom(this.chatRoomId,this.username);

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
            reverse: true,
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
    String tempt = "Skuy"+"${DateTime.now().millisecondsSinceEpoch}";
    await DbContact.uploadImage(tempt, galeryFile);
    setState(() {
      images = tempt;
    });
  }

  sendMessage(){
    if(!messageController.text.trim().isEmpty){
      Map<String, dynamic> messageMap = {
        "message" : messageController.text,
        "sendBy" : Constants.myName,
        "to":widget.username,
        "isphoto": false,
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
        "to":widget.username,
        "isphoto": true,
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
                      sendImage();
                      Navigator.pop(context);
                    },
                    //color: Colors.black,
                    //highlightColor: Colors.white70,
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.grey)),
                    child: Text("Camera",),
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
                    //color: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.grey)),
                    child: Text("Gallery",),
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
        title: Text(widget.username),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.orange,Colors.red])),
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 70),
              child: MessageList(),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 70,
                color: Color(0x54FFFFFF),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => MapPicker()));
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        padding: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(40)
                        ),
                        child: Icon(Icons.add_location),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        createBoxDialog(context);
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        padding: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(40)
                        ),
                        child: Icon(Icons.photo),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                          fillColor: Colors.grey,
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
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(40)
                        ),

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
