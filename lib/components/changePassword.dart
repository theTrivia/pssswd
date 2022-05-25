import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../providers/user_entries.dart';

class ChangePassword extends StatelessWidget {
  var entry_id;
  var domain;
  var newPassword;
  ChangePassword(this.entry_id, this.domain, this.newPassword);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        var db = FirebaseFirestore.instance;
        print('----------------');
        print(newPassword);
        await db.collection('password_entries').doc(entry_id).update(
            {'password': newPassword}).then((value) => print('doc edited'));
        await Provider.of<UserEntries>(context, listen: false).fetchEntries();
        Fluttertoast.showToast(
            msg: 'Your password for entry ${domain} has been changed');
        Navigator.pop(context);
      },
      child: Text('Change Password'),
    );
  }
}
