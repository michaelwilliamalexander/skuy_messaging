import 'dart:io';

import 'package:flutter/material.dart';
import 'package:skuy_messaging/Firebase_Controller/db_contact.dart';

class MessageTile extends StatefulWidget{
  final String message;
  final bool isPicture;
  final bool isSendByMe;

  MessageTile(this.message,this.isPicture, this.isSendByMe);
  MessageTileState createState()=> MessageTileState();
}

class MessageTileState extends State<MessageTile>{
  String image;
  @override
  void initState(){
    // TODO: implement initState
    getImage();
    super.initState();
  }

  void getImage()async{
    String tempt = await DbContact.downloadImage(widget.message);
    setState(() {
      image = tempt;
    });
  }

  Widget getValue(bool value, String message){
    if(value){
      return image!=null? Image.network(image,width: 300,height: 300,):Text("");
    }else{
      return Text(
        message,
        style: TextStyle(
            color: Colors.black,
            fontSize: 15
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return widget.isPicture ? Container(
      margin: EdgeInsets.only(bottom: widget.isSendByMe ? 20.0 : 10.0, right: 10.0),
      child: getValue(widget.isPicture, widget.message),
    ) : Container(
      padding: EdgeInsets.only(left: widget.isSendByMe ? 20 : 24 , right: widget.isSendByMe ? 24 : 20),
      margin: EdgeInsets.symmetric(vertical: 6),
      width: MediaQuery.of(context).size.width,
      alignment: widget.isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: widget.isSendByMe ? [
                  Colors.red,
                  Colors.orange
                ] : [
                  Colors.red,
                  Colors.orange
                ]
            ),
            borderRadius: widget.isSendByMe ?
            BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
                bottomLeft: Radius.circular(25)
            ) :
            BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
                bottomRight: Radius.circular(25)
            )
        ),
        child: Text(
          widget.message,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 15
          ),
        ),
      ),
    );
  }

}