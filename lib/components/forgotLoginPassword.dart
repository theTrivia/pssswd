import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pssswd/functions/app_logger.dart';

class ForgotLoginPassword extends StatelessWidget {
  final _emailHandler = TextEditingController();
  GlobalKey<FormState> _forgotPasswordFormValidationKey =
      GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => Form(
              key: _forgotPasswordFormValidationKey,
              child: AlertDialog(
                content: TextFormField(
                  controller: _emailHandler,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (val) {
                    if (!(val!.contains('@') && val.contains('.')) ||
                        val.isEmpty) {
                      return "Please enter an valid email id";
                    }
                    return null;
                  },
                ),
                actions: [
                  ButtonTheme(
                    shape: StadiumBorder(),
                    child: RaisedButton(
                      onPressed: () async {
                        try {
                          if (!_forgotPasswordFormValidationKey.currentState!
                              .validate()) {
                            return;
                          }
                          await FirebaseAuth.instance.sendPasswordResetEmail(
                              email: _emailHandler.text);

                          AppLogger.printInfoLog(
                              'Reset Password mail sent successfully');
                          Fluttertoast.showToast(
                              msg: "Please Check your registered Email",
                              toastLength: Toast.LENGTH_LONG);
                          Navigator.pushNamed(context, '/');
                        } catch (e) {
                          Fluttertoast.showToast(
                              msg: "Some error occured",
                              toastLength: Toast.LENGTH_LONG);
                          AppLogger.printErrorLog('Some error occured',
                              error: e);
                        }
                      },
                      child: Text(
                        'Send email',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
        child: Text('Forgot Password'));
  }
}
