import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:pssswd/functions/localStorageReadWriteData.dart';
import 'package:pssswd/functions/userLogin.dart';
import 'package:pssswd/screens/appMainPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/loginFailure.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  var _userDidLogin;

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
                var res = await loginObject.performLogin(
                  emailController.text,
                  passwordController.text,
                );
                print('output for res     ${res}');
                if (res != 'login-success') {
                  setState(() {
                    _userDidLogin = false;
                  });
                } else {
                  setState(() {
                    _userDidLogin = true;
                  });
                }
                print(_userDidLogin);

                // if _userDidLogin == true && _userHavaMasterPasswordConfigured
                // -> Navigate to App Main Page
                // else Ask user to create a Master password
                // ->if _userHavaMasterPasswordConfigured == true
                // ->->Navigate to App Main Page

                if (_userDidLogin == true) {
                  // final LocalStorage storage = new LocalStorage('pssswd');
                  // var b = storage.getItem('isUserLoggedInUsingMasterPassword');
                  // await storage.setItem(
                  //     'isUserLoggedInUsingMasterPassword', true);
                  final prefs = await SharedPreferences.getInstance();
                  // await prefs.setBool(
                  //     'isUserLoggedInUsingMasterPassword', true);
                  await prefs.setBool('isUserLoggedInUsingEmailPassword', true);

                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AppMainPage(),
                    ),
                  );
                }
              },
              child: Text('Login'),
            ),
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
