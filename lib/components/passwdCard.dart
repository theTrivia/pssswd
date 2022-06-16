import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pssswd/functions/app_logger.dart';

import '../screens/editEntryPage.dart';
import '../functions/passwordDecrypter.dart';

class PasswdCard extends StatefulWidget {
  final String name;
  final String username;
  final String password;
  final String entry_id;
  final String randForIV;
  final String url;

  final String randForKeyToStore;

  PasswdCard(
    this.name,
    this.username,
    this.password,
    this.url,
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
    final mediaQuery = MediaQuery.of(context);

    var editedVal;
    List editPasswordCallbackFunction(val) {
      editedVal = val;
      return editedVal;
    }

    return Card(
      elevation: 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              width: mediaQuery.size.width * 0.65,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (widget.name.length > 15
                        ? '${widget.name.substring(0, 15)}...'
                        : widget.name),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const Divider(
                    thickness: 0.5,
                    endIndent: 0,
                    color: Color.fromARGB(88, 91, 91, 91),
                  ),
                  Text(
                    (widget.name.length > 15
                        ? '${widget.name.substring(0, 15)}...'
                        : widget.username),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () async {
                  try {
                    final secureStorage = new FlutterSecureStorage();
                    var masterPassword =
                        await secureStorage.read(key: 'masterPassword');

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
                  } catch (e) {
                    AppLogger.printErrorLog('Some error occured', error: e);
                  }
                },
                icon: Icon(Icons.copy),
              ),
              IconButton(
                onPressed: () async {
                  try {
                    var pss = PasswordDecrypter();
                    var masterPassword =
                        await secureStorage.read(key: 'masterPassword');
                    final decryptedPassword = await pss.getDecryptedPassword(
                        widget.password,
                        widget.randForKeyToStore,
                        widget.randForIV,
                        masterPassword);
                    var res = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditEntryPage(
                          widget.name,
                          widget.username,
                          decryptedPassword,
                          widget.url,
                          widget.entry_id,
                        ),
                      ),
                    );
                  } catch (e) {
                    AppLogger.printErrorLog('Some error occured', error: e);
                  }
                },
                icon: Icon(Icons.edit),
              ),
            ],
          )
        ],
      ),
    );
  }
}
