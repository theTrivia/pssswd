import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pssswd/functions/passwordDecrypter.dart';
import 'package:pssswd/functions/passwordEncrypter.dart';
import 'package:pssswd/components/passwdCard.dart';
import 'package:pssswd/providers/user_entries.dart';

// import '../providers/userDetails.dart';

class PasswdList extends StatefulWidget {
  @override
  State<PasswdList> createState() => _PasswdListState();
}

class _PasswdListState extends State<PasswdList> {
  var fetchedEntriesInApp;

  @override
  Widget build(BuildContext context) {
    // var _uid = context.watch<UserDetails>().getUserDetails['uniqueUserId'];
    // var userUniqueIdentity = context.watch<UserDetails>().getUserDetails;
    final mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: FutureBuilder(
          future:
              Provider.of<UserEntries>(context, listen: false).fetchEntries(),
          builder: (context, snapshot) {
            if (context.watch<UserEntries>().entries == null) {
              return Text('Loading');
            }

            return Container(
              height: (mediaQuery.size.height - AppBar().preferredSize.height) *
                  0.79,
              child: ListView.builder(
                itemCount: context.watch<UserEntries>().entries.length,
                itemBuilder: (ctx, index) {
                  // print(context.watch<UserEntries>().entries.length);

                  // final decryptedPassword =
                  //     pss.getDecryptedPassword(newEntry.password);
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PasswdCard(
                        context.watch<UserEntries>().entries[index]['data']
                            ['domain'],
                        context.watch<UserEntries>().entries[index]['data']
                            ['password'],
                        context.watch<UserEntries>().entries[index]['data']
                            ['randForKeyToStore'],
                        context.watch<UserEntries>().entries[index]['data']
                            ['randForIV'],
                        context.watch<UserEntries>().entries[index]['entry_id'],
                      ),
                    ],
                  );
                },
              ),
            );
          }),
    );
  }
}
