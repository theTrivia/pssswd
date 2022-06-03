import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          // title: Text('pssswd'),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 11),
            child: Image.asset(
              'assets/images/pssswd-logos_white-trial.png',
              height: mediaQuery.size.height * 0.16,
              // fit: BoxFit.contain,
            ),
          ),

          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            // title: Text('Log Out?'),
                            content: Text(
                              'Leave pssswd?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Go Back',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await FirebaseAuth.instance.signOut();

                                  await secureStorage.deleteAll();
                                  await Provider.of<UserEntries>(context,
                                          listen: false)
                                      .setEntriesToNull();

                                  Navigator.pushNamed(context, '/');
                                },
                                child: Text(
                                  'Logout',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ));
                },
                child: Icon(Icons.logout),
              ),
            ),
          ],
        ),
        body: PasswdList(),
      ),
      onWillPop: onWillPop,
    );
  }

  Future<bool> onWillPop() {
    return Future.value(false);
  }
}
