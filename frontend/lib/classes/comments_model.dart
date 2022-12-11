import 'dart:convert';

class Comments {
  int id;
  String title;
  String body;
  String user;
  String created;
  Comments({
    required this.id,
    required this.title,
    required this.body,
    required this.user,
    required this.created,
  });

  Comments copyWith({
    int? id,
    String? title,
    String? body,
    String? user,
    String? created,
  }) {
    return Comments(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      user: user ?? this.user,
      created: created ?? this.created,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'title': title});
    result.addAll({'body': body});
    result.addAll({'user': user});
    result.addAll({'created': created});
  
    return result;
  }

  factory Comments.fromMap(Map<String, dynamic> map) {
    return Comments(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      user: map['user'] ?? '',
      created: map['created'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Comments.fromJson(String source) => Comments.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Comments(id: $id, title: $title, body: $body, user: $user, created: $created)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Comments &&
      other.id == id &&
      other.title == title &&
      other.body == body &&
      other.user == user &&
      other.created == created;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      body.hashCode ^
      user.hashCode ^
      created.hashCode;
  }
}
