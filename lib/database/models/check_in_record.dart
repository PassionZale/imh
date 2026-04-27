class CheckInRecord {
  final int? id;
  final int taskId;
  final String date;
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
