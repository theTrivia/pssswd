import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../functions/app_logger.dart';
import '../components/passwdCard.dart';
import '../providers/user_entries.dart';
import '../components/loadingWidgetForPage.dart';
import '../components/noPasswordFound.dart';
import './addPasswd.dart';

class PasswdList extends StatefulWidget {
  @override
  State<PasswdList> createState() => _PasswdListState();
}

class _PasswdListState extends State<PasswdList> {
  var fetchedEntriesInApp;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return SafeArea(
      child: Padding(
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
                  Flexible(
                    child: ListView.builder(
                      itemCount: context.watch<UserEntries>().entries.length,
                      itemBuilder: (ctx, index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PasswdCard(
                              context.watch<UserEntries>().entries[index]
                                  ['data']['name'],
                              context.watch<UserEntries>().entries[index]
                                  ['data']['username'],
                              context.watch<UserEntries>().entries[index]
                                  ['data']['password'],
                              context.watch<UserEntries>().entries[index]
                                  ['data']['url'],
                              context.watch<UserEntries>().entries[index]
                                  ['data']['randForKeyToStore'],
                              context.watch<UserEntries>().entries[index]
                                  ['data']['randForIV'],
                              context.watch<UserEntries>().entries[index]
                                  ['entry_id'],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  ButtonTheme(
                    height: (mediaQuery.size.width > 500)
                        ? mediaQuery.size.height * 0.059
                        : mediaQuery.size.height * 0.05,
                    minWidth: (mediaQuery.size.width > 500)
                        ? 800
                        : mediaQuery.size.width * 0.8,
                    child: RaisedButton(
                      onPressed: () async {
                        try {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddPasswd(),
                            ),
                          );
                        } catch (e) {
                          AppLogger.printErrorLog('Some error occured',
                              error: e);
                        }
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
              );
            }),
      ),
    );
  }
}
