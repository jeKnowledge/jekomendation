import 'dart:convert';

class User {
  final String token;
  final String email;
  final String username;
  User({
    required this.token,
    required this.email,
    required this.username,
  });

  User copyWith({
    String? token,
    String? email,
    String? username,
  }) {
    return User(
      token: token ?? this.token,
      email: email ?? this.email,
      username: username ?? this.username,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'token': token});
    result.addAll({'email': email});
    result.addAll({'username': username});
  
    return result;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      token: map['token'] ?? '',
      email: map['email'] ?? '',
      username: map['username'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() => 'User(token: $token, email: $email, username: $username)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is User &&
      other.token == token &&
      other.email == email &&
      other.username == username;
  }

  @override
  int get hashCode => token.hashCode ^ email.hashCode ^ username.hashCode;
}
