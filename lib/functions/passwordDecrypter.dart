import 'package:encrypt/encrypt.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_string_encryption/flutter_string_encryption.dart';

class PasswordDecrypter {
  // getDecryptedPassword(String encryptedPassword, String salt) async {
  //   late PlatformStringCryptor cryptor;

  //   String decryptedS = 'null';
  //   try {
  //     cryptor = new PlatformStringCryptor();

  //     String decryptedS = await cryptor.decrypt(encryptedPassword, salt);
  //     // print(decryptedS);
  //     return decryptedS;
  //   } on MacMismatchException {
  //     print('Some Error Occured');
  //   }
  // }

  getDecryptedPassword(encpss, randForKeyToStore, randForIV, masterPasword) {
    final iv = IV.fromUtf8(randForIV);
    final randForKey = randForKeyToStore + masterPasword;
    final calculatedKey = Key.fromUtf8(randForKey);

    final e = Encrypter(AES(calculatedKey, mode: AESMode.cbc));
    final decryptedPassword = e.decrypt64(encpss, iv: iv);
    return decryptedPassword;
  }
}
