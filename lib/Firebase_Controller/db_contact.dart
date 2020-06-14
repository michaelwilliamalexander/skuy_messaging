
import 'package:cloud_firestore/cloud_firestore.dart';

class dbContact{

  static searchUserName(String username) async{
    return await Firestore.instance
        .collection("users")
        .where('username', isEqualTo: username)
        .getDocuments();
  }

  static searchEmail(String email) async{
    return await Firestore.instance
        .collection("users")
        .where('email', isEqualTo: email)
        .getDocuments();
  }

  static Future<void> addUserInfo(userData) async {
    Firestore.instance.collection("users").add(userData).catchError((e) {
      print(e.toString());
    });
  }

  static Future<void> addContact(userData)async{
    Firestore.instance.collection("listContact").add(userData);
  }
}