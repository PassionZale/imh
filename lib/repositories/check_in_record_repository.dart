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

  /// 获取某任务在某月的完成天数（去重日期中 count >= frequency 的天数）
  Future<int> getMonthlyStats(int taskId, int year, int month, int frequency) async {
    final dateCountMap = await getDateCountMap(taskId);
    final prefix = '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}';
    return dateCountMap.entries
        .where((e) => e.key.startsWith(prefix) && e.value >= frequency)
        .length;
  }

  /// 计算连续坚持天数
  /// 如果今天已完成，从今天开始往前数；否则从昨天开始
  Future<int> getStreakDays(int taskId, int frequency) async {
    final dateCountMap = await getDateCountMap(taskId);
    final today = DateTime.now();
    final todayStr = _formatDate(today);

    DateTime checkDate = dateCountMap[todayStr] != null && dateCountMap[todayStr]! >= frequency
        ? today
        : today.subtract(const Duration(days: 1));

    int streak = 0;
    while (true) {
      final dateStr = _formatDate(checkDate);
      final count = dateCountMap[dateStr];
      if (count != null && count >= frequency) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }

  /// 获取某任务所有日期的打卡次数映射 { 'YYYY-MM-DD': count }
  Future<Map<String, int>> getDateCountMap(int taskId) async {
    final records = await getByTask(taskId);
    final Map<String, int> countMap = {};
    for (final record in records) {
      countMap[record.date] = (countMap[record.date] ?? 0) + 1;
    }
    return countMap;
  }

  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}
