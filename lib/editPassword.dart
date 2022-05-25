import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pssswd/providers/user_entries.dart';

class EditPassword extends StatelessWidget {
  final password;
  final domain;
  final entry_id;
  // Function callback;
  // Function editPasswordCallbackFunction;
  // Function fetchEntries;

  // EditPassword(this.domain, this.password, this.entry_id, this.fetchEntries,
  //     this.editPasswordCallbackFunction);
  EditPassword(this.domain, this.password, this.entry_id);

  final newPasswordController = TextEditingController();
  TextEditingController get newDomainContrEditollerc =>
      TextEditingController(text: domain);

  @override
  Widget build(BuildContext context) {
    print(password);
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Password'),
        ),
        body: Form(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: Text(
                  domain,
                  style: TextStyle(
                    fontSize: 30,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Enter new Password'),
              controller: newPasswordController,
            ),
            RaisedButton(
              onPressed: () async {
                // await Future.delayed(Duration(seconds: 5));
                var db = FirebaseFirestore.instance;
                await db
                    .collection('password_entries')
                    .doc(entry_id)
                    .delete()
                    .then((value) => print('doc deleted'));
              },
              child: Text('Change Password'),
            ),
            TextButton(
              onPressed: () async {
                var db = FirebaseFirestore.instance;

                await db
                    .collection("password_entries")
                    .doc(entry_id)
                    .delete()
                    .then(
                      (doc) => print("Document deleted"),
                      onError: (e) => print("Error updating document $e"),
                    );
                await Provider.of<UserEntries>(context, listen: false)
                    .fetchEntries();
                Navigator.pop(context);
              },
              child: Text('Delete pssswd entry'),
            ),
          ]),
        ));
  }
}
