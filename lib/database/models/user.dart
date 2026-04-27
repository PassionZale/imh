class User {
  final int? id;
  final String name;
  final String nickname;
  final String? avatar;
  final int createdAt;
  final int updatedAt;

  User({
    this.id,
    required this.name,
    required this.nickname,
    this.avatar,
    int? createdAt,
    int? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch,
       updatedAt = updatedAt ?? DateTime.now().millisecondsSinceEpoch;

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'nickname': nickname,
      'avatar': avatar,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory User.fromMap(Map<String, Object?> map) {
    return User(
      id: map['id'] as int?,
      name: map['name'] as String,
      nickname: map['nickname'] as String,
      avatar: map['avatar'] as String?,
      createdAt: map['created_at'] as int,
      updatedAt: map['updated_at'] as int,
    );
  }

  User copyWith({
    int? id,
    String? name,
    String? nickname,
    String? avatar,
    int? createdAt,
    int? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      nickname: nickname ?? this.nickname,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
