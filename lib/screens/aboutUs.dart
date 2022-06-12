import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('About Us')),
      body: Column(children: [
        Container(
          // height: mediaQuery.size.height * 0.35,
          // width: mediaQuery.size.width,
          color: Theme.of(context).primaryColor,
          child: Image.asset(
            'assets/images/pssswd-grey-scale-logo.png',
            // height: mediaQuery.size.height * 0.10,
          ),
          // padding: EdgeInsets.only(bottom: 15, left: 15),
        ),
      ]),
    );
  }
}
