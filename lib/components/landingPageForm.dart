import 'package:flutter/material.dart';

import '../functions/app_logger.dart';
import '../functions/materialColorGenerator.dart';

class LandingPageForm extends StatelessWidget {
  var isUserLoggedInUsingEmailPassword;
  LandingPageForm(this.isUserLoggedInUsingEmailPassword);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Column(
      children: [
        if (isUserLoggedInUsingEmailPassword != 'true')
          Container(
              height: (mediaQuery.size.height -
                      mediaQuery.padding.top -
                      mediaQuery.padding.bottom) *
                  0.40,
              width: mediaQuery.size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isUserLoggedInUsingEmailPassword == "false" ||
                      isUserLoggedInUsingEmailPassword == null)
                    ButtonTheme(
                      minWidth: mediaQuery.size.width * 0.8,
                      height: mediaQuery.size.height * 0.05,
                      child: RaisedButton(
                        shape: StadiumBorder(),
                        onPressed: () async {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                              color: MaterialColorGenerator.createMaterialColor(
                                Color.fromARGB(247, 220, 220, 220),
                              ),
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  if (isUserLoggedInUsingEmailPassword == "false" ||
                      isUserLoggedInUsingEmailPassword == null)
                    ButtonTheme(
                      child: TextButton(
                        onPressed: () {
                          try {
                            Navigator.pushNamed(context, '/signup');
                          } catch (e) {
                            AppLogger.printErrorLog('Some error occured',
                                error: e);
                          }
                        },
                        child: Text(
                          'New To pssswd? Lets Sign Up',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              )),
        if (isUserLoggedInUsingEmailPassword != 'true')
          Container(
            height: (mediaQuery.size.height -
                    mediaQuery.padding.top -
                    mediaQuery.padding.bottom) *
                0.05,
            child: Text(
              'Made in 🇮🇳 with ❤️ by Soham Pal',
              style: TextStyle(
                color: MaterialColorGenerator.createMaterialColor(
                    Color.fromARGB(247, 14, 14, 14)),
              ),
            ),
          )
      ],
    );
  }
}
