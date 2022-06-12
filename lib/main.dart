import 'dart:io';

import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter_config/flutter_config.dart';

import 'package:pssswd/functions/passwordEncrypter.dart';
import 'package:pssswd/functions/userLogin.dart';
import 'package:pssswd/functions/userSignup.dart';

import 'package:pssswd/providers/user_entries.dart';
import 'package:pssswd/screens/appSettings.dart';
import 'package:pssswd/screens/donate.dart';
import 'package:pssswd/screens/landingPage.dart';
import 'package:pssswd/screens/loginScreen.dart';
import 'package:pssswd/screens/signupScreen.dart';
import 'firebase_options.dart';

import 'package:pssswd/screens/addPasswd.dart';
import 'package:pssswd/screens/passwdList.dart';

import 'functions/materialColorGenerator.dart';
import 'screens/aboutUs.dart';
import 'screens/appMainPage.dart';

import 'package:pssswd/components/exportUserEntries.dart';

import 'package:pssswd/screens/editMasterPassword.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:desktop_window/desktop_window.dart';

import './providers/user_entries.dart';
import './screens/landingPage.dart';
import './screens/loginScreen.dart';
import './screens/signupScreen.dart';
import './firebase_options.dart';
import './functions/materialColorGenerator.dart';
import './screens/appMainPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await DesktopWindow.setMaxWindowSize(Size(800, 800));
    await DesktopWindow.setMinWindowSize(Size(500, 800));
  }
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setPathUrlStrategy();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => UserEntries(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: MaterialColorGenerator.createMaterialColor(
            Color.fromARGB(247, 14, 14, 14)),
      ),
      initialRoute: '/',
      routes: {
        "/": (context) => LandingPage(),
        "/login": (context) => LoginScreen(),
        "/signup": (context) => SignupScreen(),
        "/appMainPage": (context) => AppMainPage(),
        "/addPassword": (context) => AddPasswd(),
        "/settings": (context) => AppSettings(),
        "/donate": (context) => Donate(),
        "/aboutUs": (context) => AboutUs(),
        "/editMasterPassword": (context) => EditMasterPassword(),
        "/exportUserEntries": (context) => ExportUserEntries(),
      },
    );
  }
}
