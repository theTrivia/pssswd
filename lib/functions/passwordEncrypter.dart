import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:flutter_string_encryption/flutter_string_encryption.dart';
import "package:pointycastle/export.dart";

class PasswordEnrypter {
  //key should be generated upon user creation.
  //each user should have unique key
  //for now, lets make it constant.

  // final key = Key.fromUtf8("4zTp0jEOeZsT/kfZCAumxg==");
  // final iv = IV.fromLength(16);

  // String getPassword(String s) {
  //   return s + 'ffff';
  // }

  //5 digit user password should be sent as a parameter at the time of launching the app
  encryptPassword(String rawPd) async {
    late PlatformStringCryptor cryptor;
    cryptor = new PlatformStringCryptor();
    String salt = await cryptor.generateSalt();

    //5 digit user password should be sent as a parameter at the time of launching the app
    String newSalt = 'ddddd' + salt;

    final String key = await cryptor.generateKeyFromPassword(rawPd, newSalt);
    final String encryptedPassword = await cryptor.encrypt(rawPd, key);

    return {
      'encryptedPassword': encryptedPassword,
      'key': key,
    };
  }
}
