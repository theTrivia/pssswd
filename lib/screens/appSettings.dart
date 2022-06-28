import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pssswd/functions/blockUserAccount.dart';

class AppSettings extends StatefulWidget {
  const AppSettings({Key? key}) : super(key: key);

  @override
  State<AppSettings> createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  final secureStorage = FlutterSecureStorage();
  var userAccountSetting;

  getBlockAccountSettings() async {
    final userId = await secureStorage.read(key: 'uniqueUserId');
    final setting = await BlockUserAccount.getUserSetting(userId);
    print('settings from widget ${setting}');
    setState(() {
      userAccountSetting = setting;
    });
  }

  @override
  void initState() {
    super.initState();
    getBlockAccountSettings();
  }

  @override
  Widget build(BuildContext context) {
    var _blockAccount = userAccountSetting;
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Column(
        children: [
          SwitchListTile(
            title:
                Text('Block Account upon providing Incorrect Master Password'),
            value: userAccountSetting == null ? false : userAccountSetting,
            onChanged: (value) {
              print(value);
              setState(() {
                userAccountSetting = value;
              });
            },
          ),
          Text(userAccountSetting.toString()),
          RaisedButton(
            onPressed: () async {
              print(userAccountSetting);
              await BlockUserAccount.changeUserSetting(userAccountSetting);
            },
            child: Text('Submit Changes'),
          )
        ],
      ),
    );
  }
}
