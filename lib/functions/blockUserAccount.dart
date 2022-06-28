import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../functions/app_logger.dart';

class BlockUserAccount {
  static final secureStorage = FlutterSecureStorage();
  static final db = FirebaseFirestore.instance;

  // static blockAccount() async {
  //   try {
  //     final userId = await secureStorage.read(key: 'uniqueUserId');
  //     await db
  //         .collection('users')
  //         .doc(userId)
  //         .update({'blockUserAccount': true});
  //     AppLogger.printInfoLog('Block data updated successfully');
  //   } catch (e) {
  //     AppLogger.printErrorLog('Some error occured', error: e);
  //   }
  // }

  static Future isUserAccountBlocked() async {
    try {
      final userId = await secureStorage.read(key: 'uniqueUserId');

      final userSettings = await db.collection('users').doc(userId).get();
      if (userSettings.data()!.containsKey('isAccountBlocked') == true) {
        if (userSettings.data()!['isAccountBlocked'] == true) {
          return true;
        }
      }
      return false;

      // print(userSettings.data());
      // return userSettings.data()['blockUserAccount'];
    } catch (e) {
      AppLogger.printErrorLog('Some error occured', error: e);
    }
  }

  static blockUserAccount(uniqueUserId) async {
    try {
      final userId = await secureStorage.read(key: 'uniqueUserId');
      print(userId);

      await db
          .collection('users')
          .doc(uniqueUserId)
          .update({"isAccountBlocked": true}).then(
        (value) => AppLogger.printInfoLog('User Account is blocked!!!.'),
      );
    } catch (e) {
      AppLogger.printErrorLog('Some error occured', error: e);
    }
  }

  static Future getUserSetting(userId) async {
    try {
      // final userId = await secureStorage.read(key: 'uniqueUserId');

      final userSettings = await db.collection('users').doc(userId).get();
      if (userSettings.data()!.containsKey('blockUserAccountChoice') == true) {
        if (userSettings.data()!['blockUserAccountChoice'] == true) {
          return true;
        }
      }
      return false;

      // print(userSettings.data());
      // return userSettings.data()['blockUserAccount'];
    } catch (e) {
      AppLogger.printErrorLog('Some error occured', error: e);
    }
  }

  static changeUserSetting(choice) async {
    final userId = await secureStorage.read(key: 'uniqueUserId');

    await db
        .collection('users')
        .doc(userId)
        .update({"blockUserAccountChoice": choice}).then(
      (value) => AppLogger.printInfoLog(
          'block user account choice updated successfully.'),
    );
  }
}
