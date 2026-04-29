/// 打卡任务模型
class CheckInTask {
  /// 主键 ID
  final int? id;

  /// 任务标题
  final String title;

  /// 是否启用（0=禁用，1=启用）
  final bool isEnabled;

  /// 打卡频率（每日打卡次数）
  final int frequency;

  /// 创建时间（毫秒时间戳）
  final int createdAt;

  /// 更新时间（毫秒时间戳）
  final int updatedAt;

  CheckInTask({
    this.id,
    required this.title,
    this.isEnabled = true,
    this.frequency = 1,
    int? createdAt,
    int? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch,
       updatedAt = updatedAt ?? DateTime.now().millisecondsSinceEpoch;

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'is_enabled': isEnabled ? 1 : 0,
      'frequency': frequency,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory CheckInTask.fromMap(Map<String, Object?> map) {
    return CheckInTask(
      id: map['id'] as int?,
      title: map['title'] as String,
      isEnabled: (map['is_enabled'] as int) == 1,
      frequency: map['frequency'] as int,
      createdAt: map['created_at'] as int,
      updatedAt: map['updated_at'] as int,
    );
  }

  CheckInTask copyWith({
    int? id,
    String? title,
    bool? isEnabled,
    int? frequency,
    int? createdAt,
    int? updatedAt,
  }) {
    return CheckInTask(
      id: id ?? this.id,
      title: title ?? this.title,
      isEnabled: isEnabled ?? this.isEnabled,
      frequency: frequency ?? this.frequency,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
