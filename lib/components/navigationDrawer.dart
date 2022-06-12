import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../functions/performLogoutActions.dart';

class NavigationDrawer extends StatefulWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  var userEmail;
  final secureStorage = FlutterSecureStorage();

  getUserEmail() async {
    var email = await secureStorage.read(key: 'email');
    setState(() {
      userEmail = email;
    });
  }

  void initState() {
    super.initState();
    getUserEmail();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: mediaQuery.size.height * 0.15,
            child: DrawerHeader(
              child: Text(
                (userEmail != null) ? userEmail : 'No Email found',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            ),
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Add Password'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/addPassword');
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About Us'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/aboutUs');
            },
          ),
          ListTile(
            leading: Icon(Icons.currency_rupee),
            title: Text('Donate'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/donate');
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log Out'),
            onTap: () async {
              Navigator.pop(context);
              PerformLogoutActions.onTapLogout(context);
            },
          ),
        ],
      ),
    );
  }
}
