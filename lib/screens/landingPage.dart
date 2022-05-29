import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:provider/provider.dart';

import '../functions/masterPasswordHash.dart';

import '../providers/user_entries.dart';
import 'appMainPage.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final secureStorage = new FlutterSecureStorage();

  var isUserLoggedInUsingEmailPassword;
  final masterPasswordController = TextEditingController();

  fetchisUserLoggedInUsingEmailPassword() async {
    // final LocalStorage storage = new LocalStorage('pssswd');
    // await storage.ready;

    // isUserLoggedInUsingMasterPassword =
    //     storage.getItem('isUserLoggedInUsingMasterPassword');

    // print('aaaaaaaaaaaaa before-> ${isUserLoggedInUsingMasterPassword}');
    // final prefs = await SharedPreferences.getInstance();
    var isUserLoggedInUsingEmailPasswordFromDisk =
        await secureStorage.read(key: 'isUserLoggedInUsingEmailPassword');

    // var isUserLoggedInUsingEmailPasswordFromDisk =
    //     prefs.getBool('isUserLoggedInUsingEmailPassword');
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
            if (isUserLoggedInUsingEmailPassword == 'true')
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Master Password'),
                      controller: masterPasswordController,
                    ),
                    RaisedButton(
                      onPressed: () async {
                        // await Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => AppMainPage(),
                        //   ),
                        // );
                        // final prefs = await SharedPreferences.getInstance();
                        // var masterPasswordHash = prefs.getString(
                        //   'masterPasswordHash',
                        // );

                        var masterPasswordHash =
                            await secureStorage.read(key: 'masterPasswordHash');

                        print('-----------${masterPasswordHash}');
                        // if (masterPasswordHash == null) {
                        //   Navigator.pushNamed(context, '/login');
                        // }

                        final mph = MasterPasswordHash();
                        var res = mph.checkIfMasterPasswordValid(
                            masterPasswordController.text, masterPasswordHash);
                        print(res);

                        if (res == true) {
                          final secureStorage = new FlutterSecureStorage();
                          var masterPassword = await secureStorage.write(
                              key: 'masterPassword',
                              value: masterPasswordController.text);

                          // if (_isMasterPasswordPresent != null) {

                          // var userId = await prefs.getString('loggedInUserId');
                          var userId =
                              await secureStorage.read(key: 'loggedInUserId');
                          // Provider.of<UserEntries>(context, listen: false)
                          //     .setUid(userId);
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AppMainPage(),
                            ),
                          );
                          // }
                        } else {
                          print('you are an idiot!!!');

                          return;
                        }
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
                if (isUserLoggedInUsingEmailPassword == "false" ||
                    isUserLoggedInUsingEmailPassword == null)
                  ElevatedButton(
                    onPressed: () async {
                      // var abc =
                      //     storage.getItem('isUserLoggedInUsingEmailPassword');
                      // print(abc);
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text('Login'),
                  ),
                if (isUserLoggedInUsingEmailPassword == "false" ||
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
