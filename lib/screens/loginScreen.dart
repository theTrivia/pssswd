import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:provider/provider.dart';
import 'package:pssswd/components/masterPasswordAck.dart';

import 'package:pssswd/functions/masterPasswordHash.dart';
import 'package:pssswd/functions/userLogin.dart';
import 'package:pssswd/models/User.dart';

import 'package:pssswd/screens/appMainPage.dart';

import '../components/loginFailure.dart';
import '../providers/user_entries.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  final masterPasswordController = TextEditingController();

  var _userDidLogin;
  var _isMasterPasswordPresent;
  var loggedInUser;
  final secureStorage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    final secureStorage = new FlutterSecureStorage();
    var masterPasswordHash =
        secureStorage.read(key: 'masterPasswordHash').then((value) {
      _isMasterPasswordPresent = value;
    });
    print(masterPasswordHash);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  // color: Colors.blue,
                  height: mediaQuery.size.height * 0.1,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_circle_left),
                    iconSize: 50,
                  ),
                ),
                Container(
                  // color: Colors.amber,
                  height: (mediaQuery.size.height -
                          mediaQuery.padding.top -
                          mediaQuery.padding.bottom) *
                      0.4,
                  child: Image.asset(
                    'assets/images/lastpass.png',
                  ),
                ),
                // SizedBox(
                //   height: mediaQuery.size.height * 0.05,
                // ),
                (_isMasterPasswordPresent == null && _userDidLogin == true)
                    ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  hintText: 'Enter your master password'),
                              controller: masterPasswordController,
                            ),
                          ),
                          ButtonTheme(
                            minWidth: mediaQuery.size.width * 0.8,
                            child: RaisedButton(
                              onPressed: () async {
                                var masterPasswordHash =
                                    loggedInUser['masterPasswordHash'];

                                final mph = MasterPasswordHash();
                                var res = mph.checkIfMasterPasswordValid(
                                    masterPasswordController.text,
                                    masterPasswordHash);
                                print(res);

                                if (res == true) {
                                  final secureStorage =
                                      new FlutterSecureStorage();
                                  var masterPassword =
                                      await secureStorage.write(
                                          key: 'masterPassword',
                                          value: masterPasswordController.text);
                                  _isMasterPasswordPresent = await secureStorage
                                      .read(key: 'masterPassword');
                                  print(_isMasterPasswordPresent);

                                  if (_isMasterPasswordPresent != null) {
                                    await secureStorage.write(
                                        key: 'loggedInUserId',
                                        value: loggedInUser['uniqueUserId']);
                                    await secureStorage.write(
                                        key: 'email',
                                        value: loggedInUser['email']);
                                    await secureStorage.write(
                                        key: 'masterPasswordHash',
                                        value: masterPasswordHash);

                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AppMainPage(),
                                      ),
                                    );
                                  }
                                } else {
                                  print('you are an idiot!!!');
                                  return;
                                }
                              },
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              shape: StadiumBorder(),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: emailController,
                                  decoration:
                                      const InputDecoration(labelText: 'Email'),
                                ),
                                TextFormField(
                                  controller: passwordController,
                                  decoration:
                                      InputDecoration(labelText: 'Password'),
                                ),
                              ],
                            ),
                          ),
                          ButtonTheme(
                            minWidth: mediaQuery.size.width * 0.8,
                            child: RaisedButton(
                              onPressed: () async {
                                var loginObject = UserLogin();
                                var loginResult =
                                    await loginObject.performLogin(
                                  emailController.text,
                                  passwordController.text,
                                );
                                print(
                                    'login creds ->>>>>>>>>>>. ${loginResult["userCredential"]}');

                                if (loginResult['loginStatus'] !=
                                    'login-success') {
                                  setState(() {
                                    _userDidLogin = false;
                                  });
                                } else {
                                  setState(() {
                                    _userDidLogin = true;
                                  });
                                }

                                var isNewUser =
                                    loginResult['userCredential']['isNewUser'];

                                var email =
                                    loginResult['userCredential']['email'];
                                var isEmailVerified =
                                    loginResult['userCredential']
                                        ['emailVerified'];

                                var creationTime = loginResult['userCredential']
                                    ['creationTime'];
                                var uniqueUserId = loginResult['userCredential']
                                    ['uniqueUserId'];
                                var masterPasswordHash =
                                    loginResult['userCredential']
                                        ['masterPasswordHash'];

                                final user = User(
                                    uniqueUserId: uniqueUserId,
                                    isNewUser: isNewUser,
                                    email: email,
                                    masterPasswordHash: masterPasswordHash,
                                    isEmailVerified: isEmailVerified,
                                    creationTime: creationTime);

                                loggedInUser = {
                                  'uniqueUserId': user.uniqueUserId,
                                  'isNewUser': user.isNewUser,
                                  'email': user.email,
                                  'masterPasswordHash': user.masterPasswordHash,
                                  'isEmailVerified': user.isEmailVerified,
                                  'creationTime': user.creationTime
                                };

                                if (_userDidLogin == true) {
                                  await secureStorage.write(
                                      key: 'isUserLoggedInUsingEmailPassword',
                                      value: 'true');

                                  if (_isMasterPasswordPresent != null) {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AppMainPage(),
                                      ),
                                    );
                                  }
                                }
                              },
                              shape: StadiumBorder(),
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                if (_userDidLogin == false) LoginFailure(),
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.pop(context);
                //   },
                //   child: Text('Go Back'),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
