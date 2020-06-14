
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ContactList extends StatefulWidget{
  ContactListState createState()=> ContactListState();
}

class ContactListState extends State<ContactList>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("listContact").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        Widget widget;
        if(snapshot.hasData){
          var data = snapshot.data.documents;
          widget = ListView.builder(
            itemCount:  data.length,
              itemBuilder: (context,index){
              return Container(
                child: Dismissible(
                  key: UniqueKey(),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) async {
                    await Firestore.instance.runTransaction((Transaction myTransaction) async {
                      await myTransaction.delete(snapshot.data.documents[index].reference);
                    });
                    setState(() {});
                  },
                  child: ListTile(
                    title: Text(data[index]["username"]),
                    subtitle: Text(data[index]["email"]),
                  ),
                ),
              );
          }
          );
        }else if(snapshot.hasError){
          widget = Text("ERROR");
        }else{
        widget = SizedBox(
              child: CircularProgressIndicator(),
              width: 50,
              height: 50
          );
        }
        return widget;
      },
    );
  }

}