import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pinput/pinput.dart';
import 'package:pssswd/functions/app_logger.dart';
import 'package:slider_button/slider_button.dart';

import '../functions/userSignup.dart';
import '../components/loadingWidgetForButton.dart';
import '../components/pinInputTheme.dart';
import '../functions/masterPasswordHash.dart';
import '../models/User.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final masterPasswordController = TextEditingController();
  final secureStorage = new FlutterSecureStorage();

  var isUserSignedUp = false;

  var _userAckForMasterPassword = false;
  var _userGaveMasterPassword = false;

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
                    'assets/images/pssswd-logo.png',
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
                                    SizedBox(
                                        height: mediaQuery.size.height * 0.02),
                                    Form(
                                      key: _masterPasswordFormValidationKey,
                                      child: Column(
                                        children: [
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15, right: 15),
                                              child: Pinput(
                                                length: 5,
                                                obscureText: true,
                                                defaultPinTheme: PinInputTheme
                                                    .defaultPinTheme,
                                                focusedPinTheme: PinInputTheme
                                                    .defaultPinTheme,
                                                submittedPinTheme: PinInputTheme
                                                    .submittedPinTheme,
                                                controller:
                                                    masterPasswordController,
                                                validator: (val) {
                                                  if (val == '') {
                                                    return "Please provide your master password.";
                                                  }
                                                  return null;
                                                },
                                              )),
                                          if (_userAckForMasterPassword ==
                                              false)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ButtonTheme(
                                                minWidth:
                                                    mediaQuery.size.width * 0.8,
                                                height: mediaQuery.size.height *
                                                    0.05,
                                                child: RaisedButton(
                                                  onPressed: () async {
                                                    try {
                                                      if (!_masterPasswordFormValidationKey
                                                          .currentState!
                                                          .validate()) {
                                                        AppLogger.printInfoLog(
                                                            'Master Password must be 5 chars');
                                                        return;
                                                      }

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
                                                              child: Text(
                                                                  'Go Back'),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  _userAckForMasterPassword =
                                                                      true;
                                                                  _userGaveMasterPassword =
                                                                      true;
                                                                });

                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text(
                                                                'I acknowledge',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    } catch (e) {
                                                      AppLogger.printErrorLog(
                                                          'Some error occured',
                                                          error: e);
                                                    }
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
                                  ],
                                ),
                              if (_userGaveMasterPassword)
                                Container(
                                  height: mediaQuery.size.height * 0.5,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Center(
                                        child: SliderButton(
                                          // height: null ??
                                          //     mediaQuery.size.height * 0.07,
                                          // buttonSize: null ??
                                          //     mediaQuery.size.height * 0.07,
                                          // width: null ??
                                          //     mediaQuery.size.width * 0.6,
                                          action: () async {
                                            try {
                                              await secureStorage.write(
                                                  key:
                                                      'isUserLoggedInUsingEmailPassword',
                                                  value: 'true');

                                              var hp = MasterPasswordHash();
                                              var hashedPassword =
                                                  hp.hashMasterPassword(
                                                      masterPasswordController
                                                          .text);

                                              var db =
                                                  FirebaseFirestore.instance;
                                              final signedUser = {
                                                'uniqueUserId':
                                                    user.uniqueUserId,
                                                'isNewUser': user.isNewUser,
                                                'email': user.email,
                                                'masterPasswordHash':
                                                    hashedPassword,
                                                'isEmailVerified':
                                                    user.isEmailVerified,
                                                'creationTime':
                                                    user.creationTime
                                              };

                                              await db
                                                  .collection('users')
                                                  .doc(signedUser[
                                                      'uniqueUserId'])
                                                  .set(signedUser);

                                              await secureStorage.write(
                                                  key: 'uniqueUserId',
                                                  value: signedUser[
                                                      'uniqueUserId']);
                                              await secureStorage.write(
                                                  key: 'email',
                                                  value: signedUser['email']);
                                              await secureStorage.write(
                                                  key: 'masterPasswordHash',
                                                  value: hashedPassword);
                                              var masterPassword =
                                                  await secureStorage.write(
                                                      key: 'masterPassword',
                                                      value:
                                                          masterPasswordController
                                                              .text);

                                              Navigator.pushNamed(
                                                context,
                                                '/appMainPage',
                                              );
                                            } catch (e) {
                                              AppLogger.printErrorLog(
                                                  'Some error occured',
                                                  error: e);
                                            }
                                          },
                                          label: Text(
                                            'Lets save pssswd',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xff4a4a4a),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17),
                                          ),
                                          icon: Text(
                                            'X',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 35,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
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
                                    obscureText: true,
                                    decoration:
                                        InputDecoration(labelText: 'Password'),
                                    validator: (value) {
                                      if (value!.length < 6) {
                                        return "Password length must be greater than or equal to 6 chars.";
                                      }
                                      return null;
                                    },
                                  ),
                                  TextFormField(
                                    controller: confirmPasswordController,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        labelText: 'Confirm Password'),
                                    validator: (value) {
                                      if (value != passwordController.text) {
                                        return "Password doesn\'t match";
                                      }
                                      return null;
                                    },
                                  ),
                                  if (isUserSignedUp == false)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ButtonTheme(
                                        minWidth: mediaQuery.size.width * 0.8,
                                        height: mediaQuery.size.height * 0.05,
                                        shape: StadiumBorder(),
                                        child: RaisedButton(
                                          onPressed: () async {
                                            try {
                                              if (!_signupFormValidationKey
                                                  .currentState!
                                                  .validate()) {}
                                              if (confirmPasswordController
                                                      .text !=
                                                  passwordController.text) {
                                                return;
                                              }
                                              setState(() {
                                                _didUserPressedSignup = 'true';
                                              });
                                              var signupObject = UserSignup();
                                              var signupResult =
                                                  await signupObject
                                                      .performSignup(
                                                emailController.text,
                                                passwordController.text,
                                              );
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
                                                  masterPasswordHash:
                                                      'coming-soon',
                                                  isEmailVerified:
                                                      isEmailVerified,
                                                  creationTime: creationTime);

                                              isUserSignedUp = user.isNewUser;
                                              if (isUserSignedUp) {
                                                setState(() {
                                                  isUserSignedUp = true;
                                                });
                                              }
                                            } catch (e) {
                                              AppLogger.printErrorLog(
                                                  'Some error occured',
                                                  error: e);
                                            }
                                          },
                                          child: (_didUserPressedSignup ==
                                                  'true')
                                              ? SizedBox(
                                                  child: Container(
                                                    height:
                                                        mediaQuery.size.height *
                                                            0.03,
                                                    width:
                                                        mediaQuery.size.width *
                                                            0.5,
                                                    child:
                                                        LoadingWidgetForButton
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
