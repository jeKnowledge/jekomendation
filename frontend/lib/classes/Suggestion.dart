import 'dart:convert';

class Suggestion{
  int id;
  String title;
  String body;
  Suggestion({
    required this.id,
    required this.title,
    required this.body,
  });

  Suggestion copyWith({
    int? id,
    String? title,
    String? body,
  }) {
    return Suggestion(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'title': title});
    result.addAll({'body': body});
  
    return result;
  }

  factory Suggestion.fromMap(Map<String, dynamic> map) {
    return Suggestion(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      body: map['body'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Suggestion.fromJson(String source) => Suggestion.fromMap(json.decode(source));

  @override
  String toString() => 'Suggestion()(id: $id, title: $title, body: $body)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Suggestion &&
      other.id == id &&
      other.title == title &&
      other.body == body;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ body.hashCode;
}
