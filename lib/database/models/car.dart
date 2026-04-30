/// 车辆信息模型
class Car {
  /// 主键 ID
  final int? id;

  /// 车辆品牌（如：比亚迪、特斯拉）
  final String brand;

  /// 车辆型号（如：汉EV、Model 3）
  final String model;

  /// 车牌号
  final String plateNumber;

  /// 车辆颜色
  final String? color;

  /// 生产年份
  final int? year;

  /// 创建时间（毫秒时间戳）
  final int createdAt;

  /// 更新时间（毫秒时间戳）
  final int updatedAt;

  Car({
    this.id,
    required this.brand,
    required this.model,
    required this.plateNumber,
    this.color,
    this.year,
    int? createdAt,
    int? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch,
       updatedAt = updatedAt ?? DateTime.now().millisecondsSinceEpoch;

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'brand': brand,
      'model': model,
      'plate_number': plateNumber,
      'color': color,
      'year': year,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory Car.fromMap(Map<String, Object?> map) {
    return Car(
      id: map['id'] as int?,
      brand: map['brand'] as String,
      model: map['model'] as String,
      plateNumber: map['plate_number'] as String,
      color: map['color'] as String?,
      year: map['year'] as int?,
      createdAt: map['created_at'] as int,
      updatedAt: map['updated_at'] as int,
    );
  }

  Car copyWith({
    int? id,
    String? brand,
    String? model,
    String? plateNumber,
    String? color,
    int? year,
    int? createdAt,
    int? updatedAt,
  }) {
    return Car(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      plateNumber: plateNumber ?? this.plateNumber,
      color: color ?? this.color,
      year: year ?? this.year,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
