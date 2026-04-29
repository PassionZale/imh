class CheckInTask {
  final int? id;
  final String title;
  final bool isEnabled;
  final int frequency;
  final int createdAt;
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
