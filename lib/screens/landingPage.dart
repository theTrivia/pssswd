import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pinput/pinput.dart';

import 'package:provider/provider.dart';
import 'package:pssswd/components/pinInputTheme.dart';

import '../functions/masterPasswordHash.dart';

import '../functions/materialColorGenerator.dart';
import '../providers/user_entries.dart';
import 'appMainPage.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final secureStorage = new FlutterSecureStorage();
  final masterPasswordController = TextEditingController();
  final GlobalKey<FormState> _masterPasswordFormValidationKey =
      GlobalKey<FormState>();

  var isUserLoggedInUsingEmailPassword;

  fetchisUserLoggedInUsingEmailPassword() async {
    var isUserLoggedInUsingEmailPasswordFromDisk =
        await secureStorage.read(key: 'isUserLoggedInUsingEmailPassword');
    setState(() {
      isUserLoggedInUsingEmailPassword =
          isUserLoggedInUsingEmailPasswordFromDisk;
    });
  }

  @override
  void initState() {
    super.initState();

    fetchisUserLoggedInUsingEmailPassword();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: WillPopScope(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                // color: Colors.amber,
                height: (mediaQuery.size.height -
                        mediaQuery.padding.top -
                        mediaQuery.padding.bottom) *
                    0.5,
                child: Image.asset(
                  'assets/images/pssswd.jpeg',
                ),
              ),
              if (isUserLoggedInUsingEmailPassword == 'true')
                Container(
                  // color: Colors.blue,
                  height: mediaQuery.size.height * 0.3,
                  child: Form(
                    key: _masterPasswordFormValidationKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: Pinput(
                            length: 5,
                            defaultPinTheme: PinInputTheme.defaultPinTheme,
                            focusedPinTheme: PinInputTheme.defaultPinTheme,
                            submittedPinTheme: PinInputTheme.submittedPinTheme,
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
                          shape: StadiumBorder(),
                          minWidth: mediaQuery.size.width * 0.8,
                          height: mediaQuery.size.height * 0.05,
                          child: RaisedButton(
                            onPressed: () async {
                              var masterPasswordHash = await secureStorage.read(
                                  key: 'masterPasswordHash');

                              print('-----------${masterPasswordHash}');

                              final mph = MasterPasswordHash();
                              var res = mph.checkIfMasterPasswordValid(
                                  masterPasswordController.text,
                                  masterPasswordHash);
                              print(res);

                              if (res == true) {
                                final secureStorage =
                                    new FlutterSecureStorage();
                                var masterPassword = await secureStorage.write(
                                    key: 'masterPassword',
                                    value: masterPasswordController.text);

                                var userId = await secureStorage.read(
                                    key: 'loggedInUserId');

                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AppMainPage(),
                                  ),
                                );
                              } else {
                                print('you are an idiot!!!');

                                return;
                              }
                            },
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
                  ),
                ),
              if (isUserLoggedInUsingEmailPassword != 'true')
                Container(
                  height: (mediaQuery.size.height -
                          mediaQuery.padding.top -
                          mediaQuery.padding.bottom) *
                      0.45,
                  width: mediaQuery.size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isUserLoggedInUsingEmailPassword == "false" ||
                          isUserLoggedInUsingEmailPassword == null)
                        ButtonTheme(
                          minWidth: mediaQuery.size.width * 0.8,
                          height: mediaQuery.size.height * 0.05,
                          child: RaisedButton(
                            shape: StadiumBorder(),
                            onPressed: () async {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  color: MaterialColorGenerator
                                      .createMaterialColor(
                                    Color.fromARGB(247, 220, 220, 220),
                                  ),
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                      if (isUserLoggedInUsingEmailPassword == "false" ||
                          isUserLoggedInUsingEmailPassword == null)
                        ButtonTheme(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/signup');
                            },
                            child: Text('New To pssswd? Lets Sign Up'),
                          ),
                        )
                    ],
                  ),
                ),
              if (isUserLoggedInUsingEmailPassword != 'true')
                Container(
                  height: (mediaQuery.size.height -
                          mediaQuery.padding.top -
                          mediaQuery.padding.bottom) *
                      0.05,
                  child: Text(
                    'Made in 🇮🇳 with ❤️ by Soham Pal',
                    style: TextStyle(
                      color: MaterialColorGenerator.createMaterialColor(
                          Color.fromARGB(247, 14, 14, 14)),
                    ),
                  ),
                )
            ],
          ),
        ),
        onWillPop: onWillPop,
      ),
    );
  }

  Future<bool> onWillPop() {
    // SystemNavigator.pop();
    return Future.value(false);
  }
}
