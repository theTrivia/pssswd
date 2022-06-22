import 'dart:convert';
import 'package:crypto/crypto.dart';

import './app_logger.dart';

class MasterPasswordHash {
  String hashMasterPassword(String masterPassword) {
    try {
      var bytes = utf8.encode(masterPassword);
      var digest = sha256.convert(bytes);

      return digest.toString();
    } on Exception {
      throw AppLogger.printErrorLog('Exception occured');
    } catch (e) {
      throw AppLogger.printErrorLog('Error occured', error: e);
    }
  }

  bool checkIfMasterPasswordValid(masterPassword, hashedMasterPassword) {
    var bytes = utf8.encode(masterPassword);
    var digest = sha256.convert(bytes);

    if (digest.toString() == hashedMasterPassword.toString()) {
      return true;
    } else {
      return false;
    }
  }
}
