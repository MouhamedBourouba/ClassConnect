class User {
  User({
    required this.id,
    required this.username,
    required this.hashedPassword,
    required this.email,
  });

  final String id;
  final String username;
  final String hashedPassword;
  final String email;

  List<dynamic> toList() =>
      [id, username, email, hashedPassword,];
}
