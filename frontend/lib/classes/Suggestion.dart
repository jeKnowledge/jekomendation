import 'dart:convert';

class Jekomandation {
  int id;
  String user;
  String jekomandation;
  String link;
  String about;
  String category;
  Jekomandation({
    required this.id,
    required this.user,
    required this.jekomandation,
    required this.link,
    required this.about,
    required this.category,
  });

  Jekomandation copyWith({
    int? id,
    String? user,
    String? jekomandation,
    String? link,
    String? about,
    String? category,
  }) {
    return Jekomandation(
      id: id ?? this.id,
      user: user ?? this.user,
      jekomandation: jekomandation ?? this.jekomandation,
      link: link ?? this.link,
      about: about ?? this.about,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'user': user});
    result.addAll({'jekomandation': jekomandation});
    result.addAll({'link': link});
    result.addAll({'about': about});
    result.addAll({'category': category});
  
    return result;
  }

  factory Jekomandation.fromMap(Map<String, dynamic> map) {
    return Jekomandation(
      id: map['id']?.toInt() ?? 0,
      user: map['user'] ?? '',
      jekomandation: map['jekomandation'] ?? '',
      link: map['link'] ?? '',
      about: map['about'] ?? '',
      category: map['category'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Jekomandation.fromJson(String source) => Jekomandation.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Jekomandation(id: $id, user: $user, jekomandation: $jekomandation, link: $link, about: $about, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Jekomandation &&
      other.id == id &&
      other.user == user &&
      other.jekomandation == jekomandation &&
      other.link == link &&
      other.about == about &&
      other.category == category;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      user.hashCode ^
      jekomandation.hashCode ^
      link.hashCode ^
      about.hashCode ^
      category.hashCode;
  }
}
