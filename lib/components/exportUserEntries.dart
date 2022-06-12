import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../functions/exportPasswords.dart';
import '../providers/user_entries.dart';

class ExportUserEntries extends StatefulWidget {
  const ExportUserEntries({Key? key}) : super(key: key);

  @override
  State<ExportUserEntries> createState() => _ExportUserEntriesState();
}

class _ExportUserEntriesState extends State<ExportUserEntries> {
  @override
  Widget build(BuildContext context) {
    List _userEntries;
    return FutureBuilder(
        future: Provider.of<UserEntries>(context, listen: false).fetchEntries(),
        builder: ((context, snapshot) {
          _userEntries = context.watch<UserEntries>().entries;

          return IconButton(
            onPressed: () {
              ExportPasswords.exportUserEntries(_userEntries);
            },
            icon: Icon(
              Icons.picture_as_pdf,
            ),
          );
        }));
  }
}
