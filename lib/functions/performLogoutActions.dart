import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import '../providers/user_entries.dart';

class PerformLogoutActions {
  static performLogoutChores(context) async {
    final secureStorage = FlutterSecureStorage();
    await FirebaseAuth.instance.signOut();

    await secureStorage.deleteAll();
    await Provider.of<UserEntries>(context, listen: false).setEntriesToNull();
  }
}
