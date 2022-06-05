import 'package:encrypt/encrypt.dart';
import 'package:pssswd/functions/app_logger.dart';

class PasswordDecrypter {
  getDecryptedPassword(encpss, randForKeyToStore, randForIV, masterPasword) {
    try {
      final iv = IV.fromUtf8(randForIV);
      final randForKey = randForKeyToStore + masterPasword;
      final calculatedKey = Key.fromUtf8(randForKey);

      final e = Encrypter(AES(calculatedKey, mode: AESMode.cbc));
      final decryptedPassword = e.decrypt64(encpss, iv: iv);
      return decryptedPassword;
    } catch (e) {
      AppLogger.printErrorLog('Some error occured', error: e);
    }
  }
}
