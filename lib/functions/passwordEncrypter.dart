import 'dart:math';
// import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
// import 'package:flutter_string_encryption/flutter_string_encryption.dart';
// import "package:pointycastle/export.dart";

class PasswordEnrypter {
  //5 digit user password should be sent as a parameter at the time of launching the app
  // encryptPassword(String rawPd, String masterPassword) async {
  //   late PlatformStringCryptor cryptor;
  //   cryptor = new PlatformStringCryptor();
  //   String salt = await cryptor.generateSalt();

  //   //5 digit user password should be sent as a parameter at the time of launching the app
  //   String newSalt = masterPassword + salt;

  //   final String key = await cryptor.generateKeyFromPassword(rawPd, newSalt);
  //   final String encryptedPassword = await cryptor.encrypt(rawPd, key);

  //   return {
  //     'encryptedPassword': encryptedPassword,
  //     'salt': newSalt,
  //   };
  // }

  encryptPassword(String rawPd, String masterPassword) async {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    String getRandomString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

    final randForKeyToStore =
        getRandomString(27).toString(); //to Store along with password

    var encpss;

    final randForKey = randForKeyToStore + masterPassword;

    final key = Key.fromUtf8(randForKey);

    final randForIV = getRandomString(16); //to Store along with password
    final iv = IV.fromUtf8(randForIV);

    final e = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted_data = e.encrypt(rawPd, iv: iv);

    encpss = encrypted_data.base64;

    return {
      'encryptedPassword': encpss,
      'randForKeyToStore': randForKeyToStore,
      'randForIV': randForIV,
    };
  }
}
