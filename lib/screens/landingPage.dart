import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'appMainPage.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  var isUserLoggedInUsingEmailPassword;

  fetchisUserLoggedInUsingEmailPassword() async {
    // final LocalStorage storage = new LocalStorage('pssswd');
    // await storage.ready;

    // isUserLoggedInUsingMasterPassword =
    //     storage.getItem('isUserLoggedInUsingMasterPassword');

    // print('aaaaaaaaaaaaa before-> ${isUserLoggedInUsingMasterPassword}');
    final prefs = await SharedPreferences.getInstance();
    var isUserLoggedInUsingEmailPasswordFromDisk =
        prefs.getBool('isUserLoggedInUsingEmailPassword');
    print('aaaaaaaaaaaaa before-> ${isUserLoggedInUsingEmailPasswordFromDisk}');
    setState(() {
      isUserLoggedInUsingEmailPassword =
          isUserLoggedInUsingEmailPasswordFromDisk;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchisUserLoggedInUsingEmailPassword();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('pssswd')),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(
              'assets/images/pssswd.jpeg',
              // height: 100,
              // width: 100,
            ),
            if (isUserLoggedInUsingEmailPassword == true)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Master Password'),
                    ),
                    RaisedButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AppMainPage(),
                          ),
                        );
                      },
                      child: Text('Login'),
                    ),
                  ],
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // if (isUserLoggedInUsingMasterPassword)
                if (isUserLoggedInUsingEmailPassword == false ||
                    isUserLoggedInUsingEmailPassword == null)
                  ElevatedButton(
                    onPressed: () async {
                      final LocalStorage storage = new LocalStorage('pssswd');

                      // var abc =
                      //     storage.getItem('isUserLoggedInUsingEmailPassword');
                      // print(abc);
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text('Login'),
                  ),
                if (isUserLoggedInUsingEmailPassword == false ||
                    isUserLoggedInUsingEmailPassword == null)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: Text('Sign Up'),
                  )
              ],
            )
          ],
        ),
      ),
    );
  }
}
