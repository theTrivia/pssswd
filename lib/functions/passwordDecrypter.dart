import 'package:flutter/material.dart';
import 'package:flutter_string_encryption/flutter_string_encryption.dart';

class PasswordDecrypter {
  getDecryptedPassword(String encryptedPassword, String key) async {
    late PlatformStringCryptor cryptor;

    String decryptedS = 'null';
    try {
      cryptor = new PlatformStringCryptor();

      String decryptedS = await cryptor.decrypt(encryptedPassword, key);
      // print(decryptedS);
      return decryptedS;
    } on MacMismatchException {
      print('Some Error Occured');
    }
  }
}
