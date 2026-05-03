import 'package:flutter/material.dart';
import '../../database/models/check_in_task.dart';
import '../../database/models/check_in_record.dart';
import '../../database/models/car.dart';
import '../../database/models/car_fuel_stats.dart';
import '../../repositories/check_in_task_repository.dart';
import '../../repositories/check_in_record_repository.dart';
import '../../repositories/car_repository.dart';
import '../../repositories/car_fuel_record_repository.dart';
import '../../components/empty/empty.dart';
import 'home/check_in_card.dart';
import 'home/car_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _taskRepo = CheckInTaskRepository();
  final _recordRepo = CheckInRecordRepository();
  final _carRepo = CarRepository();
  final _fuelRepo = CarFuelRecordRepository();

  List<CheckInTask> _tasks = [];
  List<CheckInRecord> _todayRecords = [];
  Map<int, int> _totalDaysMap = {};
  List<Car> _cars = [];
  Map<int, CarFuelStats> _fuelStatsMap = {};
  bool _loading = true;

  String get _today {
    final now = DateTime.now();
    return '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final results = await Future.wait([
      _taskRepo.getEnabled(),
      _recordRepo.getByDate(_today),
      _carRepo.getAll(),
    ]);

    final tasks = results[0] as List<CheckInTask>;
    final todayRecords = results[1] as List<CheckInRecord>;
    final cars = results[2] as List<Car>;

    // Calculate total days and fuel stats in parallel
    final totalDaysFutures = tasks
        .where((t) => t.id != null)
        .map((task) async {
      final records = await _recordRepo.getByTask(task.id!);
      final dateCountMap = <String, int>{};
      for (final r in records) {
        dateCountMap[r.date] = (dateCountMap[r.date] ?? 0) + 1;
      }
      return MapEntry(
          task.id!, dateCountMap.values.where((c) => c >= task.frequency).length);
    }).toList();

    final fuelStatsFutures = cars
        .where((c) => c.id != null)
        .map((car) async {
      final records = await _fuelRepo.getByCar(car.id!);
      return MapEntry(car.id!, CarFuelStats.calculate(records));
    }).toList();

    final totalDaysEntries = await Future.wait(totalDaysFutures);
    final fuelStatsEntries = await Future.wait(fuelStatsFutures);

    final totalDaysMap = Map<int, int>.fromEntries(totalDaysEntries);
    final fuelStatsMap = Map<int, CarFuelStats>.fromEntries(fuelStatsEntries);

    if (mounted) {
      setState(() {
        _tasks = tasks;
        _todayRecords = todayRecords;
        _totalDaysMap = totalDaysMap;
        _cars = cars;
        _fuelStatsMap = fuelStatsMap;
        _loading = false;
      });
    }
  }

  int _getTodayCount(int taskId) {
    return _todayRecords.where((r) => r.taskId == taskId).length;
  }

  Future<void> _onCheckIn(CheckInTask task) async {
    if (task.id == null) return;
    await _recordRepo.create(CheckInRecord(
      taskId: task.id!,
      date: _today,
    ));
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IMH'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ..._buildCheckInCards(),
                  const SizedBox(height: 16),
                  ..._buildCarCards(),
                ],
              ),
            ),
    );
  }

  List<Widget> _buildCheckInCards() {
    if (_tasks.isEmpty) {
      return const [
        SizedBox(
          height: 200,
          child: EmptyWidget(
            icon: Icons.checklist_rtl_outlined,
            message: '暂无打卡任务',
          ),
        ),
      ];
    }
    return _tasks.map((task) {
      if (task.id == null) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: CheckInCard(
          task: task,
          todayCount: _getTodayCount(task.id!),
          totalDays: _totalDaysMap[task.id!] ?? 0,
          onCheckIn: () => _onCheckIn(task),
        ),
      );
    }).toList();
  }

  List<Widget> _buildCarCards() {
    if (_cars.isEmpty) {
      return const [
        SizedBox(
          height: 200,
          child: EmptyWidget(
            icon: Icons.directions_car_outlined,
            message: '暂无车辆',
          ),
        ),
      ];
    }
    return _cars.map((car) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: CarCard(
          car: car,
          stats: _fuelStatsMap[car.id!] ?? const CarFuelStats(),
          onDataChanged: _loadData,
        ),
      );
    }).toList();
  }
}
