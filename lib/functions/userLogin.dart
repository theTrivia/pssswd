import 'package:firebase_auth/firebase_auth.dart';
import 'package:localstorage/localstorage.dart';
import 'package:localstorage/localstorage.dart';
import 'package:pssswd/models/passwd.dart';

class UserLogin {
  performLogin(emailAddress, password) async {
    try {
      // print(emailAddress);
      // print(password);
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
      // print(credential);
      return 'login-success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return e.code;
    }
  }
}
