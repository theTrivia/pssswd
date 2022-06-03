import 'dart:math';

import 'package:encrypt/encrypt.dart';

class PasswordEnrypter {
  encryptPassword(rawPd, masterPassword) async {
    // print('rawpdssss     ${rawPd}');
    // print('masterPassword     ${masterPassword}');

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
