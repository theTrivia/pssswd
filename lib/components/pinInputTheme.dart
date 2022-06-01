import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class PinInputTheme {
  static final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Color.fromARGB(255, 222, 222, 225)),
      borderRadius: BorderRadius.circular(20),
    ),
  );
  static final focusedPinTheme = defaultPinTheme.copyDecorationWith(
    border: Border.all(color: Color.fromARGB(255, 42, 49, 56)),
    borderRadius: BorderRadius.circular(8),
  );
  static final submittedPinTheme = defaultPinTheme.copyWith(
    decoration: defaultPinTheme.decoration!.copyWith(
      color: Color.fromRGBO(234, 239, 243, 1),
    ),
  );
}
