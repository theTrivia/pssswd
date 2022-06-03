import 'package:random_string/random_string.dart';
import 'dart:math' show Random;

class RandomPasswordGenerator {
  static String generateRandomPassword() {
    int randomInt = randomBetween(4, 8);

    String randPass = randomString(randomInt) +
        randomAlpha(randomInt) +
        randomString(randomInt);

    return randPass;
  }
}
