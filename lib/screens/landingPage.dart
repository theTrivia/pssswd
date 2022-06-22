import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pinput/pinput.dart';

import '../components/loginFailure.dart';
import '../components/pinInputTheme.dart';
import '../functions/app_logger.dart';
import '../functions/masterPasswordHash.dart';
import '../functions/materialColorGenerator.dart';
import './appMainPage.dart';

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
  var isMasterPasswordCorrect;

  fetchisUserLoggedInUsingEmailPassword() async {
    try {
      var isUserLoggedInUsingEmailPasswordFromDisk =
          await secureStorage.read(key: 'isUserLoggedInUsingEmailPassword');
      setState(() {
        isUserLoggedInUsingEmailPassword =
            isUserLoggedInUsingEmailPasswordFromDisk;
      });
    } catch (e) {
      AppLogger.printErrorLog('Some error occured', error: e);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchisUserLoggedInUsingEmailPassword();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    var mediaQueryWidth = mediaQuery.size.width;

    final _logo = Center(
      child: Container(
        // color: Colors.red,
        height: (mediaQuery.size.height -
                mediaQuery.padding.top -
                mediaQuery.padding.bottom) *
            0.55,
        child: Image.asset(
          'assets/images/pssswd-logo.png',
        ),
      ),
    );

    final _pinput = Container(
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
                obscureText: true,
                controller: masterPasswordController,
                onCompleted: (pin) async {
                  var masterPasswordHash =
                      await secureStorage.read(key: 'masterPasswordHash');

                  final mph = MasterPasswordHash();
                  isMasterPasswordCorrect = mph.checkIfMasterPasswordValid(
                      masterPasswordController.text, masterPasswordHash);

                  if (isMasterPasswordCorrect == true) {
                    final secureStorage = new FlutterSecureStorage();
                    var masterPassword = await secureStorage.write(
                        key: 'masterPassword',
                        value: masterPasswordController.text);

                    var userId = await secureStorage.read(key: 'uniqueUserId');

                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppMainPage(),
                      ),
                    );
                  } else {
                    setState(() {
                      isMasterPasswordCorrect = false;
                    });
                    AppLogger.printInfoLog(
                        'Incorrect master password provided');

                    return;
                  }
                },
                validator: (val) {
                  if (val == '') {
                    return "Please provide your master password.";
                  }
                  return null;
                },
              ),
            ),
            if (isMasterPasswordCorrect == false)
              UserAuthFailureMessage.showErrorMessage(
                'master-password-invalid',
              ),
          ],
        ),
      ),
    );

    final _loginSignupButtons = Container(
      // color: Colors.blue,
      height: (mediaQuery.size.height -
              mediaQuery.padding.top -
              mediaQuery.padding.bottom) *
          0.40,
      width: (mediaQueryWidth > 500)
          ? mediaQuery.size.width * 0.4
          : mediaQuery.size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isUserLoggedInUsingEmailPassword == "false" ||
              isUserLoggedInUsingEmailPassword == null)
            ButtonTheme(
              minWidth: mediaQuery.size.width * 0.8,
              height: (mediaQuery.size.width > 500)
                  ? mediaQuery.size.height * 0.059
                  : mediaQuery.size.height * 0.05,
              child: RaisedButton(
                shape: StadiumBorder(),
                onPressed: () async {
                  Navigator.pushNamed(context, '/login');
                },
                child: Text(
                  'Login',
                  style: TextStyle(
                      color: MaterialColorGenerator.createMaterialColor(
                        Color.fromARGB(247, 220, 220, 220),
                      ),
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          if (isUserLoggedInUsingEmailPassword == "false" ||
              isUserLoggedInUsingEmailPassword == null)
            ButtonTheme(
              child: TextButton(
                onPressed: () {
                  try {
                    Navigator.pushNamed(context, '/signup');
                  } catch (e) {
                    AppLogger.printErrorLog('Some error occured', error: e);
                  }
                },
                child: Text(
                  'New To pssswd? Lets Sign Up',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            )
        ],
      ),
    );

    final _bioText = Container(
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
    );

    return Scaffold(
      body: WillPopScope(
        child: SafeArea(
            child: (mediaQueryWidth < 500)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // if (isUserLoggedInUsingEmailPassword == 'true') _logo,
                      _logo,
                      if (isUserLoggedInUsingEmailPassword == 'true') _pinput,
                      if (isUserLoggedInUsingEmailPassword != 'true')
                        _loginSignupButtons,
                      if (isUserLoggedInUsingEmailPassword != 'true') _bioText,
                    ],
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _logo,
                        if (isUserLoggedInUsingEmailPassword == 'true') _pinput,
                        if (isUserLoggedInUsingEmailPassword != 'true')
                          _loginSignupButtons,
                        if (isUserLoggedInUsingEmailPassword != 'true')
                          _bioText,
                      ],
                    ),
                  )),
        onWillPop: onWillPop,
      ),
    );
  }

  Future<bool> onWillPop() {
    // SystemNavigator.pop();
    return Future.value(false);
  }
}
