class User {
  final isNewUser;
  final email;
  final masterPasswordHash;
  final isEmailVerified;
  final creationTime;
  final uniqueUserId;
  final userFullName;

  User({
    required this.uniqueUserId,
    required this.isNewUser,
    required this.email,
    required this.masterPasswordHash,
    required this.isEmailVerified,
    required this.creationTime,
    this.userFullName,
  });
}
