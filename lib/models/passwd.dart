import 'package:cloud_firestore/cloud_firestore.dart';

class Passwd {
  final String user_id;
  final Timestamp timestamp;
  final String domain;
  final String password;

  Passwd({
    required this.user_id,
    required this.domain,
    required this.password,
    required this.timestamp,
  });
}
