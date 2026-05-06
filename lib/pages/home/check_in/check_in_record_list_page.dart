import 'dart:math' show max;
import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../database/models/check_in_task.dart';
import '../../../repositories/check_in_record_repository.dart';
import 'widgets/month_calendar.dart';

class CheckInRecordListPage extends StatefulWidget {
  final CheckInTask task;

  const CheckInRecordListPage({super.key, required this.task});

  @override
  State<CheckInRecordListPage> createState() => _CheckInRecordListPageState();
}

class _CheckInRecordListPageState extends State<CheckInRecordListPage> {
  final _recordRepo = CheckInRecordRepository();
  bool _loading = true;

  Map<String, int> _dateCountMap = {};
  int _totalDays = 0;
  int _monthlyDays = 0;
  int _streakDays = 0;
  List<DateTime> _months = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final taskId = widget.task.id!;
    final frequency = widget.task.frequency;

    final results = await Future.wait([
      _recordRepo.getDateCountMap(taskId),
      _recordRepo.getMonthlyStats(taskId, DateTime.now().year, DateTime.now().month, frequency),
      _recordRepo.getStreakDays(taskId, frequency),
    ]);

    final dateCountMap = results[0] as Map<String, int>;
    final monthlyDays = results[1] as int;
    final streakDays = results[2] as int;

    // Calculate total days (unique dates where count >= frequency)
    final totalDays = dateCountMap.entries.where((e) => e.value >= frequency).length;

    // Build months list from first check-in month to current month (reversed: current first)
    final months = <DateTime>[];
    if (dateCountMap.isNotEmpty) {
      final earliestDate = dateCountMap.keys.reduce((a, b) => a.compareTo(b) < 0 ? a : b);
      final start = DateTime(
        int.parse(earliestDate.substring(0, 4)),
        int.parse(earliestDate.substring(5, 7)),
      );
      var current = DateTime(DateTime.now().year, DateTime.now().month);
      while (!current.isBefore(start)) {
        months.add(current);
        current = DateTime(current.year, current.month - 1);
      }
    }

    if (mounted) {
      setState(() {
        _dateCountMap = dateCountMap;
        _totalDays = totalDays;
        _monthlyDays = monthlyDays;
        _streakDays = streakDays;
        _months = months;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('打卡记录'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
            top: false,
            child: Column(
              children: [
                _buildTaskInfo(colorScheme),
                const SizedBox(height: 16),
                _buildStatsCard(colorScheme),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '打卡日历',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: _buildCalendarList(),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildTaskInfo(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            widget.task.title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$_totalDays',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '天',
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '已坚持',
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(ColorScheme colorScheme) {
    final now = DateTime.now();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: AppTheme.cardDecoration(context),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${now.month}月打卡情况',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(colorScheme, '$_monthlyDays', '天', '本月坚持'),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: colorScheme.outline,
                ),
                Expanded(
                  child: _buildStatItem(colorScheme, '$_streakDays', '天', '连续坚持'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(ColorScheme colorScheme, String value, String unit, String label) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 2),
            Text(
              unit,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarList() {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(16, 0, 16, max(16, MediaQuery.of(context).viewPadding.bottom)),
      itemCount: _months.length,
      separatorBuilder: (_, _) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        final month = _months[index];
        return MonthCalendar(
          year: month.year,
          month: month.month,
          dateCountMap: _dateCountMap,
          frequency: widget.task.frequency,
        );
      },
    );
  }
}
