
import 'package:firebase_auth/firebase_auth.dart';

class Auth_Controller{
  static FirebaseAuth authentication = FirebaseAuth.instance;

  static Future<bool> emailSignIn(String mail,String pass) async{
    FirebaseUser user = (await authentication.signInWithEmailAndPassword(email: mail, password: pass)).user;
    if(user.isEmailVerified){
      return true;
    }else{
      return false;
    }
  }

  static Future<void> logOut()async{
    await authentication.signOut();
  }

  static Future<void> signUpEmail(String mail, String pass)async{
    FirebaseUser user = (await authentication.createUserWithEmailAndPassword(email: mail, password: pass)).user;
    try {
      await user.sendEmailVerification();
    } catch (e) {
      print("An error occured while trying to send email       verification");
      print(e.message);
    }
  }
}