import '../database/models/check_in_record.dart';
import '../database/database_helper.dart';

class CheckInRecordRepository {
  Future<CheckInRecord> create(CheckInRecord record) async {
    final db = await DatabaseHelper.instance.db;
    final id = await db.insert('check_in_records', {
      'task_id': record.taskId,
      'date': record.date,
      'created_at': record.createdAt,
    });
    return record.copyWith(id: id);
  }

  Future<List<CheckInRecord>> getByTaskAndDate(int taskId, String date) async {
    final db = await DatabaseHelper.instance.db;
    final maps = await db.query(
      'check_in_records',
      where: 'task_id = ? AND date = ?',
      whereArgs: [taskId, date],
    );
    return maps.map((map) => CheckInRecord.fromMap(map)).toList();
  }

  Future<List<CheckInRecord>> getByDate(String date) async {
    final db = await DatabaseHelper.instance.db;
    final maps = await db.query(
      'check_in_records',
      where: 'date = ?',
      whereArgs: [date],
    );
    return maps.map((map) => CheckInRecord.fromMap(map)).toList();
  }

  Future<List<CheckInRecord>> getByTask(int taskId) async {
    final db = await DatabaseHelper.instance.db;
    final maps = await db.query(
      'check_in_records',
      where: 'task_id = ?',
      whereArgs: [taskId],
      orderBy: 'date DESC',
    );
    return maps.map((map) => CheckInRecord.fromMap(map)).toList();
  }

  Future<void> deleteByTask(int taskId) async {
    final db = await DatabaseHelper.instance.db;
    await db.delete('check_in_records', where: 'task_id = ?', whereArgs: [taskId]);
  }
}
