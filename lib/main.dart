import 'dart:async';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

import 'screens/appMainPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await dotenv.load(fileName: '.env');
  await FlutterConfig.loadEnvVariables();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => UserEntries(),
      ),
      // ChangeNotifierProvider(
      //   create: (_) => UserDetails(),
      // ),
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
  void initState() {
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: LandingPage(),

      // home: Scaffold(
      //   appBar: AppBar(
      //     title: Text('Pssswd'),
      //   ),
      //   body: AppMainPage(),
      // ),
      // routes: {
      //   '/addPasswd': (context) => AddPasswd(fetchEntries),
      // },

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
