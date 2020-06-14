
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skuy_messaging/Firebase_Controller/Authentication.dart';

class ContactList extends StatefulWidget{
  ContactListState createState()=> ContactListState();
}

class ContactListState extends State<ContactList>{
  FirebaseUser user;
  String uid;

  @override
  void initState(){
    // TODO: implement initState
    getCurrentUser();
    super.initState();
  }

  Future<void> getCurrentUser()async{
    user = (await Auth_Controller.authentication.currentUser());
    setState(() {
      uid = user.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("listContact").where("user_uid",isEqualTo: uid ).snapshots(),
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