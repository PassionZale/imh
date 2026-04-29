import '../database/models/car_fuel_record.dart';
import '../database/database_helper.dart';

class CarFuelRecordRepository {
  Future<CarFuelRecord> create(CarFuelRecord record) async {
    final db = await DatabaseHelper.instance.db;
    final id = await db.insert('car_fuel_record', {
      'car_id': record.carId,
      'liters': record.liters,
      'unit_price': record.unitPrice,
      'total_cost': record.totalCost,
      'mileage': record.mileage,
      'date': record.date,
      'created_at': record.createdAt,
    });
    return record.copyWith(id: id);
  }

  Future<List<CarFuelRecord>> getByCar(int carId) async {
    final db = await DatabaseHelper.instance.db;
    final maps = await db.query(
      'car_fuel_record',
      where: 'car_id = ?',
      whereArgs: [carId],
      orderBy: 'date DESC',
    );
    return maps.map((map) => CarFuelRecord.fromMap(map)).toList();
  }

  Future<List<CarFuelRecord>> getByCarAndDate(int carId, String date) async {
    final db = await DatabaseHelper.instance.db;
    final maps = await db.query(
      'car_fuel_record',
      where: 'car_id = ? AND date = ?',
      whereArgs: [carId, date],
    );
    return maps.map((map) => CarFuelRecord.fromMap(map)).toList();
  }

  Future<List<CarFuelRecord>> getByDate(String date) async {
    final db = await DatabaseHelper.instance.db;
    final maps = await db.query(
      'car_fuel_record',
      where: 'date = ?',
      whereArgs: [date],
    );
    return maps.map((map) => CarFuelRecord.fromMap(map)).toList();
  }

  Future<void> update(CarFuelRecord record) async {
    final db = await DatabaseHelper.instance.db;
    await db.update(
      'car_fuel_record',
      {
        'liters': record.liters,
        'unit_price': record.unitPrice,
        'total_cost': record.totalCost,
        'mileage': record.mileage,
        'date': record.date,
      },
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<void> delete(int id) async {
    final db = await DatabaseHelper.instance.db;
    await db.delete(
      'car_fuel_record',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteByCar(int carId) async {
    final db = await DatabaseHelper.instance.db;
    await db.delete(
      'car_fuel_record',
      where: 'car_id = ?',
      whereArgs: [carId],
    );
  }
}
