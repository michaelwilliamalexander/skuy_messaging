import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:skuy_messaging/Firebase_Controller/db_contact.dart';
import 'package:skuy_messaging/Views/ChatRoom/DetailPhoto.dart';

class MessageTile extends StatefulWidget{
  final String message;
  final bool isPicture;
  final bool isSendByMe;
  final bool isLocation;

  MessageTile(this.message, this.isPicture, this.isLocation, this.isSendByMe);
  MessageTileState createState()=> MessageTileState();
}

class MessageTileState extends State<MessageTile>{
  String image;
  final Set<Marker> _markers = {};
  LatLng position;

  @override
  void initState(){
    // TODO: implement initState
    getImage();
    getLocation().then((temp){
      setState(() {
        position = temp;
        _markers.add(
            Marker(
                markerId: MarkerId(widget.message),
                position: position,
                icon: BitmapDescriptor.defaultMarker
            )
        );
      });
    });
    super.initState();
  }

  Future getLocation() async{
    if(widget.isLocation){
      List<double> latlng = widget.message.split(", ").cast<double>();
      position = LatLng(latlng[0], latlng[1]);
    }
  }

  void getImage()async{
    String tempt = await DbContact.downloadImage(widget.message);
    setState(() {
      image = tempt;
    });
  }

  Widget getValue(bool value, String message){
    if(value){
      return image!=null?
      GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailPhoto(photo: image,)));
        },
        child: Image.network(image,
          width: 300,
          height: 300,
          fit: BoxFit.cover,
        ),
      ) : Text("");
    }else{
      return Text(
        message,
        style: TextStyle(
            color: Colors.white,
            fontSize: 15
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return !widget.isLocation ? Container(
      padding: EdgeInsets.only(left: widget.isSendByMe ? 20 : 24 , right: widget.isSendByMe ? 24 : 20),
      margin: EdgeInsets.symmetric(vertical: 6),
      width: MediaQuery.of(context).size.width,
      alignment: widget.isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
            color: widget.isSendByMe ? Colors.blueAccent : Colors.blueGrey,
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
        child: getValue(widget.isPicture, widget.message)
      ),
    ) : Container(
          padding: EdgeInsets.only(left: widget.isSendByMe ? 20 : 24 , right: widget.isSendByMe ? 24 : 20),
          margin: EdgeInsets.symmetric(vertical: 6),
          width: MediaQuery.of(context).size.width,
          alignment: widget.isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
                color: widget.isSendByMe ? Colors.blueAccent : Colors.blueGrey,
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
            child: position != null ? GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: position,
                zoom: 14,
              ),
              markers: _markers,
            ) : Container(),
        )
    );
  }

}