import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pssswd/passwdCard.dart';
import 'package:pssswd/providers/user_entries.dart';

class PasswdList extends StatefulWidget {
  // var abc;
  // Function fetchEntries;
  // PasswdList(this.abc, this.fetchEntries);
  @override
  State<PasswdList> createState() => _PasswdListState();
}

class _PasswdListState extends State<PasswdList> {
  var fetchedEntriesInApp;

  @override
  Widget build(BuildContext context) {
    // var entries;
    // setState(() {
    //   entries = widget.abc;
    // });

    // print('entry id  ${widget.abc[0]['entry_id']}');
    // print('password ${widget.abc[0]['data']['password']}');
    // print('password ${widget.abc[0]['data']['user_id']}');
    // print('password ${widget.abc[0]['data']['domain']}');

    // return Container(
    //   height: 710,
    //   child: ListView.builder(
    //     itemCount: context.watch<UserEntries>().entries.length,
    //     itemBuilder: (ctx, index) {
    //       return PasswdCard(
    //         context.watch<UserEntries>().entries[index]['data']['domain'],
    //         context.watch<UserEntries>().entries[index]['data']['password'],
    //         context.watch<UserEntries>().entries[index]['entry_id'],
    //       );
    //     },
    //   ),
    // );

    return FutureBuilder(
        future: Provider.of<UserEntries>(context, listen: false).fetchEntries(),
        builder: (context, snapshot) {
          if (context.watch<UserEntries>().entries == null) {
            return Text('Loading');
          }

          // return Column(children: [
          //   // PasswdList(valueForLife, fetchEntries),
          //   PasswdList(),

          //   RaisedButton(
          //     onPressed: () async {
          //       await Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => AddPasswd(),
          //         ),
          //       );
          //     },
          //     child: Text('Add pssswd'),
          //   ),
          // ]);
          return Container(
            height: 710,
            child: ListView.builder(
              // itemCount: context.watch<UserEntries>().entries.length,
              itemCount: context.watch<UserEntries>().entries.length,
              itemBuilder: (ctx, index) {
                print(context.watch<UserEntries>().entries.length);
                return PasswdCard(
                  context.watch<UserEntries>().entries[index]['data']['domain'],
                  context.watch<UserEntries>().entries[index]['data']
                      ['password'],
                  context.watch<UserEntries>().entries[index]['entry_id'],
                );
              },
            ),
          );
        });
  }
}
