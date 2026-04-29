import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _db;

  DatabaseHelper._internal();

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'imh.db');

    return await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE check_in_tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,     -- 主键 ID
        title TEXT NOT NULL,                      -- 任务标题
        is_enabled INTEGER NOT NULL DEFAULT 1,    -- 是否启用（0=禁用，1=启用）
        frequency INTEGER NOT NULL DEFAULT 1,     -- 每日打卡次数
        created_at INTEGER NOT NULL,              -- 创建时间（毫秒时间戳）
        updated_at INTEGER NOT NULL               -- 更新时间（毫秒时间戳）
      )
    ''');

    await db.execute('''
      CREATE TABLE check_in_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,     -- 主键 ID
        task_id INTEGER NOT NULL,                 -- 关联的任务 ID
        date TEXT NOT NULL,                       -- 打卡日期（格式：YYYY-MM-DD）
        created_at INTEGER NOT NULL               -- 创建时间（毫秒时间戳）
      )
    ''');

    await db.execute('''
      CREATE TABLE car (
        id INTEGER PRIMARY KEY AUTOINCREMENT,     -- 主键 ID
        brand TEXT NOT NULL,                      -- 车辆品牌（如：比亚迪、特斯拉）
        model TEXT NOT NULL,                      -- 车辆型号（如：汉EV、Model 3）
        plate_number TEXT NOT NULL,               -- 车牌号
        color TEXT,                               -- 车辆颜色
        year INTEGER,                             -- 生产年份
        created_at INTEGER NOT NULL,              -- 创建时间（毫秒时间戳）
        updated_at INTEGER NOT NULL               -- 更新时间（毫秒时间戳）
      )
    ''');

    await db.execute('''
      CREATE TABLE car_fuel_record (
        id INTEGER PRIMARY KEY AUTOINCREMENT,     -- 主键 ID
        car_id INTEGER NOT NULL,                  -- 关联的车辆 ID
        liters REAL NOT NULL,                     -- 加油量（L）
        unit_price REAL NOT NULL,                 -- 支付单价（元/L）
        total_cost REAL NOT NULL,                 -- 支付总额（元）
        mileage INTEGER NOT NULL,                 -- 行驶里程（km）
        mileage_delta INTEGER,                    -- 增加里程（km），本次里程 - 上次里程
        consumption REAL,                         -- 最新油耗（L/100km）
        cost_per_km REAL,                         -- 每公里油费（元）
        date TEXT NOT NULL,                       -- 加油日期（格式：YYYY-MM-DD）
        created_at INTEGER NOT NULL               -- 创建时间（毫秒时间戳）
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE car DROP COLUMN mileage');
    }
    if (oldVersion < 3) {
      // 添加增量计算字段
      await db.execute('ALTER TABLE car_fuel_record ADD COLUMN mileage_delta INTEGER');
      await db.execute('ALTER TABLE car_fuel_record ADD COLUMN consumption REAL');
      await db.execute('ALTER TABLE car_fuel_record ADD COLUMN cost_per_km REAL');
    }
  }

  Future<void> close() async {
    final db = await this.db;
    await db.close();
  }
}
