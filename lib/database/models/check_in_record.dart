/// 打卡记录模型
class CheckInRecord {
  /// 主键 ID
  final int? id;

  /// 关联的任务 ID
  final int taskId;

  /// 打卡日期（格式：YYYY-MM-DD）
  final String date;

  /// 创建时间（毫秒时间戳）
  final int createdAt;

  CheckInRecord({
    this.id,
    required this.taskId,
    required this.date,
    int? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch;

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'task_id': taskId,
      'date': date,
      'created_at': createdAt,
    };
  }

  factory CheckInRecord.fromMap(Map<String, Object?> map) {
    return CheckInRecord(
      id: map['id'] as int?,
      taskId: map['task_id'] as int,
      date: map['date'] as String,
      createdAt: map['created_at'] as int,
    );
  }

  CheckInRecord copyWith({
    int? id,
    int? taskId,
    String? date,
    int? createdAt,
  }) {
    return CheckInRecord(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
