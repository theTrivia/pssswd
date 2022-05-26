import 'package:flutter/material.dart';

class LoginFailure extends StatelessWidget {
  const LoginFailure({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Invalid email or password. Are you high bro?'),
    );
  }
}
