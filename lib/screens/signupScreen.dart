import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:pssswd/components/masterPasswordAck.dart';
import 'package:pssswd/functions/userSignup.dart';
import 'package:slider_button/slider_button.dart';

import '../components/loadingWidgetForButton.dart';
import '../components/pinInputTheme.dart';
import '../functions/masterPasswordHash.dart';
import '../models/User.dart';

import '../providers/user_entries.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  final masterPasswordController = TextEditingController();
  final secureStorage = new FlutterSecureStorage();

  var isUserSignedUp = false;

  var _userAckForMasterPassword = false;
  var _userGaveMasterPassword = false;

  // var signedUser;
  var user;

  final GlobalKey<FormState> _signupFormValidationKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _masterPasswordFormValidationKey =
      GlobalKey<FormState>();
  var _didUserPressedSignup;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (!isUserSignedUp)
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
                    'assets/images/pssswd.jpeg',
                  ),
                ),
                Column(
                  children: [
                    (isUserSignedUp == true)
                        ? Column(
                            children: [
                              if (_userGaveMasterPassword == false)
                                Column(
                                  children: [
                                    Text(
                                        'Success!!! Now lets create your master password',
                                        style: TextStyle(fontSize: 15)),
                                    Form(
                                      key: _masterPasswordFormValidationKey,
                                      child: Column(
                                        children: [
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15, right: 15),
                                              child: Pinput(
                                                length: 5,
                                                defaultPinTheme: PinInputTheme
                                                    .defaultPinTheme,
                                                focusedPinTheme: PinInputTheme
                                                    .defaultPinTheme,
                                                submittedPinTheme: PinInputTheme
                                                    .submittedPinTheme,
                                                controller:
                                                    masterPasswordController,
                                                onCompleted: (pin) =>
                                                    print(pin),
                                                validator: (val) {
                                                  if (val == '') {
                                                    return "Please provide your master password.";
                                                  }
                                                  return null;
                                                },
                                              )),
                                          if (_userAckForMasterPassword ==
                                              false)
                                            ButtonTheme(
                                              minWidth:
                                                  mediaQuery.size.width * 0.8,
                                              height:
                                                  mediaQuery.size.height * 0.05,
                                              child: RaisedButton(
                                                onPressed: () async {
                                                  if (!_masterPasswordFormValidationKey
                                                      .currentState!
                                                      .validate()) {
                                                    print(
                                                        'Master Password must be 5 chars');
                                                    return;
                                                  }
                                                  print(
                                                    'master password ${masterPasswordController.text}',
                                                  );

                                                  final secureStorage =
                                                      new FlutterSecureStorage();

                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      content: Text(
                                                        'Keep this password safe. You won\'t be able to recover your passwords without this.',
                                                        style: TextStyle(
                                                            fontSize: 13),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              _userAckForMasterPassword =
                                                                  false;
                                                            });
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child:
                                                              Text('Go Back'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              _userAckForMasterPassword =
                                                                  true;
                                                              _userGaveMasterPassword =
                                                                  true;
                                                            });
                                                            print(
                                                                "state of _userGaveMasterPassword  '${_userGaveMasterPassword}' ");
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                            'I acknowledge',
                                                            style: TextStyle(
                                                              color: Colors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
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
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              if (_userGaveMasterPassword)
                                //Default button
                                // ButtonTheme(
                                //   minWidth: mediaQuery.size.width * 0.8,
                                //   child: RaisedButton(
                                //     onPressed: () async {
                                //       // final prefs = await SharedPreferences.getInstance();

                                //       await secureStorage.write(
                                //           key:
                                //               'isUserLoggedInUsingEmailPassword',
                                //           value: 'true');

                                //       //Password Hasing logic
                                //       var hp = MasterPasswordHash();
                                //       var hashedPassword =
                                //           hp.hashMasterPassword(
                                //               masterPasswordController.text);
                                //       print(
                                //           'hashed password from signup screen ->>>>> ${hashedPassword}');

                                //       var db = FirebaseFirestore.instance;
                                //       final signedUser = {
                                //         'uniqueUserId': user.uniqueUserId,
                                //         'isNewUser': user.isNewUser,
                                //         'email': user.email,
                                //         'masterPasswordHash': hashedPassword,
                                //         'isEmailVerified': user.isEmailVerified,
                                //         'creationTime': user.creationTime
                                //       };

                                //       await db
                                //           .collection('users')
                                //           .doc(signedUser['uniqueUserId'])
                                //           .set(signedUser)
                                //           .then((value) => print('value set'));

                                //       await secureStorage.write(
                                //           key: 'loggedInUserId',
                                //           value: signedUser['uniqueUserId']);
                                //       await secureStorage.write(
                                //           key: 'email',
                                //           value: signedUser['email']);
                                //       await secureStorage.write(
                                //           key: 'masterPasswordHash',
                                //           value: hashedPassword);
                                //       var masterPassword =
                                //           await secureStorage.write(
                                //               key: 'masterPassword',
                                //               value: masterPasswordController
                                //                   .text);

                                //       print(
                                //           'Hashed password from signup screen------------->${hashedPassword}');

                                //       // final prefs = await SharedPreferences.getInstance();

                                //       Navigator.pushNamed(
                                //         context,
                                //         '/appMainPage',
                                //       );
                                //     },
                                //     shape: StadiumBorder(),
                                //     child: Text(
                                //       'You are good to go!!! Lets go',
                                //       style: TextStyle(
                                //         fontWeight: FontWeight.bold,
                                //         color: Colors.white,
                                //       ),
                                //     ),
                                //   ),
                                // ),

                                Center(
                                  child: SliderButton(
                                    height:
                                        null ?? mediaQuery.size.height * 0.07,
                                    buttonSize:
                                        null ?? mediaQuery.size.height * 0.07,
                                    width: null ?? mediaQuery.size.width * 0.6,
                                    action: () async {
                                      await secureStorage.write(
                                          key:
                                              'isUserLoggedInUsingEmailPassword',
                                          value: 'true');

                                      var hp = MasterPasswordHash();
                                      var hashedPassword =
                                          hp.hashMasterPassword(
                                              masterPasswordController.text);
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

                                      await secureStorage.write(
                                          key: 'loggedInUserId',
                                          value: signedUser['uniqueUserId']);
                                      await secureStorage.write(
                                          key: 'email',
                                          value: signedUser['email']);
                                      await secureStorage.write(
                                          key: 'masterPasswordHash',
                                          value: hashedPassword);
                                      var masterPassword =
                                          await secureStorage.write(
                                              key: 'masterPassword',
                                              value: masterPasswordController
                                                  .text);

                                      print(
                                          'Hashed password from signup screen------------->${hashedPassword}');

                                      Navigator.pushNamed(
                                        context,
                                        '/appMainPage',
                                      );
                                    },
                                    label: Text(
                                      'Lets save pssswd',
                                      style: TextStyle(
                                          color: Color(0xff4a4a4a),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                    icon: Text(
                                      'X',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 35,
                                      ),
                                    ),
                                  ),
                                )
                            ],
                          )
                        : Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: Form(
                              key: _signupFormValidationKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: emailController,
                                    decoration:
                                        InputDecoration(labelText: 'Email'),
                                    validator: (val) {
                                      if (!(val!.contains('@') &&
                                              val.contains('.')) ||
                                          val.isEmpty) {
                                        return "Please enter an valid email id";
                                      }
                                      return null;
                                    },
                                  ),
                                  TextFormField(
                                    controller: passwordController,
                                    decoration:
                                        InputDecoration(labelText: 'Password'),
                                    validator: (value) {
                                      if (value!.length < 6) {
                                        return "Password length must be greater than or equal to 6 chars.";
                                      }
                                      return null;
                                    },
                                  ),
                                  if (isUserSignedUp == false)
                                    ButtonTheme(
                                      minWidth: mediaQuery.size.width * 0.8,
                                      height: mediaQuery.size.height * 0.05,
                                      shape: StadiumBorder(),
                                      child: RaisedButton(
                                        onPressed: () async {
                                          if (_signupFormValidationKey
                                              .currentState!
                                              .validate()) {
                                            // Text('bad');
                                          }
                                          setState(() {
                                            _didUserPressedSignup = 'true';
                                          });
                                          var signupObject = UserSignup();
                                          var signupResult =
                                              await signupObject.performSignup(
                                            emailController.text,
                                            passwordController.text,
                                          );
                                          print(signupResult);
                                          setState(() {
                                            _didUserPressedSignup = 'false';
                                          });

                                          var isNewUser =
                                              signupResult['userCredential']
                                                  .additionalUserInfo
                                                  .isNewUser;

                                          var email =
                                              signupResult['userCredential']
                                                  .user
                                                  .email;
                                          var isEmailVerified =
                                              signupResult['userCredential']
                                                  .user
                                                  .emailVerified;

                                          var creationTime =
                                              signupResult['userCredential']
                                                  .user
                                                  .metadata
                                                  .creationTime;
                                          var uniqueUserId =
                                              signupResult['userCredential']
                                                  .user
                                                  .uid;

                                          user = User(
                                              uniqueUserId: uniqueUserId,
                                              isNewUser: isNewUser,
                                              email: email,
                                              masterPasswordHash: 'coming-soon',
                                              isEmailVerified: isEmailVerified,
                                              creationTime: creationTime);

                                          isUserSignedUp = user.isNewUser;
                                          if (isUserSignedUp) {
                                            setState(() {
                                              isUserSignedUp = true;
                                            });
                                          }

                                          print(isUserSignedUp);
                                        },
                                        child: (_didUserPressedSignup == 'true')
                                            ? SizedBox(
                                                child: Container(
                                                  height:
                                                      mediaQuery.size.height *
                                                          0.03,
                                                  width: mediaQuery.size.width *
                                                      0.5,
                                                  child: LoadingWidgetForButton
                                                      .spinkit,
                                                ),
                                              )
                                            : Text(
                                                'Signup',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
