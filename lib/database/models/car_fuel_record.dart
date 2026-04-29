/// 加油记录模型
class CarFuelRecord {
  /// 主键 ID
  final int? id;

  /// 关联的车辆 ID
  final int carId;

  /// 加油量（L）
  final double liters;

  /// 支付单价（元/L）
  final double unitPrice;

  /// 支付总额（元）
  final double totalCost;

  /// 行驶里程（km）
  final int mileage;

  /// 增加里程（km），本次里程 - 上次里程
  final int? mileageDelta;

  /// 最新油耗（L/100km），(加油量 / 增加里程) × 100
  final double? consumption;

  /// 每公里油费（元），支付总额 / 增加里程
  final double? costPerKm;

  /// 加油日期（格式：YYYY-MM-DD）
  final String date;

  /// 创建时间（毫秒时间戳）
  final int createdAt;

  CarFuelRecord({
    this.id,
    required this.carId,
    required this.liters,
    required this.unitPrice,
    required this.totalCost,
    required this.mileage,
    this.mileageDelta,
    this.consumption,
    this.costPerKm,
    required this.date,
    int? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch;

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'car_id': carId,
      'liters': liters,
      'unit_price': unitPrice,
      'total_cost': totalCost,
      'mileage': mileage,
      'mileage_delta': mileageDelta,
      'consumption': consumption,
      'cost_per_km': costPerKm,
      'date': date,
      'created_at': createdAt,
    };
  }

  factory CarFuelRecord.fromMap(Map<String, Object?> map) {
    return CarFuelRecord(
      id: map['id'] as int?,
      carId: map['car_id'] as int,
      liters: (map['liters'] as num).toDouble(),
      unitPrice: (map['unit_price'] as num).toDouble(),
      totalCost: (map['total_cost'] as num).toDouble(),
      mileage: map['mileage'] as int,
      mileageDelta: map['mileage_delta'] as int?,
      consumption: map['consumption'] as double?,
      costPerKm: map['cost_per_km'] as double?,
      date: map['date'] as String,
      createdAt: map['created_at'] as int,
    );
  }

  CarFuelRecord copyWith({
    int? id,
    int? carId,
    double? liters,
    double? unitPrice,
    double? totalCost,
    int? mileage,
    int? mileageDelta,
    double? consumption,
    double? costPerKm,
    String? date,
    int? createdAt,
  }) {
    return CarFuelRecord(
      id: id ?? this.id,
      carId: carId ?? this.carId,
      liters: liters ?? this.liters,
      unitPrice: unitPrice ?? this.unitPrice,
      totalCost: totalCost ?? this.totalCost,
      mileage: mileage ?? this.mileage,
      mileageDelta: mileageDelta ?? this.mileageDelta,
      consumption: consumption ?? this.consumption,
      costPerKm: costPerKm ?? this.costPerKm,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
