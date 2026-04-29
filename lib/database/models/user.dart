class User {
  final String nickname;
  final String? avatar;

  User({
    required this.nickname,
    this.avatar,
  });

  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      'avatar': avatar,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      nickname: json['nickname'] as String,
      avatar: json['avatar'] as String?,
    );
  }

  User copyWith({
    String? nickname,
    String? avatar,
  }) {
    return User(
      nickname: nickname ?? this.nickname,
      avatar: avatar ?? this.avatar,
    );
  }
}
