import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:pssswd/functions/passwordEncrypter.dart';

import '../providers/user_entries.dart';

class EditEntry extends StatefulWidget {
  final String entry_id;
  final String name;
  final String username;
  final String url;
  final String password;
  var newPassword;

  EditEntry(
    this.entry_id,
    this.name,
    this.username,
    this.password,
    this.url,
  );

  @override
  State<EditEntry> createState() => _EditEntryState();
}

class _EditEntryState extends State<EditEntry> {
  var _isVisibilityIconClicked;
  @override
  void initState() {
    super.initState();
    _isVisibilityIconClicked = false;
  }

  var newPasswordValue;
  var newName;
  var newUsername;
  var newUrl;

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
            child: Column(
              children: [
                TextFormField(
                    decoration: InputDecoration(labelText: 'Name'),
                    initialValue: widget.name,
                    autocorrect: false,
                    onChanged: (text) {
                      newName = text;
                    }),
                TextFormField(
                    decoration: InputDecoration(labelText: 'Username'),
                    initialValue: widget.username,
                    autocorrect: false,
                    onChanged: (text) {
                      newUsername = text;
                    }),
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                      ),
                      initialValue: widget.password,
                      obscureText: !_isVisibilityIconClicked,
                      autocorrect: false,
                      validator: (val) {
                        if (val == '') {
                          print(_isVisibilityIconClicked);
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
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (_isVisibilityIconClicked == true) {
                            _isVisibilityIconClicked = false;
                          } else {
                            _isVisibilityIconClicked = true;
                          }
                        });
                      },
                      icon: Icon((_isVisibilityIconClicked)
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                  ],
                ),
                TextFormField(
                    decoration: InputDecoration(labelText: 'Enter new url'),
                    initialValue: widget.url,
                    autocorrect: false,
                    onChanged: (text) {
                      newUrl = text;
                    })
              ],
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
                  "name": newName,
                  "url": newUrl,
                  "username": newUsername,
                }).then((value) => print('doc edited'));

                await Provider.of<UserEntries>(context, listen: false)
                    .fetchEntries();
                Fluttertoast.showToast(
                    msg:
                        'Your password for entry ${widget.name} has been changed');
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
