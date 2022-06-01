import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

  var _isPasswordVisible = false;

  TextEditingController get newDomainContrEditollerc =>
      TextEditingController(text: widget.domain);

  var newPasswordValue = '';
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    // print(widget.password);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Password'),
      ),
      body: ListView(
        children: [
          Form(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 20, right: 10, left: 10, bottom: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  // color: Colors.grey,
                  width: double.infinity,
                  height: mediaQuery.size.height * 0.15,
                  child: Center(
                    child: Text(
                      (widget.domain.length > 10
                          ? '${widget.domain.substring(0, 7)}...'
                          : widget.domain),
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      'Current Password',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Container(
                          width: mediaQuery.size.width * 0.6,
                          height: mediaQuery.size.height * 0.06,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            border: Border.all(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Center(
                            child: Text(
                              _isPasswordVisible
                                  ? '${widget.password}'
                                  : '********',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(text: widget.password),
                            );
                            Fluttertoast.showToast(
                              msg: 'pssswd copied!',
                              gravity: ToastGravity.CENTER,
                            );
                          },
                          icon: Icon(Icons.copy)),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              if (_isPasswordVisible) {
                                _isPasswordVisible = false;
                              } else {
                                _isPasswordVisible = true;
                              }
                            });
                          },
                          icon: Icon(Icons.remove_red_eye))
                    ],
                  ),
                ],
              ),
              Form(
                child: Column(
                  children: [
                    ChangePassword(
                      widget.entry_id,
                      widget.domain,
                      newPasswordValue,
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
