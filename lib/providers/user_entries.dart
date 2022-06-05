import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pssswd/functions/app_logger.dart';

class UserEntries extends ChangeNotifier {
  var _entries;
  var _uid;
  final secureStorage = new FlutterSecureStorage();

  get entries {
    return _entries;
  }

  setEntriesToNull() {
    _entries = null;
    notifyListeners();
  }

  fetchEntries() async {
    try {
      var db = FirebaseFirestore.instance;
      _uid = await secureStorage.read(key: 'loggedInUserId');

      db
          .collection('password_entries')
          .where('user_id', isEqualTo: _uid)
          .get()
          .then(
        (event) {
          var resDic;
          List abc = [];
          for (var doc in event.docs) {
            resDic = {
              "entry_id": doc.id,
              "data": doc.data(),
            };
            abc.add(resDic);
          }
          _entries = abc;
          notifyListeners();
        },
      );
    } catch (e) {
      AppLogger.printErrorLog('Some error occured', error: e);
    }
  }
}
