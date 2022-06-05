import 'package:flutter/material.dart';

import '../components/deletePasswordEntry.dart';
import '../components/editEntry.dart';

class EditEntryPage extends StatefulWidget {
  final String password;
  final String name;
  final String entry_id;
  final String username;
  final String url;

  EditEntryPage(
    this.name,
    this.username,
    this.password,
    this.url,
    this.entry_id,
  );

  @override
  State<EditEntryPage> createState() => _EditEntryPageState();
}

class _EditEntryPageState extends State<EditEntryPage> {
  final newPasswordController = TextEditingController();

  TextEditingController get newNameController =>
      TextEditingController(text: widget.name);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Password'),
      ),
      body: ListView(
        children: [
          Form(
            child: Column(children: [
              Form(
                child: Column(
                  children: [
                    EditEntry(
                      widget.entry_id,
                      widget.name,
                      widget.username,
                      widget.password,
                      widget.url,
                    ),
                  ],
                ),
              ),
              DeletePasswordEntry(widget.entry_id),
            ]),
          ),
        ],
      ),
    );
  }
}
