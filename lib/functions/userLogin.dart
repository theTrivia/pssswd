import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserLogin {
  performLogin(emailAddress, password) async {
    try {
      final loginCred = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);

      var db = FirebaseFirestore.instance;
      final credential =
          await db.collection("users").doc(loginCred.user!.uid).get();

      return {
        'loginStatus': 'login-success',
        'userCredential': credential.data()
      };
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return {'loginStatus': e.code, 'userCredential': {}};
    }
  }
}
