import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../providers/userDetails.dart';
import '../providers/user_entries.dart';

class DeletePasswordEntry extends StatelessWidget {
  var entry_id;
  DeletePasswordEntry(this.entry_id);
  final secureStorage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    var _uid = secureStorage.read(key: 'loggedInUserId');
    return ElevatedButton(
      onPressed: () async {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              height: 200,
              child: Center(
                child: Column(
                  children: [
                    Text('Are you sure about deleting the entry?'),
                    ElevatedButton(
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
                        await Provider.of<UserEntries>(context, listen: false)
                            .fetchEntries();
                        Fluttertoast.showToast(
                          msg: "Password has been deleted",
                        );
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                      child: Text('Yes Daddy, let me delete my entry uWu'),
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Navigator.of(context)
                        //     .popUntil((route) => route.isFirst);
                      },
                      child: Text('No please Daddy let me go!!! uWu'),
                      style: ElevatedButton.styleFrom(primary: Colors.green),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Text('Delete pssswd entry'),
      style: ElevatedButton.styleFrom(primary: Colors.red),
    );
  }
}
