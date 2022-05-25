import 'dart:async';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_config/flutter_config.dart';
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

class MyApp extends StatelessWidget {
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final data =
        Provider.of<UserEntries>(context, listen: false).fetchEntries();
  }

//   @override
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Container(child: Text(context.watch<UserEntries>().entries.toString())),
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
    // final entriesState = Provider.of<UserEntries>(context);
    // entriesState.fetchEntries();
    // final entries = entriesState.getFirstTimeSetEntry;
    // print('------tararampam--------');
    // print(entries);
    // var valueForLife;

    // print('2222');
    // setState(() {});
    // UserEntries();

    // context.read<UserEntries>().fetchEntries();
    // return Column(
    //   children: [
    //     RaisedButton(onPressed: () {
    //       // context.read<UserEntries>().increment();
    //     }),
    //     Container(child: Text(context.watch<UserEntries>().aaa.toString())),
    //   ],
    // );

//     return FutureBuilder(
//         future: Provider.of<UserEntries>(context).fetchEntries(),
//         builder: (context, snapshot) {
//           print('ehllo');
//           if (context.watch<UserEntries>().entries == []) {
//             return Text('Loading');
//           }
//           // UserEntries();
//           // valueForLife = ;
//           // context.read<UserEntries>().fetchEntries();
//           // context.read<UserEntries>().setFirstTimeEntry(valueForLife);

//           return Column(children: [
//             // PasswdList(valueForLife, fetchEntries),
//             // PasswdList(),

//             Container(
//               child: Text(context.watch<UserEntries>().entries.toString()),
//             ),

// /////////
// /////////
//             RaisedButton(
//               onPressed: () async {
//                 await Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => AddPasswd(),
//                   ),
//                 );
//               },
//               child: Text('Add pssswd'),
//             ),

// ////
// //////

//             // RaisedButton(
//             //   onPressed: () async {
//             //     final data = await Navigator.push(
//             //       context,
//             //       MaterialPageRoute(
//             //         builder: (context) => AddPasswd(fetchEntries),
//             //       ),
//             //     );
//             //     setState(() {
//             //       valueForLife = data;
//             //     });
//             //   },
//             //   child: Text('Add Psswd'),
//             // ),
//           ]);
//         });
  }
}
