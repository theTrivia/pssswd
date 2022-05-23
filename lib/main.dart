import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_config/flutter_config.dart';
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

  runApp(const MyApp());
}

Future fetchEntries() async {
  var fetchedEntries = [];
  var db = FirebaseFirestore.instance;
  final res = await db.collection("password_entries").get().then((event) {
    for (var doc in event.docs) {
      var resDic = {
        "entry_id": doc.id,
        "data": doc.data(),
      };
      fetchedEntries.add(resDic);
      // print(fetchedEntries);
    }
  });
  print('11111');
  return fetchedEntries;
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // print(FlutterConfig.get('storageBucket'));
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
  int id = 0;

  void refreshData() {
    id++;
  }

  FutureOr onGoBack(dynamic value) {
    refreshData();
    setState(() {});
  }

  void navigateAddPasswordPage() {
    Route route =
        MaterialPageRoute(builder: (context) => AddPasswd(fetchEntries));
    Navigator.push(context, route).then(onGoBack);
  }

  late Future fetchedEntriesInApp;

  var initialVal = fetchEntries();

  @override
  Widget build(BuildContext context) {
    var valueForLife;

    print('2222');
    setState(() {});
    return FutureBuilder(
        future: fetchEntries(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text('Loading');
          }

          valueForLife = snapshot.data;

          return Column(children: [
            PasswdList(valueForLife, fetchEntries),
            RaisedButton(
              onPressed: () async {
                final data = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddPasswd(fetchEntries),
                  ),
                );
                setState(() {
                  valueForLife = data;
                });
                // print('ggggg');
                // print(valueForLife[0]);
              },
              child: Text('Add Psswd'),
            ),
          ]);
        });
  }
}
