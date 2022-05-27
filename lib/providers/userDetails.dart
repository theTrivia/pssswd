import 'package:flutter/material.dart';

class UserDetails extends ChangeNotifier {
  var _userDetails;

  get userDetails {
    return _userDetails;
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
    details = _userDetails;
    notifyListeners();
  }
}
