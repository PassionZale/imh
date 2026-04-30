import '../database/models/car_fuel_record.dart';
import '../database/database_helper.dart';

/// 只能编辑最新记录的异常
class NotLatestRecordException implements Exception {
  final String message;
  NotLatestRecordException(this.message);

  @override
  String toString() => message;
}

class CarFuelRecordRepository {
  /// 计算增量字段（mileageDelta, consumption, costPerKm）
  /// 查询该车辆上一条记录（按 date 排序），并计算增量
  Future<Map<String, dynamic>> _calculateDeltaFields(
    int carId,
    int mileage,
    double liters,
    double totalCost,
  ) async {
    final db = await DatabaseHelper.instance.db;

    // 查询该车辆上一条记录（按 date DESC, created_at DESC 排序，取第一条）
    final maps = await db.query(
      'car_fuel_record',
      where: 'car_id = ?',
      whereArgs: [carId],
      orderBy: 'date DESC, created_at DESC',
      limit: 1,
    );

    if (maps.isEmpty) {
      // 首次记录，增量字段为 null
      return {'mileage_delta': null, 'consumption': null, 'cost_per_km': null};
    }

    final previous = CarFuelRecord.fromMap(maps.first);
    final mileageDelta = mileage - previous.mileage;

    if (mileageDelta <= 0) {
      // 里程未增加，增量字段为 null
      return {'mileage_delta': null, 'consumption': null, 'cost_per_km': null};
    }

    return {
      'mileage_delta': mileageDelta,
      'consumption': (liters / mileageDelta) * 100,
      'cost_per_km': totalCost / mileageDelta,
    };
  }

  Future<CarFuelRecord> create(CarFuelRecord record) async {
    final db = await DatabaseHelper.instance.db;

    // 计算增量字段
    final deltaFields = await _calculateDeltaFields(
      record.carId,
      record.mileage,
      record.liters,
      record.totalCost,
    );

    final id = await db.insert('car_fuel_record', {
      'car_id': record.carId,
      'liters': record.liters,
      'unit_price': record.unitPrice,
      'total_cost': record.totalCost,
      'mileage': record.mileage,
      'mileage_delta': deltaFields['mileage_delta'],
      'consumption': deltaFields['consumption'],
      'cost_per_km': deltaFields['cost_per_km'],
      'date': record.date,
      'created_at': record.createdAt,
    });

    return record.copyWith(
      id: id,
      mileageDelta: deltaFields['mileage_delta'] as int?,
      consumption: deltaFields['consumption'] as double?,
      costPerKm: deltaFields['cost_per_km'] as double?,
    );
  }

  Future<List<CarFuelRecord>> getByCar(int carId) async {
    final db = await DatabaseHelper.instance.db;
    final maps = await db.query(
      'car_fuel_record',
      where: 'car_id = ?',
      whereArgs: [carId],
      orderBy: 'date DESC, created_at DESC',
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
    if (record.id == null) {
      throw ArgumentError('Record id cannot be null for update');
    }

    final db = await DatabaseHelper.instance.db;

    // 检查是否是最新记录
    final maps = await db.query(
      'car_fuel_record',
      where: 'car_id = ?',
      whereArgs: [record.carId],
      orderBy: 'date DESC, created_at DESC',
      limit: 1,
    );

    if (maps.isEmpty || maps.first['id'] != record.id) {
      throw NotLatestRecordException('只能编辑最新记录');
    }

    // 计算增量字段
    final deltaFields = await _calculateDeltaFields(
      record.carId,
      record.mileage,
      record.liters,
      record.totalCost,
    );

    await db.update(
      'car_fuel_record',
      {
        'liters': record.liters,
        'unit_price': record.unitPrice,
        'total_cost': record.totalCost,
        'mileage': record.mileage,
        'mileage_delta': deltaFields['mileage_delta'],
        'consumption': deltaFields['consumption'],
        'cost_per_km': deltaFields['cost_per_km'],
        'date': record.date,
      },
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<void> delete(int id) async {
    final db = await DatabaseHelper.instance.db;

    // 先查询记录信息，检查是否是最新记录
    final maps = await db.query(
      'car_fuel_record',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) {
      return; // 记录不存在，直接返回
    }

    final carId = maps.first['car_id'] as int;

    // 查询该车辆最新记录
    final latestMaps = await db.query(
      'car_fuel_record',
      where: 'car_id = ?',
      whereArgs: [carId],
      orderBy: 'date DESC, created_at DESC',
      limit: 1,
    );

    if (latestMaps.isNotEmpty && latestMaps.first['id'] != id) {
      throw NotLatestRecordException('只能删除最新记录');
    }

    await db.delete('car_fuel_record', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteByCar(int carId) async {
    final db = await DatabaseHelper.instance.db;
    await db.delete('car_fuel_record', where: 'car_id = ?', whereArgs: [carId]);
  }
}
