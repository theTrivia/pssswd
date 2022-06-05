import 'package:encrypt/encrypt.dart';

class PasswordDecrypter {
  getDecryptedPassword(encpss, randForKeyToStore, randForIV, masterPasword) {
    final iv = IV.fromUtf8(randForIV);
    final randForKey = randForKeyToStore + masterPasword;
    final calculatedKey = Key.fromUtf8(randForKey);

    final e = Encrypter(AES(calculatedKey, mode: AESMode.cbc));
    final decryptedPassword = e.decrypt64(encpss, iv: iv);
    return decryptedPassword;
  }
}
