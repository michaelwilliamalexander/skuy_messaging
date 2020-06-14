
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skuy_messaging/Contact/addContact.dart';

class ContactScreen extends StatefulWidget{
  ContactScreenState createState()=> ContactScreenState();
}

class ContactScreenState extends State<ContactScreen>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              FontAwesomeIcons.search,
              color: Colors.white,
            ),
            onPressed: () {

            },
          )
        ],
      ),
      body: Center(
        child: Text("sudah sampai dicontact"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: "new Contact",
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => addContact(),
          ),);
        },
      ),
    );
  }

}