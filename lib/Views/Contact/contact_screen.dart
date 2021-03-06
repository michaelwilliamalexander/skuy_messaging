
import 'package:flutter/material.dart';
import 'package:skuy_messaging/Views/Contact/addContact.dart';
import 'package:skuy_messaging/Views/Contact/contact_list.dart';

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
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.orange,Colors.red])),
        ),
      ),
      body: ContactList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
        tooltip: "new Contact",
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => AddContact(),
          ),);
        },
      ),
    );
  }

}