import 'dart:math';

import 'package:encrypt/encrypt.dart';

void main() {
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  final randForKeyToStore =
      getRandomString(27).toString(); //to Store along with password

  var encpss;

  final randForKey = randForKeyToStore + '12345';

  final key = Key.fromUtf8(randForKey);

  final randForIV = getRandomString(16); //to Store along with password
  final iv = IV.fromUtf8(randForIV);

//encrypt
  encryptMyData(text) {
    final e = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted_data = e.encrypt(text, iv: iv);

    encpss = encrypted_data.base64;
  }

//dycrypt
  decryptMyData(encpss, randForKeyToStore, randForIV) {
    final iv = IV.fromUtf8(randForIV);
    final randForKey = randForKeyToStore + '12345';
    final calculatedKey = Key.fromUtf8(randForKey);

    final e = Encrypter(AES(calculatedKey, mode: AESMode.cbc));
    final decrypted_data = e.decrypt64(encpss, iv: iv);
    print(decrypted_data);
  }

  encryptMyData('soham');

  decryptMyData(encpss, randForKeyToStore, randForIV);
}
