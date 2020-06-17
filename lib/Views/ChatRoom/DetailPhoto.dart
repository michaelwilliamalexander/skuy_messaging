
import 'package:flutter/material.dart';

class DetailPhoto extends StatefulWidget{
  String photo;
  DetailPhoto({this.photo});
  DetailPhotoState createState()=>DetailPhotoState();
}

class DetailPhotoState extends State<DetailPhoto>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Image.network(widget.photo),
      ),
    );
  }

}