import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:pssswd/functions/passwordEncrypter.dart';

import 'package:pssswd/models/passwordEntry.dart';

import 'package:pssswd/providers/user_entries.dart';

class AddPasswd extends StatefulWidget {
  @override
  State<AddPasswd> createState() => _AddPasswdState();
}

class _AddPasswdState extends State<AddPasswd> {
  var _isVisibilityIconClicked;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isVisibilityIconClicked = false;
  }

  final secureStorage = new FlutterSecureStorage();
  final enteredName = TextEditingController();

  final enteredPassword = TextEditingController();
  final enteredUsername = TextEditingController();
  final enteredUrl = TextEditingController();
  var _uid;
  final GlobalKey<FormState> _addPasswordFormValidationKey =
      GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Add Passwd'),
        ),
        body: Form(
          key: _addPasswordFormValidationKey,
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Enter the name',
                  ),
                  controller: enteredName,
                  validator: (val) {
                    if (val == '') {
                      return "Name cannot be empty";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Enter your username'),
                  controller: enteredUsername,
                  validator: (val) {
                    if (val == '') {
                      return "Username cannot be empty";
                    }
                    return null;
                  },
                ),
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: 'Enter your password'),
                      controller: enteredPassword,
                      obscureText: !_isVisibilityIconClicked,
                      validator: (val) {
                        if (val == '') {
                          return "Password cannot be empty";
                        }
                        return null;
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
                  decoration: InputDecoration(labelText: 'Enter the URL'),
                  controller: enteredUrl,
                ),
                ButtonTheme(
                  minWidth: mediaQuery.size.width * 0.8,
                  height: mediaQuery.size.height * 0.05,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      onPressed: () async {
                        if (_addPasswordFormValidationKey.currentState!
                            .validate()) {}
                        if (enteredName.text == '' ||
                            enteredPassword.text == '') {
                          print('Entered Name/Password cannot be null');
                          return;
                        }
                        _uid = await secureStorage.read(key: 'loggedInUserId');

                        Random random = new Random();
                        final newEntry = PasswordEntry(
                          user_id: _uid,
                          name: enteredName.text,
                          username: enteredUsername.text,
                          password: enteredPassword.text,
                          timestamp: Timestamp.now(),
                          url: enteredUrl.text,
                        );

                        var masterPassword =
                            await secureStorage.read(key: 'masterPassword');

                        var pss = PasswordEnrypter();
                        final encryptedPasswordMap = await pss.encryptPassword(
                            newEntry.password, masterPassword);

                        final newEntryPush = {
                          "user_id": newEntry.user_id,
                          "name": newEntry.name,
                          "username": newEntry.username,
                          "password": encryptedPasswordMap['encryptedPassword'],
                          "url": newEntry.url,
                          "randForKeyToStore":
                              encryptedPasswordMap['randForKeyToStore'],
                          "randForIV": encryptedPasswordMap['randForIV'],
                          "timestamp": newEntry.timestamp,
                        };

                        if (newEntry.name.isEmpty ||
                            newEntry.password.isEmpty) {
                          return;
                        }

                        var db = FirebaseFirestore.instance;
                        await db
                            .collection('password_entries')
                            .add(newEntryPush)
                            .then(
                          (value) {
                            print('submitted: ${value.id}');
                          },
                        );

                        await Provider.of<UserEntries>(context, listen: false)
                            .fetchEntries();
                        Navigator.pushNamed(context, '/appMainPage');
                      },
                      shape: StadiumBorder(),
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
