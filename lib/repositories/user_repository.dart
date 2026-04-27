import '../database/models/user.dart';
import '../database/database_helper.dart';

class UserRepository {
  Future<User> create(User user) async {
    final db = await DatabaseHelper.instance.db;
    final id = await db.insert('users', {
      'name': user.name,
      'nickname': user.nickname,
      'avatar': user.avatar,
      'created_at': user.createdAt,
      'updated_at': user.updatedAt,
    });
    return user.copyWith(id: id);
  }

  Future<User?> getById(int id) async {
    final db = await DatabaseHelper.instance.db;
    final maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }

  Future<List<User>> getAll() async {
    final db = await DatabaseHelper.instance.db;
    final maps = await db.query('users', orderBy: 'id DESC');
    return maps.map((map) => User.fromMap(map)).toList();
  }

  Future<void> update(User user) async {
    if (user.id == null) {
      throw ArgumentError('User id must not be null for update');
    }
    final db = await DatabaseHelper.instance.db;
    final now = DateTime.now().millisecondsSinceEpoch;
    await db.update(
      'users',
      {
        'name': user.name,
        'nickname': user.nickname,
        'avatar': user.avatar,
        'updated_at': now,
      },
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<void> delete(int id) async {
    final db = await DatabaseHelper.instance.db;
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }
}
