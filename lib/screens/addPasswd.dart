import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:pssswd/functions/passwordEncrypter.dart';

import 'package:pssswd/models/passwd.dart';
import 'package:pssswd/providers/userDetails.dart';
import 'package:pssswd/providers/user_entries.dart';

class AddPasswd extends StatefulWidget {
  @override
  State<AddPasswd> createState() => _AddPasswdState();
}

class _AddPasswdState extends State<AddPasswd> {
  final enteredDomain = TextEditingController();

  final enteredPasswd = TextEditingController();
  // randomFunction() async {
  //   Provider.of<UserDetails>(context, listen: false).getUserDetails();
  // }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();

  //   randomFunction();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Passwd'),
        ),
        body: Form(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: [
                // Container(
                //   child: Text(context.watch<UserEntries>().entries.toString()),
                // ),
                Container(
                  child: Text(
                      context.watch<UserDetails>().getUserDetails.toString()),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Enter the domain',
                  ),
                  controller: enteredDomain,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Enter the passwd'),
                  controller: enteredPasswd,
                ),
                RaisedButton(
                  onPressed: () async {
                    Random random = new Random();
                    final newEntry = Passwd(
                      user_id: 'dummy_user_id' + random.nextInt(100).toString(),
                      domain: enteredDomain.text,
                      password: enteredPasswd.text,
                      timestamp: Timestamp.now(),
                    );

                    final secureStorage = new FlutterSecureStorage();

                    var masterPassword =
                        await secureStorage.read(key: 'masterPassword');

                    print(
                        'master password from add password screen!! -??????????????        ${masterPassword}');

                    var pss = PasswordEnrypter();
                    final encryptedPasswordMap = await pss.encryptPassword(
                        newEntry.password, masterPassword!);
                    // final encryptedPasswordMap =
                    //     await pss.aesCbcEncrypt("fdsugfdsfusdvfusdf","fsdfsduifuisbd",newEntry.password);

                    // print(
                    //     'Encrypted Pssword data ------------ ${encryptedPasswordMap['key']}');

                    // var decryptedPasswordpp =
                    // await pss.getDecryptedPassword(
                    //     encryptedPasswordMap['encryptedPassword'],
                    //     encryptedPasswordMap['key']);
                    // print(
                    //     'decrypted password data -------------- ${decryptedPasswordpp}');

                    final newEntryPush = {
                      "user_id": newEntry.user_id,
                      "domain": newEntry.domain,
                      "password": encryptedPasswordMap['encryptedPassword'],
                      "randForKeyToStore":
                          encryptedPasswordMap['randForKeyToStore'],
                      "randForIV": encryptedPasswordMap['randForIV'],
                      "timestamp": newEntry.timestamp,
                    };

                    if (newEntry.domain.isEmpty || newEntry.password.isEmpty) {
                      return;
                    }

                    var db = FirebaseFirestore.instance;
                    await db
                        .collection('password_entries')
                        .add(newEntryPush)
                        .then(
                          (value) => print('submitted: ${value.id}'),
                        );

                    await Provider.of<UserEntries>(context, listen: false)
                        .fetchEntries();
                    Navigator.pop(context);
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ));
  }
}
