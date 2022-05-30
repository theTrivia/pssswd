import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:pssswd/functions/passwordEncrypter.dart';

import '../providers/user_entries.dart';

class ChangePassword extends StatelessWidget {
  var entry_id;
  var domain;
  var newPassword;
  final secureStorage = FlutterSecureStorage();
  ChangePassword(this.entry_id, this.domain, this.newPassword);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    var _uid = secureStorage.read(key: 'loggedInUserId');

    return ButtonTheme(
      minWidth: mediaQuery.size.width * 0.8,
      shape: StadiumBorder(),
      child: RaisedButton(
        onPressed: () async {
          var db = FirebaseFirestore.instance;
          // print('----------------');
          // print(newPassword);
          // print(entry_id);
          // print(domain);
          // print(newPassword);

          //need t0 change the encrypted password after changing the password
          // store it to the database

          var _masterPassword = await secureStorage.read(key: 'masterPassword');

          final ep = PasswordEnrypter();
          final encryptedPasswordMap =
              await ep.encryptPassword(newPassword, _masterPassword);

          await db.collection('password_entries').doc(entry_id).update({
            "password": encryptedPasswordMap['encryptedPassword'],
            "randForKeyToStore": encryptedPasswordMap['randForKeyToStore'],
            "randForIV": encryptedPasswordMap['randForIV'],
          }).then((value) => print('doc edited'));

          await Provider.of<UserEntries>(context, listen: false).fetchEntries();
          Fluttertoast.showToast(
              msg: 'Your password for entry ${domain} has been changed');
          Navigator.pop(context);
        },
        child: Text(
          'Change Password',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
