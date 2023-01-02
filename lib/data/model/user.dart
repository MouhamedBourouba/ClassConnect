class User {
  User({
    required this.id,
    required this.username,
    required this.hashedPassword,
    required this.email,
    this.firstName,
    this.lastName,
    this.grade,
    this.parentPhone,
  });
  final String id;
  final String username;
  final String hashedPassword;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? grade;
  final String? parentPhone;

  List<dynamic> toList() => [
        id,
        username,
        email,
        hashedPassword,
        grade,
        parentPhone,
        firstName,
        lastName
      ];
}
