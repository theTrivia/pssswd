import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserEntries extends ChangeNotifier {
  var _entries;
  var _uid;
  final secureStorage = new FlutterSecureStorage();

  get entries {
    return _entries;
  }

  // setUid(uid) {
  //   _uid = uid;
  //   notifyListeners();
  // }

  // fetchEntries() async {
  //   var db = FirebaseFirestore.instance;

  //   final res = await db.collection("password_entries").get().then((event) {
  //     var resDic;
  //     List abc = [];
  //     for (var doc in event.docs) {
  //       resDic = {
  //         "entry_id": doc.id,
  //         "data": doc.data(),
  //       };

  //       abc.add(resDic);
  //     }

  //     _entries = abc;

  //     print(_entries);
  //     notifyListeners();
  //   });
  // }

  fetchEntries() async {
    print(_uid);
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
        print(_entries);
        notifyListeners();
      },
    );
  }
}
