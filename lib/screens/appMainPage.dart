import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:pssswd/functions/app_logger.dart';

import './passwdList.dart';
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
          title: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Image.asset(
              'assets/images/pssswd-grey-scale-logo.png',
              height: mediaQuery.size.height * 0.10,
            ),
          ),
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () {
                  try {
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
                                    try {
                                      Navigator.pop(context);
                                    } catch (e) {
                                      AppLogger.printErrorLog(
                                          'Some error occured',
                                          error: e);
                                    }
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
                                    try {
                                      await FirebaseAuth.instance.signOut();

                                      await secureStorage.deleteAll();
                                      await Provider.of<UserEntries>(context,
                                              listen: false)
                                          .setEntriesToNull();

                                      Navigator.pushNamed(context, '/');
                                    } catch (e) {
                                      AppLogger.printErrorLog(
                                          'Some error occured',
                                          error: e);
                                    }
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
                  } catch (e) {
                    AppLogger.printErrorLog('Some error occured', error: e);
                  }
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
