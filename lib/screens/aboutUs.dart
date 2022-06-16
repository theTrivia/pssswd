import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('About Us')),
      body: Column(
        children: [
          Container(
            height: mediaQuery.size.height * 0.35,
            width: mediaQuery.size.width,
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset(
                'assets/images/pssswd-gs-clipped.png',
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Version : 1.2.0',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text('Shoutout to Shalini for designing the logo.'),
          TextButton(
            onPressed: () async {
              if (await canLaunch("https://www.instagram.com/artbylinie/") ==
                  true) {
                launch("https://www.instagram.com/artbylinie/");
              } else {
                print("Can't launch URL");
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Catch her on '),
                FaIcon(FontAwesomeIcons.instagram)
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'pssswd is a Free and Open Source Password Management Application. Currently available on iOS, Android, macOS and Windows',
            textAlign: TextAlign.center,
          ),
          TextButton(
            onPressed: () async {
              if (await canLaunch("https://github.com/theTrivia/pssswd") ==
                  true) {
                launch("https://github.com/theTrivia/pssswd");
              } else {
                print("Can't launch URL");
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Wanna contribute to pssswd? '),
                FaIcon(FontAwesomeIcons.github)
              ],
            ),
          ),
          TextButton(
            onPressed: () async {
              if (await canLaunch(
                      "https://github.com/theTrivia/pssswd/blob/main/privacy_policy") ==
                  true) {
                launch(
                    "https://github.com/theTrivia/pssswd/blob/main/privacy_policy");
              } else {
                print("Can't launch URL");
              }
            },
            child: Text(
              'Terms and Conditions',
              style: TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
