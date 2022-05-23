import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pssswd/passwdCard.dart';

class PasswdList extends StatefulWidget {
  var abc;
  Function fetchEntries;
  PasswdList(this.abc, this.fetchEntries);
  @override
  State<PasswdList> createState() => _PasswdListState();
}

class _PasswdListState extends State<PasswdList> {
  var fetchedEntriesInApp;

  @override
  Widget build(BuildContext context) {
    var entries;
    setState(() {
      entries = widget.abc;
    });

    // print('entry id  ${widget.abc[0]['entry_id']}');
    // print('password ${widget.abc[0]['data']['password']}');
    // print('password ${widget.abc[0]['data']['user_id']}');
    // print('password ${widget.abc[0]['data']['domain']}');

    return Container(
      height: 710,
      child: ListView.builder(
          itemCount: widget.abc.length,
          itemBuilder: (ctx, index) {
            // print(widget.abc[index]);
            return PasswdCard(
              widget.abc[index]['data']['domain'],
              widget.abc[index]['data']['password'],
              widget.abc[index]['entry_id'],
              widget.fetchEntries,
            );
          }),
    );
  }
}
