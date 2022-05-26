import 'package:flutter/material.dart';
import 'package:flutter_string_encryption/flutter_string_encryption.dart';

class SomeNewPage extends StatefulWidget {
  @override
  State<SomeNewPage> createState() => _SomeNewPageState();
}

class _SomeNewPageState extends State<SomeNewPage> {
  TextEditingController pass = TextEditingController();
  var key = "null";
  late String encryptedS, decryptedS;
  var password = "null";
  late PlatformStringCryptor cryptor;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Password Encrypt"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: TextField(
                controller: pass,
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.blue)),
                  isDense: true, // Added this
                  contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                ),
                cursorColor: Colors.white,
              ),
            ),
            RaisedButton(
              onPressed: () {
                Encrypt();
              },
              child: Text("Encrypt"),
            ),
            RaisedButton(
              onPressed: () {
                Decrypt();
              },
              child: Text("Decrypt"),
            ),
          ],
        ),
      ),
    );
  }

// method to Encrypt String Password
  void Encrypt() async {
    cryptor = PlatformStringCryptor();
    final salt = await cryptor.generateSalt();
    password = pass.text;
    key = await cryptor.generateKeyFromPassword(password, salt);
    // here pass the password entered by user and the key
    encryptedS = await cryptor.encrypt(password, key);
    print(key);
    print(encryptedS);
  }

// method to decrypt String Password
  void Decrypt() async {
    try {
      //here pass encrypted string and the key to decrypt it
      decryptedS = await cryptor.decrypt(
          "2eDXlDsDcWSJzMWYFGurrw==:jxHniO5fo0tqpCpyK7XC/UWa+akWzcnJ8cLRTvT51xo=:O8K9aKVRZIM6LK0L43wf5A==",
          "RBFQL6yjxLQXrDvwccvlpQ==:FZjP9hj46KeYj2dYPrjkqiRxyEsZJtH2iXyDALTStWc=");
      print(decryptedS);
    } on MacMismatchException {}
  }
}
