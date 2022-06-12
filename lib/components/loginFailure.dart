import 'package:flutter/material.dart';

class UserAuthFailureMessage {
  static showErrorMessage(String err) {
    if (err == 'wrong-password') {
      return Container(
        child: Text(
          'User Credential is invalid',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    if (err == 'unknown-error') {
      return Container(
        child: Text(
          'User Credential is invalid',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else if (err == 'user-not-found') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'User\'s Data not found.',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    } else if (err == 'invalid-email') {
      return Container(
        child: Text(
          'User Credential is invalid',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else if (err == 'master-password-invalid') {
      return Container(
        child: Text(
          'Please provide correct master password',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }
}
