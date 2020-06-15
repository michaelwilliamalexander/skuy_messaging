
import 'package:cloud_firestore/cloud_firestore.dart';

class DbContact{

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

  static Future<void> createChatRoom(String conversationId, conversationMap)async{
    Firestore.instance.collection("Conversation")
        .document(conversationId).setData(conversationMap).catchError((e){
          print(e.toString());
    });
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
        .orderBy("time", descending: false)
        .snapshots();
  }

  static getConversations(String username) async{
    return  Firestore.instance.collection("Conversation")
        .where("users", arrayContains: username)
        .snapshots();
  }
}