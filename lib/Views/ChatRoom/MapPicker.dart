import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:skuy_messaging/Firebase_Controller/db_contact.dart';
import 'package:skuy_messaging/helper/constants.dart';

class MapPicker extends StatefulWidget{
  String chatRoomId;
  String username;
  @override
  State<StatefulWidget> createState()=> _MapPickerState();
}

class _MapPickerState extends State<MapPicker>{
  final Set<Marker> _markers = {};
  LatLng position;

  Future getCurrentLocation() async{
    return await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  sendLocation(LatLng position){
      Map<String, dynamic> messageMap = {
        "message" : "${position.latitude}, ${position.longitude}",
        "sendBy" : Constants.myName,
        "to": widget.username,
        "isphoto": true,
        "isLocation": true,
        "time" : DateTime.now().millisecondsSinceEpoch
      };
      DbContact.addConversationMessages(widget.chatRoomId, messageMap);
  }

  @override
  void initState() {
    // TODO: implement initState
    getCurrentLocation().then((current){
      setState(() {
        position = LatLng(current.latitude, current.longitude);
        _markers.add(
            Marker(
                markerId: MarkerId("${position.latitude}, ${position.longitude}"),
                position: position,
                icon: BitmapDescriptor.defaultMarker
            )
        );
      });

    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Pick Location"),
      ),
      body: position != null ? GoogleMap(
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: position,
          zoom: 14,
        ),
        markers: _markers,
        onTap: (newPosition){
          setState(() {
            _markers.clear();
            _markers.add(
                Marker(
                    markerId: MarkerId("${newPosition.latitude}, ${newPosition.longitude}"),
                    icon: BitmapDescriptor.defaultMarker,
                    position: newPosition
                )
            );
            Fluttertoast.showToast(msg: "Long Press to choose location");
            print("LOKASI BARU ANDA ${_markers.elementAt(0).position}");
          });
        },
        // onLongPress: sendLocation(_markers.elementAt(0).position),
      ): Container(),

    );
  }

}