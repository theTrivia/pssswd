import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pssswd/editPassword.dart';
import 'package:pssswd/passwdList.dart';
import 'package:pssswd/providers/user_entries.dart';

import 'addPasswd.dart';

class PasswdCard extends StatefulWidget {
  var domain;
  var password;
  var entry_id;
  // Function fetchEntries;
  // PasswdCard(this.domain, this.password, this.entry_id, this.fetchEntries);
  PasswdCard(this.domain, this.password, this.entry_id);

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
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: passwd));
                  const snackBar = SnackBar(
                    content: Text('Password Copied'),
                    duration: Duration(seconds: 1),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                icon: Icon(Icons.copy),
              ),
            ],
          ),
          IconButton(
              // onPressed: () async {
              //   // print(passwd);

              //   // final data = await Navigator.push(
              //   //   context,
              //   //   MaterialPageRoute(
              //   //     builder: (context) => EditPassword(domain, passwd, entry_id,
              //   //         fetchEntries, editPasswordCallbackFunction),
              //   //   ),
              //   // );
              //   // print('coding4life');
              //   // print(data);
              // },
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditPassword(
                        widget.domain, widget.password, widget.entry_id),
                  ),
                );
                const snackBar = SnackBar(
                  content: Text('Password Deleted'),
                  duration: Duration(seconds: 1),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              icon: Icon(Icons.edit)),
        ],
      ),
    );
  }
}
