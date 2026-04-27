import '../database/models/car.dart';
import '../database/database_helper.dart';

class CarRepository {
  Future<Car> create(Car car) async {
    final db = await DatabaseHelper.instance.db;
    final id = await db.insert('car', {
      'brand': car.brand,
      'model': car.model,
      'plate_number': car.plateNumber,
      'color': car.color,
      'year': car.year,
      'mileage': car.mileage,
      'created_at': car.createdAt,
      'updated_at': car.updatedAt,
    });
    return car.copyWith(id: id);
  }

  Future<Car?> getById(int id) async {
    final db = await DatabaseHelper.instance.db;
    final maps = await db.query(
      'car',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return Car.fromMap(maps.first);
  }

  Future<List<Car>> getAll() async {
    final db = await DatabaseHelper.instance.db;
    final maps = await db.query('car', orderBy: 'id DESC');
    return maps.map((map) => Car.fromMap(map)).toList();
  }

  Future<void> update(Car car) async {
    if (car.id == null) {
      throw ArgumentError('Car id must not be null for update');
    }
    final db = await DatabaseHelper.instance.db;
    final now = DateTime.now().millisecondsSinceEpoch;
    await db.update(
      'car',
      {
        'brand': car.brand,
        'model': car.model,
        'plate_number': car.plateNumber,
        'color': car.color,
        'year': car.year,
        'mileage': car.mileage,
        'updated_at': now,
      },
      where: 'id = ?',
      whereArgs: [car.id],
    );
  }

  Future<void> delete(int id) async {
    final db = await DatabaseHelper.instance.db;
    await db.delete('car_fuel_record', where: 'car_id = ?', whereArgs: [id]);
    await db.delete('car', where: 'id = ?', whereArgs: [id]);
  }
}
