import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pssswd/functions/app_logger.dart';

import '../functions/passwordEncrypter.dart';
import '../functions/randomPasswordGenerator.dart';
import '../providers/user_entries.dart';

class EditEntry extends StatefulWidget {
  final String entry_id;
  final String name;
  final String username;
  final String url;
  final String password;

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
  var pswd;
  var newPassword;
  var _generatedRandomPassword;
  var enteredPassword;

  final newPasswordController = TextEditingController();

  final secureStorage = FlutterSecureStorage();

  final GlobalKey<FormState> _newPasswordFormValidationKey =
      GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

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
                      setState(() {
                        newName = text;
                      });
                    }),
                TextFormField(
                    decoration: InputDecoration(labelText: 'Username'),
                    initialValue: widget.username,
                    autocorrect: false,
                    onChanged: (text) {
                      setState(() {
                        newUsername = text;
                      });
                    }),
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                      ),
                      // initialValue: widget.password,
                      key: Key(_generatedRandomPassword.toString()),
                      initialValue: (_generatedRandomPassword != null)
                          ? _generatedRandomPassword
                          : widget.password,
                      obscureText: !_isVisibilityIconClicked,
                      autocorrect: false,
                      onChanged: (val) {
                        setState(() {
                          enteredPassword = val;
                        });
                      },
                      validator: (val) {
                        if (val == '') {
                          return "Field cannot be empty";
                        }
                        return null;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            try {
                              setState(() {
                                if (_isVisibilityIconClicked == true) {
                                  _isVisibilityIconClicked = false;
                                } else {
                                  _isVisibilityIconClicked = true;
                                }
                              });
                            } catch (e) {
                              AppLogger.printErrorLog('Some error occured',
                                  error: e);
                            }
                          },
                          icon: Icon((_isVisibilityIconClicked)
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                        IconButton(
                          onPressed: () {
                            try {
                              var randPass = RandomPasswordGenerator
                                  .generateRandomPassword();
                              setState(() {
                                _generatedRandomPassword = randPass;
                                enteredPassword = _generatedRandomPassword;
                                newPasswordValue = _generatedRandomPassword;
                              });
                            } catch (e) {
                              AppLogger.printErrorLog('Some error occured',
                                  error: e);
                            }
                          },
                          icon: FaIcon(FontAwesomeIcons.random),
                        ),
                      ],
                    ),
                  ],
                ),
                TextFormField(
                    decoration: InputDecoration(labelText: 'Enter new url'),
                    initialValue: widget.url,
                    autocorrect: false,
                    onChanged: (text) {
                      setState(() {
                        newUrl = text;
                      });
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
                try {
                  if (!_newPasswordFormValidationKey.currentState!.validate()) {
                    AppLogger.printInfoLog('Field cannot be empty');
                    return;
                  }

                  var db = FirebaseFirestore.instance;
                  final ep = PasswordEnrypter();

                  var _masterPassword =
                      await secureStorage.read(key: 'masterPassword');

                  //setting default value if user didn't edit the entry
                  if (newPasswordValue == null) {
                    if (enteredPassword == null) {
                      newPasswordValue = widget.password;
                    } else {
                      newPasswordValue = enteredPassword;
                    }
                  }
                  if (newName == null) {
                    newName = widget.name;
                  }
                  if (newUsername == null) {
                    newUsername = widget.username;
                  }
                  if (newUrl == null) {
                    newUrl = widget.url;
                  }

                  final encryptedPasswordMap = await ep.encryptPassword(
                      newPasswordValue, _masterPassword);

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
                  }).then(
                    (value) =>
                        AppLogger.printInfoLog('Docuement Edited Successfully'),
                  );

                  await Provider.of<UserEntries>(context, listen: false)
                      .fetchEntries();
                  Fluttertoast.showToast(
                      msg:
                          'Your password for entry ${widget.name} has been changed');
                  Navigator.pop(context);
                } catch (e) {
                  AppLogger.printErrorLog('Some error occured', error: e);
                }
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
