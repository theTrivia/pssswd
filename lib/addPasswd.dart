import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:pssswd/models/passwd.dart';

class AddPasswd extends StatefulWidget {
  Function refreshEntries;
  AddPasswd(this.refreshEntries);

  @override
  State<AddPasswd> createState() => _AddPasswdState();
}

class _AddPasswdState extends State<AddPasswd> {
  final enteredDomain = TextEditingController();

  final enteredPasswd = TextEditingController();

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
                    //backend logic to be implemented
                    Random random = new Random();
                    final newEntry = Passwd(
                      user_id: 'dummy_user_id' + random.nextInt(100).toString(),
                      domain: enteredDomain.text,
                      password: enteredPasswd.text,
                      timestamp: Timestamp.now(),
                    );

                    final newEntryPush = {
                      "user_id": newEntry.user_id,
                      "domain": newEntry.domain,
                      "password": newEntry.password,
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
                    var val = await widget.refreshEntries();
                    print('vaaaaaal');
                    print(val[0]);

                    Navigator.pop(context, val);
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ));
  }
}
