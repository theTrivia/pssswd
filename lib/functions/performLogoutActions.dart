import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import '../providers/user_entries.dart';

class PerformLogoutActions {
  static performActions(context) async {
    final secureStorage = FlutterSecureStorage();
    await FirebaseAuth.instance.signOut();

    await secureStorage.deleteAll();
    await Provider.of<UserEntries>(context, listen: false).setEntriesToNull();
  }

  static onTapLogout(context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
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
                    PerformLogoutActions.performActions(context);

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
  }
}
