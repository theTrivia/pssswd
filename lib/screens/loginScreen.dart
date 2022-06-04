import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pinput/pinput.dart';

import 'package:provider/provider.dart';
import 'package:pssswd/components/loadingWidgetForButton.dart';
import 'package:pssswd/components/masterPasswordAck.dart';

import 'package:pssswd/functions/masterPasswordHash.dart';
import 'package:pssswd/functions/userLogin.dart';
import 'package:pssswd/models/User.dart';

import 'package:pssswd/screens/appMainPage.dart';

import '../components/loginFailure.dart';
import '../components/pinInputTheme.dart';
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
  final GlobalKey<FormState> _masterPasswordFormValidationKey =
      GlobalKey<FormState>();
  final GlobalKey<FormState> _loginFormValidationKey = GlobalKey<FormState>();
  var _didUserPressedLogin;
  var _errorMessage;
  var isMasterPasswordCorrect;

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
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );
    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromARGB(255, 42, 49, 56)),
      borderRadius: BorderRadius.circular(8),
    );
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
                      0.45,
                  child: Image.asset(
                    'assets/images/pssswd-logo.png',
                  ),
                ),
                (_isMasterPasswordPresent == null && _userDidLogin == true)
                    ? Form(
                        key: _masterPasswordFormValidationKey,
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              child: Pinput(
                                length: 5,
                                defaultPinTheme: PinInputTheme.defaultPinTheme,
                                focusedPinTheme: PinInputTheme.defaultPinTheme,
                                submittedPinTheme:
                                    PinInputTheme.submittedPinTheme,
                                controller: masterPasswordController,
                                onCompleted: (pin) => print(pin),
                                validator: (val) {
                                  if (val == '') {
                                    return "Please provide your master password.";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            ButtonTheme(
                              minWidth: mediaQuery.size.width * 0.8,
                              height: mediaQuery.size.height * 0.05,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  onPressed: () async {
                                    if (_masterPasswordFormValidationKey
                                        .currentState!
                                        .validate()) {}
                                    var masterPasswordHash =
                                        loggedInUser['masterPasswordHash'];

                                    final mph = MasterPasswordHash();
                                    isMasterPasswordCorrect =
                                        mph.checkIfMasterPasswordValid(
                                            masterPasswordController.text,
                                            masterPasswordHash);
                                    print(isMasterPasswordCorrect);

                                    if (isMasterPasswordCorrect == true) {
                                      final secureStorage =
                                          new FlutterSecureStorage();
                                      var masterPassword =
                                          await secureStorage.write(
                                              key: 'masterPassword',
                                              value: masterPasswordController
                                                  .text);
                                      _isMasterPasswordPresent =
                                          await secureStorage.read(
                                              key: 'masterPassword');
                                      print(_isMasterPasswordPresent);

                                      if (_isMasterPasswordPresent != null) {
                                        await secureStorage.write(
                                            key: 'loggedInUserId',
                                            value:
                                                loggedInUser['uniqueUserId']);
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
                                      setState(() {
                                        isMasterPasswordCorrect = false;
                                      });
                                      print('you are an idiot!!!');
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
                            ),
                            if (isMasterPasswordCorrect == false)
                              UserAuthFailureMessage.showErrorMessage(
                                  'master-password-invalid'),
                          ],
                        ),
                      )
                    : Form(
                        key: _loginFormValidationKey,
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15),
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: emailController,
                                        decoration: const InputDecoration(
                                            labelText: 'Email'),
                                        validator: (val) {
                                          if (val!.length == 0) {
                                            return "Field can\'t be blank";
                                          }
                                          return null;
                                        },
                                      ),
                                      TextFormField(
                                        controller: passwordController,
                                        decoration: InputDecoration(
                                            labelText: 'Password'),
                                        validator: (val) {
                                          if (val!.length == 0) {
                                            return "Field can\'t be blank";
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ButtonTheme(
                                    minWidth: mediaQuery.size.width * 0.8,
                                    height: mediaQuery.size.height * 0.05,
                                    child: RaisedButton(
                                      onPressed: () async {
                                        if (emailController.text == '' ||
                                            passwordController.text == '') {
                                          setState(() {
                                            _errorMessage = 'unknown-error';
                                            _userDidLogin = false;
                                          });
                                          return;
                                        }
                                        // if (_loginFormValidationKey
                                        //     .currentState!
                                        //     .validate()) {
                                        //   print('hello');
                                        // }
                                        print(
                                            '77777777777777777777    ${emailController.text.length}');
                                        print(
                                            '77777777777777777777    ${passwordController.text.length}');

                                        setState(() {
                                          _didUserPressedLogin = 'true';
                                        });

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
                                            _errorMessage =
                                                loginResult['loginStatus'];
                                            _userDidLogin = false;
                                          });
                                        } else {
                                          setState(() {
                                            _userDidLogin = true;
                                          });
                                        }

                                        var isNewUser =
                                            loginResult['userCredential']
                                                ['isNewUser'];

                                        var email =
                                            loginResult['userCredential']
                                                ['email'];
                                        var isEmailVerified =
                                            loginResult['userCredential']
                                                ['emailVerified'];

                                        var creationTime =
                                            loginResult['userCredential']
                                                ['creationTime'];
                                        var uniqueUserId =
                                            loginResult['userCredential']
                                                ['uniqueUserId'];
                                        var masterPasswordHash =
                                            loginResult['userCredential']
                                                ['masterPasswordHash'];

                                        final user = User(
                                            uniqueUserId: uniqueUserId,
                                            isNewUser: isNewUser,
                                            email: email,
                                            masterPasswordHash:
                                                masterPasswordHash,
                                            isEmailVerified: isEmailVerified,
                                            creationTime: creationTime);

                                        loggedInUser = {
                                          'uniqueUserId': user.uniqueUserId,
                                          'isNewUser': user.isNewUser,
                                          'email': user.email,
                                          'masterPasswordHash':
                                              user.masterPasswordHash,
                                          'isEmailVerified':
                                              user.isEmailVerified,
                                          'creationTime': user.creationTime
                                        };

                                        setState(() {
                                          _didUserPressedLogin = 'false';
                                        });

                                        if (_userDidLogin == true) {
                                          await secureStorage.write(
                                              key:
                                                  'isUserLoggedInUsingEmailPassword',
                                              value: 'true');

                                          if (_isMasterPasswordPresent !=
                                              null) {
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AppMainPage(),
                                              ),
                                            );
                                          }
                                        }
                                      },
                                      shape: const StadiumBorder(),
                                      child: (_didUserPressedLogin == 'true')
                                          ? SizedBox(
                                              child: Container(
                                                height: mediaQuery.size.height *
                                                    0.03,
                                                width:
                                                    mediaQuery.size.width * 0.5,
                                                child: LoadingWidgetForButton
                                                    .spinkit,
                                              ),
                                            )
                                          : const Text(
                                              'Login',
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
                          ],
                        ),
                      ),
                if (_userDidLogin == false)
                  UserAuthFailureMessage.showErrorMessage(_errorMessage),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
