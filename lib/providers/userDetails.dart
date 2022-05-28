import 'package:flutter/material.dart';

import '../models/User.dart';

class UserDetails extends ChangeNotifier {
  var _details;

  get getUserDetails {
    return _details;
  }

  // fetchUserDetails() async {
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

  //     // print(_entries);
  //     notifyListeners();
  //   });
  // }

  setUserDetails(details) {
    _details = details;
    notifyListeners();
  }
}
