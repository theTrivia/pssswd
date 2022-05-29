import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/userDetails.dart';
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
                // final prefs = await SharedPreferences.getInstance();
                // await prefs.remove('isUserLoggedInUsingEmailPassword');
                // await prefs.remove('masterPasswordHash');
                // await prefs.remove('loggedInUserId');

                await secureStorage.deleteAll();

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
      ),
    );
  }
}
