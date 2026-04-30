/// 用户信息模型
class User {
  /// 用户昵称
  final String nickname;

  /// 用户头像 URL
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
