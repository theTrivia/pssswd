import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../functions/app_logger.dart';
import '../providers/user_entries.dart';

class DeletePasswordEntry extends StatelessWidget {
  var entry_id;
  DeletePasswordEntry(this.entry_id);
  final secureStorage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final mediaQueryWidth = mediaQuery.size.width;

    return ButtonTheme(
      minWidth: (mediaQueryWidth > 600)
          ? mediaQuery.size.width * 0.4
          : mediaQuery.size.width * 0.8,
      buttonColor: Colors.red,
      shape: StadiumBorder(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RaisedButton(
          onPressed: () async {
            try {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    height: 200,
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            'Are you sure about deleting the entry?',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          ButtonTheme(
                            minWidth: (mediaQueryWidth > 600)
                                ? mediaQuery.size.width * 0.4
                                : mediaQuery.size.width * 0.8,
                            shape: StadiumBorder(),
                            buttonColor: Color.fromRGBO(244, 67, 54, 1),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RaisedButton(
                                onPressed: () async {
                                  var db = FirebaseFirestore.instance;

                                  await db
                                      .collection("password_entries")
                                      .doc(entry_id)
                                      .delete()
                                      .then(
                                        (doc) => AppLogger.printInfoLog(
                                            'Entry deleted'),
                                        onError: (e) => AppLogger.printErrorLog(
                                            'Some error occured',
                                            error: e),
                                      );
                                  await Provider.of<UserEntries>(context,
                                          listen: false)
                                      .fetchEntries();
                                  Fluttertoast.showToast(
                                    msg: "Password has been deleted",
                                  );
                                  Navigator.pushNamed(context, '/appMainPage');
                                },
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          ButtonTheme(
                            minWidth: (mediaQueryWidth > 600)
                                ? mediaQuery.size.width * 0.4
                                : mediaQuery.size.width * 0.8,
                            shape: StadiumBorder(),
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Go Back',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            } catch (e) {
              AppLogger.printErrorLog('Some error occured', error: e);
            }
          },
          child: Text(
            'Delete pssswd entry',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
