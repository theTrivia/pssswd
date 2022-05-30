import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import 'addPasswd.dart';
import 'passwdList.dart';
import '../providers/user_entries.dart';

class AppMainPage extends StatefulWidget {
  @override
  State<AppMainPage> createState() => _AppMainPageState();
}

class _AppMainPageState extends State<AppMainPage> {
  @override
  void initState() {
    super.initState();

    final data =
        Provider.of<UserEntries>(context, listen: false).fetchEntries();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final secureStorage = new FlutterSecureStorage();

    return Scaffold(
      appBar: AppBar(
        title: Text('pssswd'),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () async {
                await FirebaseAuth.instance.signOut();

                await secureStorage.deleteAll();
                await Provider.of<UserEntries>(context, listen: false)
                    .setEntriesToNull();

                Navigator.pushNamed(context, '/');
              },
              child: Icon(Icons.logout),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          PasswdList(),
          Container(
            // color: Colors.amber,
            height:
                (mediaQuery.size.height - AppBar().preferredSize.height) * 0.10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonTheme(
                  height: mediaQuery.size.height * 0.05,
                  minWidth: mediaQuery.size.width * 0.9,
                  // height: mediaQuery.size.height * 0.05,
                  child: RaisedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddPasswd(),
                        ),
                      );
                    },
                    child: const Text(
                      'Add pssswd',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    shape: StadiumBorder(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



// ButtonTheme(
//               height: mediaQuery.size.height * 0.05,
//               child: ElevatedButton(
//                 onPressed: () async {
//                   await Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => AddPasswd(),
//                     ),
//                   );
//                 },
//                 child: Text('Add pssswd'),
//               ),
//             ),