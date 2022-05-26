import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final LocalStorage storage = new LocalStorage('pssswd');
                    // await storage.setItem('isUserLoggedIn', true);
                    var a = storage.getItem('isUserLoggedIn');
                    print(a);
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Text('Login'),
                ),
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
