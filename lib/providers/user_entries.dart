import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserEntries extends ChangeNotifier {
  var _entries;

  get entries {
    return _entries;
  }

  fetchEntries() async {
    var db = FirebaseFirestore.instance;

    final res = await db.collection("password_entries").get().then((event) {
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

      // print(_entries);
      notifyListeners();
    });
  }
}
