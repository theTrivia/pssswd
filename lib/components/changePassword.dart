import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:pssswd/functions/passwordEncrypter.dart';

import '../providers/user_entries.dart';

class ChangePassword extends StatefulWidget {
  var entry_id;
  var domain;
  var newPassword;

  ChangePassword(
    this.entry_id,
    this.domain,
    this.newPassword,
  );

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  var newPasswordValue;

  final newPasswordController = TextEditingController();

  final secureStorage = FlutterSecureStorage();

  final GlobalKey<FormState> _newPasswordFormValidationKey =
      GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    var _uid = secureStorage.read(key: 'loggedInUserId');

    return Form(
      key: _newPasswordFormValidationKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(labelText: 'Enter new Password'),
              controller: newPasswordController,
              validator: (val) {
                if (val == '') {
                  return "Field cannot be empty";
                }
                return null;
              },
              onChanged: (text) {
                setState(() {
                  newPasswordValue = text;
                });
              },
            ),
          ),
          ButtonTheme(
            minWidth: mediaQuery.size.width * 0.8,
            height: mediaQuery.size.height * 0.05,
            shape: StadiumBorder(),
            child: RaisedButton(
              onPressed: () async {
                if (!_newPasswordFormValidationKey.currentState!.validate()) {
                  print('Field cannot be empty');
                  return;
                }

                var db = FirebaseFirestore.instance;
                // print('----------------');
                // print(newPassword);
                // print(entry_id);
                // print(domain);
                // print(newPassword);

                //need t0 change the encrypted password after changing the password
                // store it to the database

                var _masterPassword =
                    await secureStorage.read(key: 'masterPassword');

                final ep = PasswordEnrypter();
                final encryptedPasswordMap =
                    await ep.encryptPassword(newPasswordValue, _masterPassword);
                print(encryptedPasswordMap);

                await db
                    .collection('password_entries')
                    .doc(widget.entry_id)
                    .update({
                  "password": encryptedPasswordMap['encryptedPassword'],
                  "randForKeyToStore":
                      encryptedPasswordMap['randForKeyToStore'],
                  "randForIV": encryptedPasswordMap['randForIV'],
                }).then((value) => print('doc edited'));

                await Provider.of<UserEntries>(context, listen: false)
                    .fetchEntries();
                Fluttertoast.showToast(
                    msg:
                        'Your password for entry ${widget.domain} has been changed');
                Navigator.pop(context);
              },
              child: Text(
                'Change Password',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
