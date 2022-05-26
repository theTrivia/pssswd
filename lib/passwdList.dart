import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pssswd/functions/passwordDecrypter.dart';
import 'package:pssswd/functions/passwordEncrypter.dart';
import 'package:pssswd/passwdCard.dart';
import 'package:pssswd/providers/user_entries.dart';

class PasswdList extends StatefulWidget {
  @override
  State<PasswdList> createState() => _PasswdListState();
}

class _PasswdListState extends State<PasswdList> {
  var fetchedEntriesInApp;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<UserEntries>(context, listen: false).fetchEntries(),
        builder: (context, snapshot) {
          if (context.watch<UserEntries>().entries == null) {
            return Text('Loading');
          }

          return Container(
            height: 680,
            child: ListView.builder(
              itemCount: context.watch<UserEntries>().entries.length,
              itemBuilder: (ctx, index) {
                print(context.watch<UserEntries>().entries.length);

                // final decryptedPassword =
                //     pss.getDecryptedPassword(newEntry.password);
                return PasswdCard(
                  context.watch<UserEntries>().entries[index]['data']['domain'],
                  // context.watch<UserEntries>().entries[index]['data']
                  //     ['password'],
                  context.watch<UserEntries>().entries[index]['data']
                      ['password'],
                  context.watch<UserEntries>().entries[index]['data']
                      ['password_key'],
                  context.watch<UserEntries>().entries[index]['entry_id'],
                );
              },
            ),
          );
        });
  }
}
