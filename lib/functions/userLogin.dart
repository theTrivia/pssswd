import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../functions/app_logger.dart';

class UserLogin {
  performLogin(emailAddress, password) async {
    var userCreds;
    try {
      final loginCred = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);

      var db = FirebaseFirestore.instance;
      final credential =
          await db.collection("users").doc(loginCred.user!.uid).get();
      userCreds = await credential.data();
      if (userCreds['isAccountBlocked'] == true) {
        return {'loginStatus': 'login-block', 'userCredential': {}};
      } else {
        return {
          'loginStatus': 'login-success',
          'userCredential': credential.data()
        };
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        AppLogger.printErrorLog('user not found');
      } else if (e.code == 'wrong-password') {
        AppLogger.printErrorLog('wrong password');
      }
      return {'loginStatus': e.code, 'userCredential': {}};
    }
  }
}
