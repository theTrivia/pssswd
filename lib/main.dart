import 'dart:async';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:pssswd/SomeNewPage.dart';
import 'package:pssswd/functions/passwordEncrypter.dart';

import 'package:pssswd/providers/user_entries.dart';
import 'firebase_options.dart';

import 'package:pssswd/addPasswd.dart';
import 'package:pssswd/passwdList.dart';

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
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Pssswd'),
        ),
        body: Body(),
      ),
      // routes: {
      //   '/addPasswd': (context) => AddPasswd(fetchEntries),
      // },
    );
  }
}

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    super.initState();
    final data =
        Provider.of<UserEntries>(context, listen: false).fetchEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // RaisedButton(onPressed: () {
        //   Navigator.push(
        //       context, MaterialPageRoute(builder: (context) => SomeNewPage()));
        // }),
        PasswdList(),
        RaisedButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddPasswd(),
              ),
            );
          },
          child: Text('Add pssswd'),
        ),
      ],
    );
  }
}
