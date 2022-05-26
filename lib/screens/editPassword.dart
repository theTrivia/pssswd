import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:pssswd/components/deletePasswordEntry.dart';
import 'package:pssswd/main.dart';

import 'package:pssswd/providers/user_entries.dart';

import '../components/changePassword.dart';

class EditPassword extends StatefulWidget {
  final password;
  final domain;
  final entry_id;

  EditPassword(this.domain, this.password, this.entry_id);

  @override
  State<EditPassword> createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  @override
  final newPasswordController = TextEditingController();

  TextEditingController get newDomainContrEditollerc =>
      TextEditingController(text: widget.domain);

  var newPasswordValue = '';
  @override
  Widget build(BuildContext context) {
    // print(widget.password);
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
                  widget.domain,
                  style: TextStyle(
                    fontSize: 30,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Text('Current Password: ${widget.password}'),
            TextFormField(
              decoration: InputDecoration(labelText: 'Enter new Password'),
              controller: newPasswordController,
              onChanged: (text) {
                setState(() {
                  newPasswordValue = text;
                });
              },
            ),
            ChangePassword(widget.entry_id, widget.domain, newPasswordValue),
            DeletePasswordEntry(widget.entry_id),
          ]),
        ));
  }
}
