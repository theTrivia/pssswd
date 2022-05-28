import 'dart:convert';

import 'package:crypt/crypt.dart';

import 'package:crypto/crypto.dart';

void main() {
  hashMasterPassword(String masterPassword) {
    // final _hashedPassword = Crypt.sha512(masterPassword);
    // print(
    //     'hased master password from fucntions ----->       ${_hashedPassword}');
    // print(_hashedPassword);
    // print(_hashedPassword.runtimeType);

    var bytes = utf8.encode(masterPassword);
    var digest = sha256.convert(bytes);

    print(bytes.runtimeType);
    print(bytes);
    print(digest);
    print(digest.runtimeType);
  }

  checkIfMasterPasswordValid(masterPassword, hashedMasterPassword) {
    var bytes = utf8.encode(masterPassword);
    var digest = sha256.convert(bytes);

    print(digest);

    if (digest.toString() == hashedMasterPassword.toString()) {
      print('true');
    } else {
      print('false');
    }
  }

  // var abc = "$5$CYksjbH6Ns64kmKW$cAeCgnoM49RT7HS2oMjgWpNdFP4P9./sc3lV2LxSGrA";

  hashMasterPassword('12345');
  checkIfMasterPasswordValid('12345',
      '5994471abb01112afcc18159f6cc74b4f511b99806da59b3caf5a9c173cacfc5');
  // checkIfMasterPasswordValid('12345',
  //     "\$5\$CYksjbH6Ns64kmKW\$cAeCgnoM49RT7HS2oMjgWpNdFP4P9./sc3lV2LxSGrA");

  abc(str) {
    var a = str.split('\$');
  }
}
