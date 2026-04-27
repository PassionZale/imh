class CarFuelRecord {
  final int? id;
  final int carId;
  final double liters;
  final double unitPrice;
  final double totalCost;
  final int mileage;
  final String date;
  final int createdAt;

  CarFuelRecord({
    this.id,
    required this.carId,
    required this.liters,
    required this.unitPrice,
    required this.totalCost,
    required this.mileage,
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
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
