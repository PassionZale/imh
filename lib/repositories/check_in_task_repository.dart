import '../database/models/check_in_task.dart';
import '../database/database_helper.dart';

class CheckInTaskRepository {
  Future<CheckInTask> create(CheckInTask task) async {
    final db = await DatabaseHelper.instance.db;
    final id = await db.insert('check_in_tasks', {
      'user_id': task.userId,
      'title': task.title,
      'is_enabled': task.isEnabled ? 1 : 0,
      'frequency': task.frequency,
      'created_at': task.createdAt,
      'updated_at': task.updatedAt,
    });
    return task.copyWith(id: id);
  }

  Future<CheckInTask?> getById(int id, int userId) async {
    final db = await DatabaseHelper.instance.db;
    final maps = await db.query(
      'check_in_tasks',
      where: 'id = ? AND user_id = ?',
      whereArgs: [id, userId],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return CheckInTask.fromMap(maps.first);
  }

  Future<List<CheckInTask>> getByUser(int userId) async {
    final db = await DatabaseHelper.instance.db;
    final maps = await db.query(
      'check_in_tasks',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'id DESC',
    );
    return maps.map((map) => CheckInTask.fromMap(map)).toList();
  }

  Future<List<CheckInTask>> getEnabledByUser(int userId) async {
    final db = await DatabaseHelper.instance.db;
    final maps = await db.query(
      'check_in_tasks',
      where: 'is_enabled = ? AND user_id = ?',
      whereArgs: [1, userId],
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
