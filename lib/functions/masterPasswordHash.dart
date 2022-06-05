import 'dart:convert';
import 'package:crypto/crypto.dart';

class MasterPasswordHash {
  String hashMasterPassword(String masterPassword) {
    var bytes = utf8.encode(masterPassword);
    var digest = sha256.convert(bytes);

    return digest.toString();
  }

  bool checkIfMasterPasswordValid(masterPassword, hashedMasterPassword) {
    var bytes = utf8.encode(masterPassword);
    var digest = sha256.convert(bytes);

    // print(digest);

    if (digest.toString() == hashedMasterPassword.toString()) {
      return true;
    } else {
      return false;
    }
  }
}
