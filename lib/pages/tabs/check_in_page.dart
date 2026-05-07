import 'package:flutter/material.dart';
import 'package:imh/database/models/check_in_task.dart';
import 'package:imh/database/models/check_in_record.dart';
import 'package:imh/repositories/check_in_task_repository.dart';
import 'package:imh/repositories/check_in_record_repository.dart';
import 'package:imh/components/empty/empty.dart';
import 'package:imh/theme/app_theme.dart';
import 'package:imh/pages/check_in/widgets/check_in_card.dart';

class CheckInPage extends StatefulWidget {
  const CheckInPage({super.key});

  @override
  State<CheckInPage> createState() => CheckInPageState();
}

class CheckInPageState extends State<CheckInPage> {
  final _taskRepo = CheckInTaskRepository();
  final _recordRepo = CheckInRecordRepository();
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  List<CheckInTask> _tasks = [];
  List<CheckInRecord> _todayRecords = [];
  Map<int, int> _totalDaysMap = {};
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
    loadData();
  }

  Future<void> loadData() async {
    final results = await Future.wait([
      _taskRepo.getEnabled(),
      _recordRepo.getByDate(_today),
    ]);

    final tasks = results[0] as List<CheckInTask>;
    final todayRecords = results[1] as List<CheckInRecord>;

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

    final totalDaysEntries = await Future.wait(totalDaysFutures);
    final totalDaysMap = Map<int, int>.fromEntries(totalDaysEntries);

    if (mounted) {
      setState(() {
        _tasks = tasks;
        _todayRecords = todayRecords;
        _totalDaysMap = totalDaysMap;
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
    await loadData();
  }

  void refresh() {
    _refreshIndicatorKey.currentState?.show();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('打卡'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.surface,
              colorScheme.surfaceContainerHighest,
            ],
          ),
        ),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: loadData,
                child: ListView(
                  padding: EdgeInsets.all(AppTheme.spacing.md),
                  children: _buildCheckInCards(),
                ),
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
        padding: EdgeInsets.only(bottom: AppTheme.spacing.md),
        child: CheckInCard(
          task: task,
          todayCount: _getTodayCount(task.id!),
          totalDays: _totalDaysMap[task.id!] ?? 0,
          onCheckIn: () => _onCheckIn(task),
        ),
      );
    }).toList();
  }
}
