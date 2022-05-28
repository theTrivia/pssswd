import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:pssswd/components/masterPasswordAck.dart';
import 'package:pssswd/functions/userSignup.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../functions/masterPasswordHash.dart';
import '../models/User.dart';
import '../providers/userDetails.dart';

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

  var signedUser = {};
  var user;

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
                  var signupResult = await signupObject.performSignup(
                    emailController.text,
                    passwordController.text,
                  );
                  print(signupResult);

                  var isNewUser = signupResult['userCredential']
                      .additionalUserInfo
                      .isNewUser;

                  var email = signupResult['userCredential'].user.email;
                  var isEmailVerified =
                      signupResult['userCredential'].user.emailVerified;

                  var creationTime =
                      signupResult['userCredential'].user.metadata.creationTime;
                  var uniqueUserId = signupResult['userCredential'].user.uid;

                  user = User(
                      uniqueUserId: uniqueUserId,
                      isNewUser: isNewUser,
                      email: email,
                      masterPasswordHash: 'coming-soon',
                      isEmailVerified: isEmailVerified,
                      creationTime: creationTime);

                  // signedUser = {
                  //   'uniqueUserId': user.uniqueUserId,
                  //   'isNewUser': user.isNewUser,
                  //   'email': user.email,
                  //   'masterPasswordHash': user.masterPasswordHash,
                  //   'isEmailVerified': user.isEmailVerified,
                  //   'creationTime': user.creationTime
                  // };
                  print(signedUser);

                  // print(signupResult);
                  // if (signupResult['isUserNew']) {
                  // print("is the user new??? ->   ${signupResult['isUserNew']}");
                  // isUserSignedUp = signupResult['isUserNew'];
                  isUserSignedUp = user.isNewUser;
                  if (isUserSignedUp) {
                    setState(() {
                      isUserSignedUp = true;
                    });
                  }

                  print(isUserSignedUp);
                  // }

                  // if (signupResult == 'signup-success') {
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
                      onPressed: () async {
                        print(
                          'master password ${masterPasswordController.text}',
                        );
                        final secureStorage = new FlutterSecureStorage();
                        await secureStorage.write(
                          key: 'masterPassword',
                          value: masterPasswordController.text,
                        );
                        secureStorage
                            .read(key: 'masterPassword')
                            .then((value) => print('master chief -> ${value}'));

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
                        // print('----------------------${signedUser}');
                        final secureStorage = new FlutterSecureStorage();
                        var hashedMasterPassword = secureStorage
                            .read(key: 'masterPassword')
                            .then((password) async {
                          //Password Hasing logic
                          var hp = MasterPasswordHash();
                          var hashedPassword = hp.hashMasterPassword(password!);
                          print(
                              'hashed password from signup screen ->>>>> ${hashedPassword}');

                          var db = FirebaseFirestore.instance;
                          final signedUser = {
                            'uniqueUserId': user.uniqueUserId,
                            'isNewUser': user.isNewUser,
                            'email': user.email,
                            'masterPasswordHash': hashedPassword,
                            'isEmailVerified': user.isEmailVerified,
                            'creationTime': user.creationTime
                          };

                          await db
                              .collection('users')
                              .doc(signedUser['uniqueUserId'])
                              .set(signedUser)
                              .then((value) => print('value set'));
                          Provider.of<UserDetails>(context, listen: false)
                              .setUserDetails(signedUser);
                        });
                        print(hashedMasterPassword);

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
