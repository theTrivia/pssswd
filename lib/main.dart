import 'dart:io';

import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
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
        "/editMasterPassword": (context) => EditMasterPassword(),
      },
    );
  }
}
