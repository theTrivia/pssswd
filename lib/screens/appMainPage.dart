import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:pssswd/screens/searchEntry.dart';

import '../components/navigationDrawer.dart';
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
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/searchEntry");
              },
              icon: Icon(Icons.search),
            ),
          ],
          title: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Image.asset(
              'assets/images/pssswd-grey-scale-logo.png',
              height: mediaQuery.size.height * 0.10,
            ),
          ),
        ),
        body: PasswdList(),
        drawer: NavigationDrawer(),
      ),
      onWillPop: onWillPop,
    );
  }

  Future<bool> onWillPop() {
    return Future.value(false);
  }
}
