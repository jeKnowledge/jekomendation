import 'dart:convert';

class Jekomandation {
  String user;
  String jekomandation;
  String link;
  String about;
  String category;
  Jekomandation({
    required this.user,
    required this.jekomandation,
    required this.link,
    required this.about,
    required this.category,
  });

  Jekomandation copyWith({
    String? user,
    String? jekomandation,
    String? link,
    String? about,
    String? category,
  }) {
    return Jekomandation(
      user: user ?? this.user,
      jekomandation: jekomandation ?? this.jekomandation,
      link: link ?? this.link,
      about: about ?? this.about,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'user': user});
    result.addAll({'jekomandation': jekomandation});
    result.addAll({'link': link});
    result.addAll({'about': about});
    result.addAll({'category': category});
  
    return result;
  }

  factory Jekomandation.fromMap(Map<String, dynamic> map) {
    return Jekomandation(
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
    return 'Jekomandation(user: $user, jekomandation: $jekomandation, link: $link, about: $about, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Jekomandation &&
      other.user == user &&
      other.jekomandation == jekomandation &&
      other.link == link &&
      other.about == about &&
      other.category == category;
  }

  @override
  int get hashCode {
    return user.hashCode ^
      jekomandation.hashCode ^
      link.hashCode ^
      about.hashCode ^
      category.hashCode;
  }
}
