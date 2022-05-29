import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:pssswd/components/masterPasswordAck.dart';
import 'package:pssswd/functions/localStorageReadWriteData.dart';
import 'package:pssswd/functions/masterPasswordHash.dart';
import 'package:pssswd/functions/userLogin.dart';
import 'package:pssswd/models/User.dart';
import 'package:pssswd/providers/userDetails.dart';
import 'package:pssswd/screens/appMainPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            ElevatedButton(
              onPressed: () async {
                var loginObject = UserLogin();
                var loginResult = await loginObject.performLogin(
                  emailController.text,
                  passwordController.text,
                );
                print(
                    'login creds ->>>>>>>>>>>. ${loginResult["userCredential"]}');

                // print('output for loginResult     ${loginResult}');
                if (loginResult['loginStatus'] != 'login-success') {
                  setState(() {
                    _userDidLogin = false;
                  });
                } else {
                  setState(() {
                    _userDidLogin = true;
                  });
                }
                // print(_userDidLogin);
                // print("------------------${loginResult['userCredential']}");
                // print(
                //     "------------------${loginResult['userCredential']['email']}");

                var isNewUser = loginResult['userCredential']['isNewUser'];

                var email = loginResult['userCredential']['email'];
                var isEmailVerified =
                    loginResult['userCredential']['emailVerified'];

                var creationTime =
                    loginResult['userCredential']['creationTime'];
                var uniqueUserId =
                    loginResult['userCredential']['uniqueUserId'];
                var masterPasswordHash =
                    loginResult['userCredential']['masterPasswordHash'];

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
                // print(
                //     'Logged in USer after giving email and password from login screen ----- >${loggedInUser}');

                // Provider.of<UserDetails>(context, listen: false)
                //     .setUserDetails(loggedInUser);
                // print('${context.watch<UserDetails>().getUserDetails}');
                // print(loggedInUser);
                // if _userDidLogin == true && _userHavaMasterPasswordConfigured
                // -> Navigate to App ain Page
                // else Ask user to create a Master password
                // ->if _userHavaMasterPasswordConfigured == true
                // ->->Navigate to App Main Page

                if (_userDidLogin == true) {
                  await secureStorage.write(
                      key: 'isUserLoggedInUsingEmailPassword', value: 'true');
                  // await prefs.setBool('isUserLoggedInUsingEmailPassword', true);
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
              child: Text('Login'),
            ),
            if (_isMasterPasswordPresent == null && _userDidLogin == true)
              Column(
                children: [
                  TextFormField(
                    decoration:
                        InputDecoration(hintText: 'Enter your master password'),
                    controller: masterPasswordController,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      var masterPasswordHash =
                          loggedInUser['masterPasswordHash'];

                      final mph = MasterPasswordHash();
                      var res = mph.checkIfMasterPasswordValid(
                          masterPasswordController.text, masterPasswordHash);
                      print(res);

                      if (res == true) {
                        final secureStorage = new FlutterSecureStorage();
                        var masterPassword = await secureStorage.write(
                            key: 'masterPassword',
                            value: masterPasswordController.text);
                        _isMasterPasswordPresent =
                            await secureStorage.read(key: 'masterPassword');
                        print(_isMasterPasswordPresent);

                        if (_isMasterPasswordPresent != null) {
                          // Provider.of<UserEntries>(context, listen: false)
                          //     .setUid(loggedInUser['uniqueUserId']);

                          // //required when user is logged in using email/password but not logged in using master password.
                          // final prefs = await SharedPreferences.getInstance();
                          // await prefs.setString(
                          //     'masterPasswordHash', masterPasswordHash);
                          // //required for login using master password from landing page
                          // await prefs.setString(
                          //     'loggedInUserId', loggedInUser['uniqueUserId']);

                          await secureStorage.write(
                              key: 'loggedInUserId',
                              value: loggedInUser['uniqueUserId']);
                          await secureStorage.write(
                              key: 'email', value: loggedInUser['email']);
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
                    child: Text('Submit'),
                  ),
                ],
              ),
            // Text(context.watch<UserDetails>().getUserDetails.toString()),
            if (_userDidLogin == false) LoginFailure(),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
