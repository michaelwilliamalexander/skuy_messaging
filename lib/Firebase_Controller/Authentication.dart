
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:skuy_messaging/Firebase_Controller/db_contact.dart';

class Auth_Controller{
  static FirebaseAuth authentication = FirebaseAuth.instance;

  static changePass(String email){
    authentication.sendPasswordResetEmail(email: email);
  }

  static Future<bool> emailSignIn(String mail,String pass) async{
    FirebaseUser user = (await authentication.signInWithEmailAndPassword(email: mail, password: pass)).user;
    if(user.isEmailVerified){
      return true;
    }else{
      return false;
    }
  }

  static  Future<void> googleSignIn() async{
    GoogleSignInAccount acc =  await GoogleSignIn().signIn();
    GoogleSignInAuthentication auth = await acc.authentication;
    AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: auth.idToken ,
      accessToken: auth.accessToken,
    );
    FirebaseUser user = (await authentication.signInWithCredential(credential)).user;
    Map<String,String> userMap = {
      "username":user.displayName,
      "email": user.email,
      "uid":user.uid,
      "tokenNotif":" ",
      "photo":" "
    };
    DbContact.addUserInfo(userMap);
  }

  static Future<void> logOut()async{
    await authentication.signOut();
    await GoogleSignIn().signOut();
  }

  static Future<void> signUpEmail(String mail, String pass, String nama)async{
    FirebaseUser user = (await authentication.createUserWithEmailAndPassword(email: mail, password: pass)).user;
    Map<String,String> userMap = {
      "username":nama,
      "email": mail,
      "uid":user.uid,
      "tokenNotif":" ",
      "photo":" "
    };
    try {
      await user.sendEmailVerification();
      DbContact.addUserInfo(userMap);
    } catch (e) {
      print("An error occured while trying to send email       verification");
      print(e.message);
    }
  }
}