import 'dart:convert';

// Criar model pra User Info

class User {
  String username;
  String email;
  String created;
  double userReview;
  User({
    required this.username,
    required this.email,
    required this.created,
    required this.userReview,
  });
  

  User copyWith({
    String? username,
    String? email,
    String? created,
    double? userReview,
  }) {
    return User(
      username: username ?? this.username,
      email: email ?? this.email,
      created: created ?? this.created,
      userReview: userReview ?? this.userReview,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'username': username});
    result.addAll({'email': email});
    result.addAll({'created': created});
    result.addAll({'userReview': userReview});
  
    return result;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      created: map['created'] ?? '',
      userReview: map['userReview']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(username: $username, email: $email, created: $created, userReview: $userReview)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is User &&
      other.username == username &&
      other.email == email &&
      other.created == created &&
      other.userReview == userReview;
  }

  @override
  int get hashCode {
    return username.hashCode ^
      email.hashCode ^
      created.hashCode ^
      userReview.hashCode;
  }
}
