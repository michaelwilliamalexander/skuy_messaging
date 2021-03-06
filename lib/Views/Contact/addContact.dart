
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'SearchTile.dart';
import 'package:skuy_messaging/Firebase_Controller/Authentication.dart';
import 'package:skuy_messaging/Firebase_Controller/db_contact.dart';

class AddContact extends StatefulWidget{
  AddContactState createState()=> AddContactState();
}

class AddContactState extends State<AddContact>{
  FirebaseUser user;
  // ignore: non_constant_identifier_names
  String currentUser_uid;
  TextEditingController search = new TextEditingController();
  QuerySnapshot snapshot;
  QuerySnapshot currentUser;

  Widget searchList(){
    return snapshot !=null ? ListView.builder(
      itemCount: snapshot.documents.length,
        shrinkWrap: true,
        itemBuilder: (context,index){
          return SearchTile(
            email: snapshot.documents[index].data["email"],
            username: snapshot.documents[index].data["username"],
            uid: snapshot.documents[index].data["uid"],
            currentUID: currentUser_uid,
          );
        }
    ) : Container();
  }

  @override
  void initState(){
    // TODO: implement initState
    getCurrentUser();
    super.initState();
  }

  Future<void> getCurrentUser()async{
    user = (await Auth_Controller.authentication.currentUser());
    setState(() {
      currentUser_uid = user.uid;

    });
  }

  initiateSearch(){
    DbContact.searchUserName(search.text).then((value){
      setState(() {
        snapshot = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Contact"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.orange,Colors.red])),
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.black12,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "search username",
                        border: InputBorder.none
                      ),
                      controller: search,
                    ),
                  ),
                  GestureDetector(
                    onTap: initiateSearch(),
                    child: Container(
                      height: 40,
                        width: 40,
                        padding: EdgeInsets.all(10),
                        child: Icon(FontAwesomeIcons.search)
                    ),
                  )
                ],
              ),
            ),
            searchList(),
          ],
        ),
      )

    );
  }
}

