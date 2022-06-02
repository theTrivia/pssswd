import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:pssswd/screens/editPassword.dart';
import 'package:pssswd/screens/passwdList.dart';

import 'package:pssswd/providers/user_entries.dart';

import '../screens/addPasswd.dart';
import '../functions/passwordDecrypter.dart';

class PasswdCard extends StatefulWidget {
  var name;
  var password_key;
  var password;
  var entry_id;
  var randForIV;
  // var masterPasword;
  var randForKeyToStore;

  PasswdCard(
    this.name,
    this.password,
    this.randForKeyToStore,
    this.randForIV,
    this.entry_id,
  );

  @override
  State<PasswdCard> createState() => _PasswdCardState();
}

class _PasswdCardState extends State<PasswdCard> {
  final secureStorage = new FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    final passwd;
    final mediaQuery = MediaQuery.of(context);

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
              Container(
                width: mediaQuery.size.width * 0.65,
                child: Text(
                  (widget.name.length > 15
                      ? '${widget.name.substring(0, 15)}...'
                      : widget.name),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  final secureStorage = new FlutterSecureStorage();
                  var masterPassword =
                      await secureStorage.read(key: 'masterPassword');
                  print(
                      'master password from password card!! -??????????????        ${masterPassword}');
                  print(
                      'master password from password card!! -??????????????        ${widget.randForKeyToStore}');
                  var pss = PasswordDecrypter();
                  final decryptedPassword = await pss.getDecryptedPassword(
                      widget.password,
                      widget.randForKeyToStore,
                      widget.randForIV,
                      masterPassword);
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
                var pss = PasswordDecrypter();
                // final decryptedPassword = await pss.getDecryptedPassword(
                //     widget.password, widget.password_key);
                var masterPassword =
                    await secureStorage.read(key: 'masterPassword');
                final decryptedPassword = await pss.getDecryptedPassword(
                    widget.password,
                    widget.randForKeyToStore,
                    widget.randForIV,
                    masterPassword);
                print(decryptedPassword);
                print(widget.name);
                print(widget.entry_id);
                var res = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditPassword(
                        widget.name, decryptedPassword, widget.entry_id),
                  ),
                );
              },
              icon: Icon(Icons.edit)),
        ],
      ),
    );
  }
}
