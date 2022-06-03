import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pssswd/functions/passwordDecrypter.dart';
import 'package:pssswd/functions/passwordEncrypter.dart';
import 'package:pssswd/components/passwdCard.dart';
import 'package:pssswd/providers/user_entries.dart';

import '../components/loadingWidgetForPage.dart';
import '../components/noPasswordFound.dart';
import 'addPasswd.dart';

// import '../providers/userDetails.dart';

class PasswdList extends StatefulWidget {
  @override
  State<PasswdList> createState() => _PasswdListState();
}

class _PasswdListState extends State<PasswdList> {
  var fetchedEntriesInApp;
  var _isPasswordListBeingFetched;
  var _isListBeingLoaded;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: FutureBuilder(
          future:
              Provider.of<UserEntries>(context, listen: false).fetchEntries(),
          builder: (context, snapshot) {
            if (context.watch<UserEntries>().entries == null) {
              return Container(
                height: mediaQuery.size.height * 0.8,
                child: Center(
                  child: LoadingWidgetForPage.spinkit,
                ),
              );
            }

            return Column(
              children: [
                if (context.watch<UserEntries>().entries.length == 0)
                  NoPasswordFound(),
                Container(
                  height: (context.watch<UserEntries>().entries.length != 0)
                      ? (mediaQuery.size.height -
                              AppBar().preferredSize.height -
                              mediaQuery.padding.bottom) *
                          0.85
                      : 0.7,
                  child: ListView.builder(
                    itemCount: context.watch<UserEntries>().entries.length,
                    itemBuilder: (ctx, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PasswdCard(
                            context.watch<UserEntries>().entries[index]['data']
                                ['name'],
                            context.watch<UserEntries>().entries[index]['data']
                                ['username'],
                            context.watch<UserEntries>().entries[index]['data']
                                ['password'],
                            context.watch<UserEntries>().entries[index]['data']
                                ['url'],
                            context.watch<UserEntries>().entries[index]['data']
                                ['randForKeyToStore'],
                            context.watch<UserEntries>().entries[index]['data']
                                ['randForIV'],
                            context.watch<UserEntries>().entries[index]
                                ['entry_id'],
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Container(
                  height:
                      (mediaQuery.size.height - AppBar().preferredSize.height) *
                          0.08,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ButtonTheme(
                        height: mediaQuery.size.height * 0.05,
                        minWidth: mediaQuery.size.width * 0.8,
                        child: RaisedButton(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddPasswd(),
                              ),
                            );
                          },
                          child: const Text(
                            'Add pssswd',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          shape: StadiumBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
