import 'package:flutter/material.dart';
import 'package:pssswd/functions/userSignup.dart';

class SignupScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            ElevatedButton(
              onPressed: () async {
                var signupObject = UserSignup();
                var res = await signupObject.performSignup(
                  emailController.text,
                  passwordController.text,
                );
                // print(res);
                if (res == 'signup-success') {
                  Navigator.pushNamed(context, '/appMainPage');
                }

                // var res = await Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => AppMainPage(),
                //   ),
                // );
              },
              child: Text('Signup'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
