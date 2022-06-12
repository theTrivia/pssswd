import 'package:firebase_auth/firebase_auth.dart';
import '../functions/app_logger.dart';

class UserSignup {
  Future performSignup(emailAddress, password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      return {
        'isLoginSuccess': 'login-success',
        'userCredential': credential,
      };
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        AppLogger.printErrorLog('weak password');
      } else if (e.code == 'email-already-in-use') {
        AppLogger.printErrorLog('email already in use');
      }
      return e.code;
    } catch (e) {
      print(e);
    }
  }
}
