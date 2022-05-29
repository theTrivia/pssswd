import 'package:cloud_firestore/cloud_firestore.dart';

class something {
  somethingOne() async {
    var db = FirebaseFirestore.instance;
    final res = await db
        .collection("password_entries")
        .doc('BED3wChei4NEiDfQP72atUz2NU43')
        .get();
    print(res);
  }
}
