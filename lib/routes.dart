import 'package:flutter/material.dart';
import 'package:pssswd/screens/searchEntry.dart';

import '../screens/aboutUs.dart';
import '../screens/addPasswd.dart';
import '../screens/appMainPage.dart';
import '../screens/appSettings.dart';
import '../screens/editMasterPassword.dart';
import '../screens/landingPage.dart';
import '../screens/loginScreen.dart';
import '../screens/signupScreen.dart';

var routes = <String, WidgetBuilder>{
  "/": (context) => LandingPage(),
  "/login": (context) => LoginScreen(),
  "/signup": (context) => SignupScreen(),
  "/appMainPage": (context) => AppMainPage(),
  "/addPassword": (context) => AddPasswd(),
  "/settings": (context) => AppSettings(),
  "/aboutUs": (context) => AboutUs(),
  "/editMasterPassword": (context) => EditMasterPassword(),
  "/searchEntry": (context) => SearchEntry(),
};
