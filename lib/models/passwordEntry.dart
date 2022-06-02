import 'package:cloud_firestore/cloud_firestore.dart';

class PasswordEntry {
  final String user_id;
  final Timestamp timestamp;
  final String name;
  final String password;
  final String username;
  final String url;

  PasswordEntry({
    required this.user_id,
    required this.name,
    required this.username,
    required this.password,
    required this.timestamp,
    required this.url,
  });
}
