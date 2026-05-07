import 'package:imh/database/models/check_in_task.dart';
import 'package:imh/database/database_helper.dart';

class CheckInTaskRepository {
  Future<CheckInTask> create(CheckInTask task) async {
    final db = await DatabaseHelper.instance.db;
    final id = await db.insert('check_in_tasks', {
      'title': task.title,
      'is_enabled': task.isEnabled ? 1 : 0,
      'frequency': task.frequency,
      'created_at': task.createdAt,
      'updated_at': task.updatedAt,
    });
    return task.copyWith(id: id);
  }

  Future<CheckInTask?> getById(int id) async {
    final db = await DatabaseHelper.instance.db;
    final maps = await db.query(
      'check_in_tasks',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return CheckInTask.fromMap(maps.first);
  }

  Future<List<CheckInTask>> getAll() async {
    final db = await DatabaseHelper.instance.db;
    final maps = await db.query('check_in_tasks', orderBy: 'id DESC');
    return maps.map((map) => CheckInTask.fromMap(map)).toList();
  }

  Future<List<CheckInTask>> getEnabled() async {
    final db = await DatabaseHelper.instance.db;
    final maps = await db.query(
      'check_in_tasks',
      where: 'is_enabled = ?',
      whereArgs: [1],
      orderBy: 'id DESC',
    );
    return maps.map((map) => CheckInTask.fromMap(map)).toList();
  }

  Future<void> update(CheckInTask task) async {
    if (task.id == null) {
      throw ArgumentError('CheckInTask id must not be null for update');
    }
    final db = await DatabaseHelper.instance.db;
    final now = DateTime.now().millisecondsSinceEpoch;
    await db.update(
      'check_in_tasks',
      {
        'title': task.title,
        'is_enabled': task.isEnabled ? 1 : 0,
        'frequency': task.frequency,
        'updated_at': now,
      },
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> delete(int id) async {
    final db = await DatabaseHelper.instance.db;
    await db.delete('check_in_records', where: 'task_id = ?', whereArgs: [id]);
    await db.delete('check_in_tasks', where: 'id = ?', whereArgs: [id]);
  }
}
