
import 'package:flutter/material.dart';

class about extends StatefulWidget{
  @override
  aboutState createState()=>aboutState();
}

class aboutState extends State<about>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.orange,Colors.red])),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Text("created by : ",style: TextStyle(fontSize: 10),),
              Container(height: 10,),
              Text("Michael William Alexander"),
              Text("Nathaniel Alvin Pratama"),
            ],
          ),
        ),
      ),
    );
  }

}
