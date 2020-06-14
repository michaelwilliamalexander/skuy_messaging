import 'package:flutter/material.dart';

class SearchTile extends StatelessWidget{
  final String username;
  final String email;
  final String uid;
  SearchTile({this.username,this.email,this.uid});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(username),
              Text(email)
            ],
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(24)
            ),
            child: Text("add Contact",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16
              ),),
          ),
        ],
      ),
    );
  }

}