import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:pssswd/editPassword.dart';
import 'package:pssswd/passwdList.dart';

import 'package:pssswd/providers/user_entries.dart';

import 'addPasswd.dart';
import 'functions/passwordDecrypter.dart';

class PasswdCard extends StatefulWidget {
  var domain;
  var password_key;
  var password;
  var entry_id;

  PasswdCard(this.domain, this.password, this.password_key, this.entry_id);

  @override
  State<PasswdCard> createState() => _PasswdCardState();
}

class _PasswdCardState extends State<PasswdCard> {
  @override
  Widget build(BuildContext context) {
    final passwd;

    passwd = widget.password;
    var editedVal;
    List editPasswordCallbackFunction(val) {
      editedVal = val;
      return editedVal;
    }

    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.domain),
              SizedBox(
                width: 210,
              ),
              IconButton(
                onPressed: () async {
                  var pss = PasswordDecrypter();
                  final decryptedPassword = await pss.getDecryptedPassword(
                      widget.password, widget.password_key);
                  // print('psssssssssssssss ${decryptedPassword}');
                  Clipboard.setData(ClipboardData(text: decryptedPassword));

                  Fluttertoast.showToast(
                    msg: 'pssswd copied!',
                    gravity: ToastGravity.CENTER,
                  );
                },
                icon: Icon(Icons.copy),
              ),
            ],
          ),
          IconButton(
              onPressed: () async {
                var res = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditPassword(
                        widget.domain, widget.password, widget.entry_id),
                  ),
                );
              },
              icon: Icon(Icons.edit)),
        ],
      ),
    );
  }
}
