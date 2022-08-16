import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_entries.dart';

import '../components/passwdCard.dart';

class SearchEntry extends StatefulWidget {
  const SearchEntry({Key? key}) : super(key: key);

  @override
  State<SearchEntry> createState() => _SearchEntryState();
}

class _SearchEntryState extends State<SearchEntry> {
  var searchEntryEditingController = TextEditingController();

  //Map initialization of the entries stored in the provider.
  Map<String, Map<String, Object>> passwordEntries = {};

  List<Object> matchedEntries = [];

  @override
  void initState() {
    super.initState();
    var entries = Provider.of<UserEntries>(context, listen: false).entries;

    for (var i in entries) {
      passwordEntries.addAll({i['entry_id']: i});
    }
  }

  getMatchedEntriesFromProvider(String entry) {
    Map res = {};
    List result = [];

    passwordEntries.forEach((key, value) {
      if ((value['data'] as Map)['name'].contains(entry)) {
        res = (passwordEntries[key]!['data'] as Map);
        result.add(value);
      }
    });

    setState(() {
      matchedEntries = [...result];
    });
  }

  void removeSearchResults() {
    setState(() {
      matchedEntries = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back),
              ),
              Flexible(
                child: TextField(
                  decoration: new InputDecoration.collapsed(
                    hintText: 'Search for entry',
                  ),
                  controller: searchEntryEditingController,
                  onChanged: (val) async {
                    if (val.length == 0) {
                      removeSearchResults();
                    }
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  getMatchedEntriesFromProvider(
                      searchEntryEditingController.text);
                },
                icon: Icon(
                  Icons.search_rounded,
                ),
              ),
            ],
          ),
          Divider(
            thickness: 2,
            endIndent: 10,
            indent: 10,
          ),
          Flexible(child: FutureBuilder(
            builder: (context, snapshot) {
              return ListView.builder(
                itemCount: matchedEntries.length,
                itemBuilder: (ctx, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PasswdCard(
                        (matchedEntries[index] as Map)['data']['name']
                            .toString(),
                        (matchedEntries[index] as Map)['data']['username'],
                        (matchedEntries[index] as Map)['data']['password'],
                        (matchedEntries[index] as Map)['data']['url'],
                        (matchedEntries[index] as Map)['data']
                            ['randForKeyToStore'],
                        (matchedEntries[index] as Map)['data']['randForIV'],
                        (matchedEntries[index] as Map)['entry_id'],
                      ),
                    ],
                  );
                },
              );
            },
          )),
        ],
      )),
    );
  }
}
