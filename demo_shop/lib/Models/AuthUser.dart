/// The logged-in user, as returned by POST /auth/login.
class AuthUser {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String image;
  final String accessToken;
  final String refreshToken;

  const AuthUser({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.image,
    required this.accessToken,
    required this.refreshToken,
  });

  String get fullName => '$firstName $lastName';

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      image: json['image'] as String? ?? '',
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }
}
