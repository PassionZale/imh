class Car {
  final int? id;
  final String brand;
  final String model;
  final String plateNumber;
  final String? color;
  final int? year;
  final int mileage;
  final int createdAt;
  final int updatedAt;

  Car({
    this.id,
    required this.brand,
    required this.model,
    required this.plateNumber,
    this.color,
    this.year,
    this.mileage = 0,
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
      'mileage': mileage,
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
      mileage: map['mileage'] as int,
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
    int? mileage,
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
      mileage: mileage ?? this.mileage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
