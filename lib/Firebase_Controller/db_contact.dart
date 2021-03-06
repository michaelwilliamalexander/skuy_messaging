
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DbContact{

  static searchUserName(String username) async{
    return await Firestore.instance
        .collection("users")
        .where('username', isEqualTo: username)
        .getDocuments();
  }

  static searchUid(String uid) async{
    return await Firestore.instance
        .collection("users")
        .where('uid', isEqualTo: uid)
        .getDocuments();
  }

  static updateUsername(String email, String username){
    Firestore.instance.collection('users').document(email).updateData({"username":username});
  }

  static updatePhoto(String email,String photo)async{
    Firestore.instance.collection('users').document(email).updateData({"photo":photo});
  }

  static searchEmail(String email) async{
    return await Firestore.instance
        .collection("users")
        .where('email', isEqualTo: email)
        .getDocuments();
  }

  static Future<void> addUserInfo(userData) async {
    Firestore.instance.collection("users").document(userData["email"]).setData(userData).catchError((e) {
      print(e.toString());
    });
  }

  static Future<void> addContact(userData)async{
    Firestore.instance.collection("listContact").add(userData);
  }

  static Future<void> createChatRoom(String conversationId, conversationMap)async{
    Firestore.instance.collection("Conversation")
        .document(conversationId).setData(conversationMap).catchError((e){
          print(e.toString());
    });
  }

  static uploadImage(String path, File file)async{
    StorageReference sr = await FirebaseStorage.instance.ref().child(path);
    await sr.putFile(file);
  }

  static Future<String>downloadImage(String path)async{
    StorageReference sr = await FirebaseStorage.instance.ref().child(path);
    String download  = await sr.getDownloadURL();
    return download;
  }

  static addConversationMessages(String chatRoomId, messageMap)async{
    Firestore.instance.collection("Conversation")
        .document(chatRoomId)
        .collection("chats")
        .add(messageMap).catchError((e){print(e.toString());});
  }

  static getConversationMessages(String chatRoomId)async{
    return Firestore.instance.collection("Conversation")
        .document(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: true)
        .snapshots();
  }

  static getConversations(String username) async{
    return  Firestore.instance.collection("Conversation")
        .where("users", arrayContains: username)
        .snapshots();
  }

}