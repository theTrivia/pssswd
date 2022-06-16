import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import './app_logger.dart';
import './passwordDecrypter.dart';
import './passwordEncrypter.dart';
import './masterPasswordHash.dart';

class ChangeMasterPassword {
  static final _secureStorage = FlutterSecureStorage();

  static changePassword(List list, newMasterPassword) async {
    try {
      final db = FirebaseFirestore.instance;
      final ep = PasswordEnrypter();
      final psd = PasswordDecrypter();
      final hp = MasterPasswordHash();
      final _newMasterPassword = newMasterPassword;
      final _masterPassword = await _secureStorage.read(key: 'masterPassword');
      var _uniqueUserId = await _secureStorage.read(key: 'uniqueUserId');

      final _newHashedMasterPassword =
          hp.hashMasterPassword(_newMasterPassword);

      //logic for modifying all the save password entries
      for (var entry in list) {
        var _newHashedPassword;
        var _newRandForKeyToStore;
        var _newRandForIV;

        final _entry_id = entry['entry_id'];
        final _hashedPassword = entry['data']['password'];
        final _randForKeyToStore = entry['data']['randForKeyToStore'];
        final _randForIV = entry['data']['randForIV'];

        final _decryptedEntryPassword = await psd.getDecryptedPassword(
            _hashedPassword, _randForKeyToStore, _randForIV, _masterPassword);
        final _encryptedPasswordMap = await ep.encryptPassword(
            _decryptedEntryPassword, _newMasterPassword);

        _newHashedPassword = _encryptedPasswordMap['encryptedPassword'];
        _newRandForKeyToStore = _encryptedPasswordMap['randForKeyToStore'];
        _newRandForIV = _encryptedPasswordMap['randForIV'];

        await db.collection('password_entries').doc(_entry_id).update({
          "password": _newHashedPassword,
          "randForKeyToStore": _newRandForKeyToStore,
          "randForIV": _newRandForIV,
        }).then(
          (value) => AppLogger.printInfoLog(
              'Entry \"${_entry_id}\" Edited Successfully'),
        );
      }

      //replacing the old master password hash with the new one
      await db.collection('users').doc(_uniqueUserId).update({
        "masterPasswordHash": _newHashedMasterPassword,
      }).then(
          (value) => AppLogger.printInfoLog('User data updated successfully'));

      await _secureStorage.write(
          key: 'masterPassword', value: _newMasterPassword);
    } catch (e) {
      AppLogger.printErrorLog('Some error occured', error: e);
    }
  }
}
