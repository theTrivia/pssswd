import 'package:flutter/material.dart';
import 'package:pssswd/functions/userSignup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  final masterPasswordController = TextEditingController();

  var isUserSignedUp = false;

  var _userAckForMasterPassword = false;

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
            if (isUserSignedUp == false)
              ElevatedButton(
                onPressed: () async {
                  var signupObject = UserSignup();
                  var res = await signupObject.performSignup(
                    emailController.text,
                    passwordController.text,
                  );

                  // print(res);
                  // if (res['isUserNew']) {
                  // print("is the user new??? ->   ${res['isUserNew']}");
                  isUserSignedUp = res['isUserNew'];
                  if (isUserSignedUp) {
                    setState(() {
                      isUserSignedUp = true;
                    });
                  }

                  print(isUserSignedUp);
                  // }

                  // if (res == 'signup-success') {
                  //   Navigator.pushNamed(
                  //     context,
                  //     '/appMainPage',
                  //   );
                  // }
                },
                child: Text('Signup'),
              ),
            if (isUserSignedUp == true)
              Column(
                children: [
                  Text('Success!!! Now lets create your master password'),
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: '5 digit Master password'),
                    controller: masterPasswordController,
                  ),
                  if (_userAckForMasterPassword == false)
                    ElevatedButton(
                      onPressed: () {
                        print(
                          'master password ${masterPasswordController.text}',
                        );
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Master Password Acknowledgement'),
                            content: Text('Master Password Ack content string'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _userAckForMasterPassword = true;
                                  });
                                  Navigator.pop(context);
                                },

                                //store the hash of the password in database
                                //
                                child: Text('I acknowledge'),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _userAckForMasterPassword = false;
                                  });
                                  Navigator.pop(context);
                                },
                                child: Text('Go Back'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text('Submit'),
                    ),
                  if (_userAckForMasterPassword)
                    RaisedButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool(
                            'isUserLoggedInUsingEmailPassword', true);
                        Navigator.pushNamed(
                          context,
                          '/appMainPage',
                        );
                      },
                      child: Text('You are good to go!!! Lets go'),
                    )
                ],
              ),
            if (isUserSignedUp == false)
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
