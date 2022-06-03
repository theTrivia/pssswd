import 'dart:async';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_config/flutter_config.dart';

import 'package:pssswd/functions/passwordEncrypter.dart';
import 'package:pssswd/functions/userLogin.dart';
import 'package:pssswd/functions/userSignup.dart';

import 'package:pssswd/providers/user_entries.dart';
import 'package:pssswd/screens/landingPage.dart';
import 'package:pssswd/screens/loginScreen.dart';
import 'package:pssswd/screens/signupScreen.dart';
import 'firebase_options.dart';

import 'package:pssswd/screens/addPasswd.dart';
import 'package:pssswd/screens/passwdList.dart';

import 'functions/materialColorGenerator.dart';
import 'screens/appMainPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await FlutterConfig.loadEnvVariables();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
    // final Color color = HexColor.fromHex('#aabbcc');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: MaterialColorGenerator.createMaterialColor(
            Color.fromARGB(247, 14, 14, 14)),
        // textSelectionColor: createMaterialColor(Color(0xFF636363)),
      ),
      initialRoute: '/',
      routes: {
        "/": (context) => LandingPage(),
        "/login": (context) => LoginScreen(),
        "/signup": (context) => SignupScreen(),
        "/appMainPage": (context) => AppMainPage(),
      },
    );
  }
}
