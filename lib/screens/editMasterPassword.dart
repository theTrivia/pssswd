import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../functions/app_logger.dart';
import '../components/pinInputTheme.dart';
import '../functions/changeMasterPassword.dart';
import '../providers/user_entries.dart';
import '../functions/performLogoutActions.dart';

class EditMasterPassword extends StatefulWidget {
  const EditMasterPassword({Key? key}) : super(key: key);

  @override
  State<EditMasterPassword> createState() => _EditMasterPasswordState();
}

class _EditMasterPasswordState extends State<EditMasterPassword> {
  final _secureStorage = FlutterSecureStorage();
  final _newMasterPasswordController = TextEditingController();
  final _confirmNewMasterPasswordController = TextEditingController();
  var _isnewMasterPasswordEntered = false;
  var _entries;

  final GlobalKey<FormState> _newMasterPasswordFormValidationKey =
      GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Master Password'),
      ),
      body: FutureBuilder(
        future: Provider.of<UserEntries>(context, listen: false).fetchEntries(),
        builder: ((context, snapshot) {
          _entries = context.watch<UserEntries>().entries;
          return Form(
            key: _newMasterPasswordFormValidationKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Please enter your new Master Password',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Pinput(
                  length: 5,
                  defaultPinTheme: PinInputTheme.defaultPinTheme,
                  focusedPinTheme: PinInputTheme.defaultPinTheme,
                  submittedPinTheme: PinInputTheme.submittedPinTheme,
                  obscureText: true,
                  controller: _newMasterPasswordController,
                  onCompleted: (pin) async {
                    setState(() {
                      _isnewMasterPasswordEntered = true;
                    });
                  },
                  validator: (val) {
                    if (val == '') {
                      return "Field cannot be empty";
                    } else if (val!.runes.length != 5) {
                      return "Master Password should contain 5 characters";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 50,
                ),
                (_isnewMasterPasswordEntered == true)
                    ? Container(
                        width: mediaQuery.size.width,
                        // color: Colors.amber,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Please Confirm your Master Password',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Pinput(
                              length: 5,
                              defaultPinTheme: PinInputTheme.defaultPinTheme,
                              focusedPinTheme: PinInputTheme.defaultPinTheme,
                              submittedPinTheme:
                                  PinInputTheme.submittedPinTheme,
                              obscureText: true,
                              controller: _confirmNewMasterPasswordController,
                              validator: (val) {
                                if (val == '') {
                                  return "Field cannot be empty";
                                }
                                if (val != _newMasterPasswordController.text) {
                                  return "Passwords should match";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ButtonTheme(
                    height: mediaQuery.size.height * 0.05,
                    minWidth: mediaQuery.size.width * 0.8,
                    child: RaisedButton(
                      onPressed: () async {
                        if (!_newMasterPasswordFormValidationKey.currentState!
                            .validate()) {
                          AppLogger.printInfoLog(
                              'Issue with user provided Master Password');
                        }
                        if (_newMasterPasswordController.text.length == 0 ||
                            _confirmNewMasterPasswordController.text.length ==
                                0 ||
                            _newMasterPasswordController.text !=
                                _confirmNewMasterPasswordController.text) {
                          return;
                        }
                        await ChangeMasterPassword.changePassword(
                          _entries,
                          _newMasterPasswordController.text,
                        );
                        // await FirebaseAuth.instance.signOut();

                        // await _secureStorage.deleteAll();
                        // await Provider.of<UserEntries>(context, listen: false)
                        //     .setEntriesToNull();

                        await PerformLogoutActions.performLogoutChores(context);

                        Navigator.pushNamed(context, '/');
                      },
                      child: Text(
                        'Change Master Password',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      shape: StadiumBorder(),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
