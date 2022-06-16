import 'package:flutter/material.dart';

import '../functions/performLogoutActions.dart';

class Logout {
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
                    await PerformLogoutActions.performLogoutChores(context);

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
