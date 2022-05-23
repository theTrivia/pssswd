import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pssswd/editPassword.dart';
import 'package:pssswd/passwdList.dart';

import 'addPasswd.dart';

class PasswdCard extends StatelessWidget {
  var domain;
  var password;
  var entry_id;
  Function fetchEntries;
  PasswdCard(this.domain, this.password, this.entry_id, this.fetchEntries);

  @override
  Widget build(BuildContext context) {
    final passwd;

    passwd = password;
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
              Text(domain),
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
              onPressed: () async {
                // print(passwd);

                // final data = await Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => EditPassword(domain, passwd, entry_id,
                //         fetchEntries, editPasswordCallbackFunction),
                //   ),
                // );
                // print('coding4life');
                // print(data);
              },
              icon: Icon(Icons.edit)),
        ],
      ),
    );
  }
}
