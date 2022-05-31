import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../providers/user_entries.dart';

class DeletePasswordEntry extends StatelessWidget {
  var entry_id;
  DeletePasswordEntry(this.entry_id);
  final secureStorage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    var _uid = secureStorage.read(key: 'loggedInUserId');
    final mediaQuery = MediaQuery.of(context);
    return ButtonTheme(
      minWidth: mediaQuery.size.width * 0.8,
      buttonColor: Colors.red,
      shape: StadiumBorder(),
      child: RaisedButton(
        onPressed: () async {
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
                        minWidth: mediaQuery.size.width * 0.8,
                        shape: StadiumBorder(),
                        buttonColor: Colors.red,
                        child: RaisedButton(
                          onPressed: () async {
                            var db = FirebaseFirestore.instance;

                            await db
                                .collection("password_entries")
                                .doc(entry_id)
                                .delete()
                                .then(
                                  (doc) => print("Document deleted"),
                                  onError: (e) =>
                                      print("Error updating document $e"),
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
                          // style: ElevatedButton.styleFrom(primary: Colors.red),
                        ),
                      ),
                      ButtonTheme(
                        minWidth: mediaQuery.size.width * 0.8,
                        shape: StadiumBorder(),
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // Navigator.of(context)
                            //     .popUntil((route) => route.isFirst);
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
        },
        child: Text(
          'Delete pssswd entry',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
