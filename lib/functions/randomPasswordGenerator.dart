import './app_logger.dart';
import 'package:random_string/random_string.dart';
import 'dart:math' show Random;

class RandomPasswordGenerator {
  static String generateRandomPassword() {
    try {
      int randomInt = randomBetween(4, 8);

      String randPass = randomString(randomInt) +
          randomAlpha(randomInt) +
          randomString(randomInt);

      return randPass;
    } catch (e) {
      throw AppLogger.printErrorLog('Some error occuured', error: e);
    }
  }
}
