import 'dart:math' show max;
import 'package:flutter/material.dart';
import 'package:imh/theme/app_theme.dart';
import 'package:imh/database/models/check_in_task.dart';
import 'package:imh/repositories/check_in_record_repository.dart';
import 'package:imh/pages/check_in/widgets/month_calendar.dart';

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

    final totalDays = dateCountMap.entries.where((e) => e.value >= frequency).length;

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
                SizedBox(height: AppTheme.spacing.md),
                _buildStatsCard(colorScheme),
                SizedBox(height: AppTheme.spacing.md),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppTheme.spacing.md),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '打卡日历',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),
                SizedBox(height: AppTheme.spacing.sm + AppTheme.spacing.xs),
                Expanded(
                  child: _buildCalendarList(),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildTaskInfo(ColorScheme colorScheme) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(AppTheme.spacing.md, AppTheme.spacing.md, AppTheme.spacing.md, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(widget.task.title, style: textTheme.headlineMedium),
          SizedBox(width: AppTheme.spacing.sm),
          Text('$_totalDays', style: textTheme.displayLarge),
          SizedBox(width: AppTheme.spacing.xs),
          Text('天', style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant)),
          SizedBox(width: AppTheme.spacing.xs),
          Text('已坚持', style: textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }

  Widget _buildStatsCard(ColorScheme colorScheme) {
    final textTheme = Theme.of(context).textTheme;
    final now = DateTime.now();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppTheme.spacing.md),
      child: Container(
        decoration: AppTheme.cardDecoration(context),
        padding: EdgeInsets.all(AppTheme.spacing.md + AppTheme.spacing.xs),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text('${now.month}月打卡情况', style: textTheme.titleLarge),
            ),
            SizedBox(height: AppTheme.spacing.md),
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
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(value, style: textTheme.headlineMedium?.copyWith(color: colorScheme.onSurface)),
            const SizedBox(width: 2),
            Text(unit, style: textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant)),
          ],
        ),
        SizedBox(height: AppTheme.spacing.xs),
        Text(label, style: textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant)),
      ],
    );
  }

  Widget _buildCalendarList() {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(AppTheme.spacing.md, 0, AppTheme.spacing.md, max(AppTheme.spacing.md, MediaQuery.of(context).viewPadding.bottom)),
      itemCount: _months.length,
      separatorBuilder: (_, _) => SizedBox(height: AppTheme.spacing.md + AppTheme.spacing.xs),
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
